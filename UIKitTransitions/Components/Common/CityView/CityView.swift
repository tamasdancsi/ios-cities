//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import UIKit
import ImageSlideshow
import OpenCombine

/// This is a reused view that gets displayed in both the city list cells and on the detail view
/// It would be nicer to split it in the future. For now either a slideshow or a preview photo is presented
class CityView: BaseInjectableViewImpl {

    @IBOutlet weak var viewedCountLabel: UILabel!
    @IBOutlet weak var favoritedCountLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageSlideshow: ImageSlideshow?
    @IBOutlet weak var previewPhoto: UIImageView?

    /// Helper views
    @IBOutlet weak var cityNameBackgroundView: UIView!
    @IBOutlet weak var titleBottom: NSLayoutConstraint!
    @IBOutlet weak var starSize: NSLayoutConstraint!

    private let gradientMaskLayer = CAGradientLayer()
    private let cornerRadius: CGFloat = 15

    private var viewModel: CityViewModel?
    private var cancellable: AnyCancellable?

    override func awakeFromNib() {
        super.awakeFromNib()

        applyCardStyle()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientMaskLayer.frame = cityNameBackgroundView.bounds

        if viewModel?.mode == .cell {
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            layer.shadowPath = shadowPath.cgPath
        }
    }

    @IBAction func onFavoriteButtonTap(_ sender: Any) {
        favoriteButton.layer.removeAllAnimations()
        favoriteButton.pulse(duration: 0.6)
        viewModel?.updateIsFavorite()
    }

    func onViewedCityDetails() {
        viewModel?.handleViewedCityDetails()
    }

    private func updateCitySubscription() {
        /// Subscribing to city changes
        cancellable = viewModel?.$city
            .sink { [weak self] changed in
                guard let changed = changed else {
                    return
                }
                self?.updateCityUI(city: changed)
            }
    }
}

// MARK: - Setting up UI

extension CityView {

    func setup(cityName: String, mode: CityViewModel.Mode) {
        /// In the future: This could be passed from the outside
        self.viewModel = Assembler.shared.cityViewModel(cityName: cityName, mode: mode)
        guard let viewModel = viewModel else {
            return
        }

        switch viewModel.mode {
        case .cell:
            setupCellMode()
        case .detail:
            setupDetailMode()
        }

        setupFavoriteButtonUI()
        setupGradientMaskUI()
        updateCitySubscription()

        if let city = viewModel.city {
            updateCityUI(city: city)
        }
    }

    private func setupGradientMaskUI() {
        gradientMaskLayer.colors = [UIColor.clear.cgColor,
                                    UIColor.black.withAlphaComponent(0.1).cgColor,
                                    UIColor.black.withAlphaComponent(0.4).cgColor]
        gradientMaskLayer.locations = [0, 0.1, 0.7]
        cityNameBackgroundView.layer.mask = gradientMaskLayer
        cityNameBackgroundView.backgroundColor = .black
    }

    private func setupDetailMode() {
        /// Preview is not needed in slideshow mode
        previewPhoto?.removeFromSuperview()

        imageSlideshow?.backgroundColor = .clear
        imageSlideshow?.slideshowInterval = Double.random(in: 2...4)
        imageSlideshow?.contentScaleMode = .scaleAspectFill

        cityNameLabel.font = cityNameLabel.font.withSize(35)
        titleBottom.constant = 25
        starSize.constant = 44
        updateConstraintsIfNeeded()

        updateSlideshowMode()
    }

    private func setupCellMode() {
        guard let city = viewModel?.city else {
            return
        }

        /// Slideshow is not needed in preview mode
        imageSlideshow?.removeFromSuperview()

        if let firstPhoto = city.photos.first {
            previewPhoto?.image = UIImage(named: firstPhoto)
        }

        cityNameLabel.font = cityNameLabel.font.withSize(24)
        titleBottom.constant = 12
        starSize.constant = 30
        updateConstraintsIfNeeded()
    }

    private func setupFavoriteButtonUI() {
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowRadius = 8
        favoriteButton.layer.shadowOffset = .zero
        favoriteButton.layer.shadowOpacity = 0.3
    }
}

// MARK: - Updating UI

extension CityView {

    func updateCityUI(city: City) {
        viewedCountLabel.text = "\(city.viewedCount) "
        favoritedCountLabel.text = "\(city.favoritedCount)"
        cityNameLabel.text = city.name
        updateFavoriteButtonUI(city: city)

        /// ViewModel's city state is still the old one
        if viewModel?.city?.favoritedCount != city.favoritedCount {
            favoritedCountLabel.fadeIn(duration: 0.3)
        }

        if viewModel?.city?.viewedCount != city.viewedCount {
            viewedCountLabel.pulse(duration: 0.5)
        }

        if viewModel?.mode == .detail {
            updateSlideshowMode()
        }
    }

    private func updateSlideshowMode() {
        guard let city = viewModel?.city else {
            return
        }

        let inputs: [ImageSource] = city.photos.compactMap {
            guard let image = UIImage(named: $0) else {
                return nil
            }
            return ImageSource(image: image)
        }
        imageSlideshow?.setImageInputs(inputs)
    }

    private func updateFavoriteButtonUI(city: City) {
        favoriteButton.setImage(UIImage(named: "icon-star-filled")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.tintColor = city.isFavorite ? .yellow : .white
    }
}

// MARK: - Card style

extension CityView {

    private func applyCardStyle() {
        /// Displaying shadow
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
        layer.shouldRasterize = true

        /// Cuts content corners
        contentView?.layer.cornerRadius = cornerRadius
        contentView?.layer.masksToBounds = true
    }

    func removeCardStyle() {
        /// Displaying shadow
        layer.cornerRadius = 0
        layer.masksToBounds = true
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowRadius = 0
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0
        layer.shouldRasterize = true

        /// Cuts content corners
        contentView?.layer.cornerRadius = 0
        contentView?.layer.masksToBounds = false
    }
}
