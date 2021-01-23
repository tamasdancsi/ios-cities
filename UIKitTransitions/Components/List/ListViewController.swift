//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import UIKit
import Foundation
import OpenCombine

class ListViewController: UIViewController {

    @IBOutlet weak var list: UITableView!

    private let viewModel: ListViewModel
    private let expandTransition = ExpandTransition()

    private var selectedCell: CityCell?
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ListViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.updateCities()
    }

    private func setupBindings() {
        viewModel.$cities
            .sink(receiveValue: { [weak self] _ in
                self?.list.reloadData()
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        list.register(UINib(nibName: String(describing: CityCell.self), bundle: nil),
                      forCellReuseIdentifier: CityCell.cellIdentifier)

        list.rowHeight = UITableView.automaticDimension
        list.estimatedRowHeight = 80
        list.separatorStyle = .none
        list.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0);
    }
}

// MARK: - List delegate and date source

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.cellIdentifier, for: indexPath) as? CityCell,
              viewModel.cities.count > indexPath.row else {
            return UITableViewCell()
        }

        /// Displaying city view with preview mode and connecting favorite change event
        cell.setup(city: viewModel.cities[indexPath.row]) { [weak self] in
            self?.viewModel.updateIsFavorite(index: indexPath.row)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.cities.count > indexPath.row else {
            return
        }

        /// Storing selected cell
        selectedCell = tableView.cellForRow(at: indexPath) as? CityCell

        /// Displaying detail screen
        let vc = Assembler.shared.detailViewController(city: viewModel.cities[indexPath.row])
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - Custom transition

extension ListViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        expandTransition.mode = .present
        expandTransition.selectedCell = selectedCell

        return expandTransition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        expandTransition.mode = .dismiss

        return expandTransition
    }
}
