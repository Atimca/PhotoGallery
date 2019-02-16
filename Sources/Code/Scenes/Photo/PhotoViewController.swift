//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import UIKit

class PhotoViewController: UIViewController {

    // MARK: - Propertie
    private let state: State

    // MARK: - UI Componets

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Life Cycle

    init(photo: Photo) {
        state = PhotoViewController.convert(from: photo)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Photo"
        view.addSubview(imageView)
        view.addSubview(nameLabel)

        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                       constant: Constants.Title.top).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: Constants.Title.trailing).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: Constants.Title.leading).isActive = true
        nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor,
                                          constant: Constants.Title.bottom).isActive = true

        render(with: state)
    }
}

// MARK: - Data Driven
extension PhotoViewController {
    private struct State {
        let imageUrl: URL?
        let name: String
    }

    private func render(with state: State) {
        if let url = state.imageUrl {
            imageView.setImage(with: url)
        }
        nameLabel.text = state.name
    }

    private static func convert(from photo: Photo) -> State {
        return State(imageUrl: URL(string: photo.url),
                     name: photo.title)
    }
}

// MARK: - Constants
private extension PhotoViewController {
    enum Constants {
        enum Title {
            static let bottom: CGFloat = -16
            static let leading: CGFloat = 16
            static let top: CGFloat = 16
            static let trailing: CGFloat = -16
        }
    }
}
