//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var cityView: CityView!

    static var cellIdentifier: String {
        String(describing: CityView.self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setup(city: City, onFavoriteChanged: @escaping FavoriteChangedEvent) {
        cityView.setup(city: city, mode: .preview, onFavoriteChanged: onFavoriteChanged)
    }
}
