//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import Foundation

extension String {

    var trimmed: String {
        filter { !$0.isWhitespace }
    }
}
