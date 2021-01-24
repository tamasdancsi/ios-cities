//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import Foundation
import OpenCombine

/// Skipping exposing only a protocol here since it's still too annoying to write protocols for Published values
class CityViewModel: OpenCombine.ObservableObject {

    enum Mode: Int {
        case cell, detail
    }

    @OpenCombine.Published var city: City?
    @OpenCombine.Published var mode: Mode = .cell

    var cityURL: URL? {
        guard let trimmedCityName = city?.name.trimmed else {
            return nil
        }
        return URL(string: "https://booking.com/\(trimmedCityName)")
    }

    var objectWillChange: ObservableObjectPublisher {
        ObservableObjectPublisher()
    }

    private let cityInteractor: CityInteractor
    private var cancellables: Set<AnyCancellable> = []

    init(cityInteractor: CityInteractor, cityName: String, mode: Mode) {
        self.cityInteractor = cityInteractor
        self.city = cityInteractor.getCity(name: cityName)
        self.mode = mode

        /// Registering to city list change events
        cityInteractor.cityChanged.sink { [weak self] city in
            self?.handleCityChange(changed: city)
        }
        .store(in: &cancellables)
    }

    func updateIsFavorite() {
        guard let city = city else {
            return
        }
        cityInteractor.updateIsFavorite(city: city)
    }

    func handleViewedCityDetails() {
        guard let city = city else {
            return
        }
        cityInteractor.increaseViewCount(city: city)
    }

    private func handleCityChange(changed: City) {
        guard city?.name == changed.name else {
            return
        }
        city = changed
    }
}
