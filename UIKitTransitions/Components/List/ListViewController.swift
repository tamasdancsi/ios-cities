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

    private func setupBindings() {
        /// In the future: use combine latest once it's supported by OpenCombine
        /// https://github.com/OpenCombine/OpenCombine/blob/4977ca158f19738f0cd420a1e5668712f4e28709/RemainingCombineInterface.swift
        viewModel.$featuredCities
            .sink(receiveValue: { [weak self] _ in
                self?.list.reloadData()
            })
            .store(in: &cancellables)

        viewModel.$otherCities
            .sink(receiveValue: { [weak self] _ in
                self?.list.reloadData()
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        list.register(UINib(nibName: String(describing: CityCell.self), bundle: nil),
                      forCellReuseIdentifier: CityCell.cellIdentifier)

        list.rowHeight = UITableView.automaticDimension
        list.estimatedRowHeight = 196
        list.separatorStyle = .none
        list.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0);
        list.sectionHeaderHeight = 60
    }
}

// MARK: - List delegate and date source

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2 // 0: Featured, 1: Others
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.featuredCities.count
        } else if section == 1 {
            return viewModel.otherCities.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.cellIdentifier, for: indexPath) as? CityCell else {
            return UITableViewCell()
        }

        /// Displaying featured city view with preview mode and connecting favorite change event
        if indexPath.section == 0 && viewModel.featuredCities.count > indexPath.row {
            let city = viewModel.featuredCities[indexPath.row]
            cell.setup(cityName: city.name, mode: .cell)
            return cell

        }

        /// Displaying rest city view with preview mode and connecting favorite change event
        else if indexPath.section == 1 && viewModel.otherCities.count > indexPath.row {
            let city = viewModel.otherCities[indexPath.row]
            cell.setup(cityName: city.name, mode: .cell)
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let city = city(atIndexPath: indexPath) else {
            return
        }

        /// Storing selected cell
        selectedCell = tableView.cellForRow(at: indexPath) as? CityCell

        /// Displaying detail screen
        let vc = Assembler.shared.detailViewController(city: city)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }

    /// In the future: create a custom table header class for these
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width - 32, height: list.sectionHeaderHeight))
        label.text = section == 0 ? "Our picks" : "Other cities"
        label.font = .preferredFont(forTextStyle: .headline)

        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: list.sectionHeaderHeight))
        view.backgroundColor = .white
        view.addSubview(label)

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.1

        return view
    }

    // MARK: - Helpers

    private func city(atIndexPath indexPath: IndexPath) -> City? {
        if indexPath.section == 0 && viewModel.featuredCities.count > indexPath.row {
            return viewModel.featuredCities[indexPath.row]
        } else if indexPath.section == 1 && viewModel.otherCities.count > indexPath.row {
            return viewModel.otherCities[indexPath.row]
        }
        return nil
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
