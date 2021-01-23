//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import OpenCombine

/// Skipping exposing only a protocol here since it's still too annoying to write protocols for Published values
class ListViewModel: ObservableObject {

    @Published var featuredCities: [City] = []
    @Published var otherCities: [City] = []

    var objectWillChange: ObservableObjectPublisher {
        ObservableObjectPublisher()
    }

    private let cityInteractor: CityInteractor
    private var cancellables: Set<AnyCancellable> = []

    init(cityInteractor: CityInteractor) {
        self.cityInteractor = cityInteractor
    }

    func updateIsFavorite(city: City) {
        cityInteractor.updateIsFavorite(city: city)

        /// Refetching the city list from the datasource after the change
        updateCities()
    }

    func updateCities() {
        let cities = cityInteractor.getCities()
        featuredCities = cities.filter { $0.isFeatured }.sorted(by: { $0.name < $1.name })
        otherCities = cities.filter { !$0.isFeatured }.sorted(by: { $0.name < $1.name })
    }
}
