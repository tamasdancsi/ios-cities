//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import OpenCombine

/// Skipping exposing only a protocol here since it's still too annoying to write protocols for Published values
class ListViewModel: ObservableObject {

    @Published var cities: [City] = []

    var objectWillChange: ObservableObjectPublisher {
        ObservableObjectPublisher()
    }

    private let cityInteractor: CityInteractor
    private var cancellables: Set<AnyCancellable> = []

    init(cityInteractor: CityInteractor) {
        self.cityInteractor = cityInteractor
    }

    func updateIsFavorite(index: Int) {
        cityInteractor.updateIsFavorite(city: cities[index])

        /// Refetching the city list from the datasource after the change
        updateCities()
    }

    func updateCities() {
        cities = cityInteractor.getCities()
    }
}
