//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var visitButton: ActionButton!
    @IBOutlet weak var backButton: ActionButton!

    @IBOutlet weak var cityView: CityView!
    @IBOutlet weak var cityViewTop: NSLayoutConstraint!
    @IBOutlet weak var cityViewRight: NSLayoutConstraint!
    @IBOutlet weak var cityViewLeft: NSLayoutConstraint!

    private let viewModel: DetailViewModel

    private let cityViewAnimationDuration: TimeInterval = 0.2
    private let fadeInAnimationDuration: TimeInterval = 0.5
    private var isTrackingPanLocation = false
    private var panGestureRecognizer: UIPanGestureRecognizer!

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DetailViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                      action: #selector(panRecognized(recognizer:)))
        panGestureRecognizer.delegate = self
        scrollView.addGestureRecognizer(panGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startIntroAnimation()

        cityView.onViewedCityDetails()
    }

    private func setupUI() {
        /// Displaying city view with slideshow mode and connecting favorite change event
        cityView.setup(cityName: viewModel.city.name, mode: .detail)

        descriptionView.text = viewModel.city.description
        visitButton.setTitle("Visit", for: .normal)
        backButton.setTitle("Back", for: .normal)

        descriptionView.alpha = 0
        backButton.alpha = 0
        visitButton.alpha = 0
    }

    @IBAction func onVisitButtonTap(_ sender: Any) {
        if let url = viewModel.cityURL {
            UIApplication.shared.open(url)
        }
    }

    @IBAction func onBackButtonTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Intro animation

extension DetailViewController {

    func startIntroAnimation() {
        UIView.animate(withDuration: cityViewAnimationDuration) {
            self.cityViewTop.constant = 0
            self.cityViewRight.constant = 0
            self.cityViewLeft.constant = 0

            self.view.layoutIfNeeded()
        } completion: { finished in
            self.cityView.removeCardStyle()

            if finished {
                UIView.animate(withDuration: self.fadeInAnimationDuration, animations: {
                    self.descriptionView.alpha = 1
                    self.backButton.alpha = 1
                    self.visitButton.alpha = 1
                })

                /// If content is too long, scrolls to the top
                self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.scrollView.contentInset.top), animated: true)
            }
        }

        cityView.startIntroAnimation(delay: cityViewAnimationDuration)
    }
}

// MARK: - Dismissing on drag

extension DetailViewController: UIGestureRecognizerDelegate {

    @objc public func panRecognized(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            recognizer.setTranslation(CGPoint.zero, in: scrollView)

            isTrackingPanLocation = true
        } else if recognizer.state != .ended &&
                    recognizer.state != .cancelled &&
                    recognizer.state != .failed &&
                    isTrackingPanLocation {
            let panOffset = recognizer.translation(in: scrollView)

            // determine offset of the pan from the start here.
            // When offset is far enough from table view top edge -
            // dismiss your view controller. Additionally you can
            // determine if pan goes in the wrong direction and
            // then reset flag isTrackingPanLocation to false

            let eligiblePanOffset = panOffset.y > 300
            if eligiblePanOffset {
                recognizer.isEnabled = false
                recognizer.isEnabled = true
                dismiss(animated: true, completion: nil)
            }

            if panOffset.y < 0 {
                isTrackingPanLocation = false
            }
        } else {
            isTrackingPanLocation = false
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith
                                    otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
