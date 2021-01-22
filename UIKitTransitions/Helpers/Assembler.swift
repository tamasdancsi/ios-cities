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
        DetailViewModel(cityInteractor: cityInteractor, city: city)
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
