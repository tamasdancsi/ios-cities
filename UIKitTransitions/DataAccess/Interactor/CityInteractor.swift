//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import OpenCombine

protocol CityInteractor {

    var cityChanged: PassthroughSubject<City, Never> { get }

    func getCities() -> [City]
    func getCity(name: String) -> City?
    func updateIsFavorite(city: City)
}

struct CityInteractorImpl: CityInteractor {

    private let cityRepository: CityRepository

    var cityChanged: PassthroughSubject<City, Never> {
        cityRepository.cityChanged
    }

    init(cityRepository: CityRepository) {
        self.cityRepository = cityRepository
    }

    func getCities() -> [City] {
        cityRepository.getCities()
    }

    func getCity(name: String) -> City? {
        cityRepository.getCity(name: name)
    }

    func updateIsFavorite(city: City) {
        cityRepository.updateIsFavorite(city: city)
    }
}
