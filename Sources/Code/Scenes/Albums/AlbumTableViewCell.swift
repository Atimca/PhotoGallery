//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    static let identifier = String(describing: AlbumTableViewCell.self)

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.Label.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                       constant: Constants.Label.leading).isActive = true
        label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor,
                                        constant: Constants.Label.trailing).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlbumTableViewCell {
    struct State {
        let id: Int
        let title: String
    }
}

// MARK: - Constants
private extension AlbumTableViewCell {
    enum Constants {
        enum Label {
            static let leading: CGFloat = 16
            static let trailing: CGFloat = -16
            static let fontSize: CGFloat = 14
        }
    }
}
