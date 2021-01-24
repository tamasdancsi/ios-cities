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

    func setup(cityName: String, mode: CityViewModel.Mode) {
        cityView.setup(cityName: cityName, mode: mode)
    }
}
