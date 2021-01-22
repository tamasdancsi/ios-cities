//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import UIKit
import OpenCombine

class DetailViewController: UIViewController {

    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var cityView: CityView!
    @IBOutlet weak var visitButton: ActionButton!
    @IBOutlet weak var backButton: ActionButton!

    private let viewModel: DetailViewModel
    private var cancellables: Set<AnyCancellable> = []

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
        setupBindings()
    }

    private func setupBindings() {
        viewModel.$city
            .sink(receiveValue: { [weak self] city in
                self?.cityView.updateCityUI(city: city)
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        /// Displaying city view with slideshow mode and connecting favorite change event
        cityView.setup(city: viewModel.city, mode: .slideshow) { [weak self] in
            self?.viewModel.updateIsFavorite()
        }

        descriptionView.text = viewModel.city.description
        visitButton.setTitle("Visit", for: .normal)
        backButton.setTitle("Back", for: .normal)
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
