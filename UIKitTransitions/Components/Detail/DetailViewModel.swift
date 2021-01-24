//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import Foundation

protocol DetailViewModel {

    var city: City { get }
    var cityURL: URL? { get }
}

class DetailViewModelImpl: DetailViewModel {

    var city: City

    var cityURL: URL? {
        URL(string: "https://booking.com/\(city.name.trimmed)")
    }

    init(city: City) {
        self.city = city
    }
}
