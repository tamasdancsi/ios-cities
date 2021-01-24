//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import UIKit

/// A very simplistic solution for dependency injection
class Assembler {

    static let shared = Assembler()

    var listViewController: ListViewController {
        ListViewController(viewModel: listViewModel)
    }

    func detailViewController(city: City) -> DetailViewController {
        DetailViewController(viewModel: detailViewModel(city: city))
    }

    func detailViewModel(city: City) -> DetailViewModel {
        DetailViewModelImpl(city: city)
    }

    func cityViewModel(cityName: String, mode: CityViewModel.Mode) -> CityViewModel {
        CityViewModel(cityInteractor: cityInteractor, cityName: cityName, mode: mode)
    }

    var listViewModel: ListViewModel {
        ListViewModel(cityInteractor: cityInteractor)
    }

    var cityInteractor: CityInteractor {
        CityInteractorImpl(cityRepository: cityRepository)
    }

    var cityRepository: CityRepository {
        CityRepositoryImpl.shared
    }
}
