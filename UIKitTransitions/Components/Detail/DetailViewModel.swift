//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import Foundation
import OpenCombine

/// Skipping exposing only a protocol here since it's still too annoying to write protocols for Published values
class DetailViewModel: OpenCombine.ObservableObject {

    @OpenCombine.Published var city: City

    var cityURL: URL? {
        URL(string: "https://booking.com/\(city.name.trimmed)")
    }

    var objectWillChange: ObservableObjectPublisher {
        ObservableObjectPublisher()
    }

    private let cityInteractor: CityInteractor

    init(cityInteractor: CityInteractor, city: City) {
        self.cityInteractor = cityInteractor
        self.city = city
    }

    func updateIsFavorite() {
        cityInteractor.updateIsFavorite(city: city)

        /// Refetching the updated city from the datasource after the change
        if let updatedCity = cityInteractor.getCity(name: city.name) {
            city = updatedCity
        }
    }
}
