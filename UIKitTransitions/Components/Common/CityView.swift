//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import UIKit
import ImageSlideshow

typealias FavoriteChangedEvent = () -> Void

/// This is a reused view that gets displayed in both the city list cells and on the detail view
/// It would be nicer to split it in the future. For now either a slideshow or a preview photo is presented
class CityView: BaseInjectableViewImpl {

    enum Mode: Int {
        case preview, slideshow
    }

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

    private var mode: Mode = .preview
    private var onFavoriteChanged: FavoriteChangedEvent!

    private let gradientMaskLayer = CAGradientLayer()
    private let cornerRadius: CGFloat = 15

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientMaskLayer.frame = cityNameBackgroundView.bounds

        if mode == .preview {
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            layer.shadowPath = shadowPath.cgPath
        }
    }

    @IBAction func onFavoriteButtonTap(_ sender: Any) {
        onFavoriteChanged()
    }
}

// MARK: - Setting up UI

extension CityView {

    func setup(city: City, mode: Mode, onFavoriteChanged: @escaping FavoriteChangedEvent) {
        self.onFavoriteChanged = onFavoriteChanged
        self.mode = mode

        switch mode {
        case .preview:
            setupPreviewMode(city: city)
        case .slideshow:
            setupSlideshowMode(city: city)
        }

        setupFavoriteButtonUI()
        setupGradientMaskUI()
        updateCityUI(city: city)
    }

    private func setupGradientMaskUI() {
        gradientMaskLayer.colors = [UIColor.clear.cgColor,
                                    UIColor.black.withAlphaComponent(0.1).cgColor,
                                    UIColor.black.withAlphaComponent(0.4).cgColor]
        gradientMaskLayer.locations = [0, 0.1, 0.7]
        cityNameBackgroundView.layer.mask = gradientMaskLayer
        cityNameBackgroundView.backgroundColor = .black
    }

    private func setupSlideshowMode(city: City) {
        /// Preview is not needed in slideshow mode
        previewPhoto?.removeFromSuperview()

        imageSlideshow?.backgroundColor = .clear
        imageSlideshow?.slideshowInterval = Double.random(in: 2...4)
        imageSlideshow?.contentScaleMode = .scaleAspectFill

        cityNameLabel.font = cityNameLabel.font.withSize(35)
        titleBottom.constant = 25
        starSize.constant = 44
        updateConstraintsIfNeeded()

        updateSlideshowMode(city: city)
    }

    private func setupPreviewMode(city: City) {
        /// Slideshow is not needed in preview mode
        imageSlideshow?.removeFromSuperview()

        if let firstPhoto = city.photos.first {
            previewPhoto?.image = UIImage(named: firstPhoto)
        }

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

        cityNameLabel.font = cityNameLabel.font.withSize(22)
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

        if mode == .slideshow {
            updateSlideshowMode(city: city)
        }
    }

    private func updateSlideshowMode(city: City) {
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
