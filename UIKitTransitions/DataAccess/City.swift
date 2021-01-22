//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

struct City {

    let name: String
    let description: String
    let photos: [String]
    let isFeatured: Bool

    /// Can be updated based on user interaction
    var viewedCount: Int
    var favoritedCount: Int
    var isFavorite: Bool
}
