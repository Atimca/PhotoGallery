//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: PhotoCollectionViewCell.self)
}

// MARK: - DataDriven
extension PhotoCollectionViewCell {
    struct State {
        let imageUrl: URL
        let title: String
    }

    func render(with state: State) {

    }
}
