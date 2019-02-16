//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import UIKit

class PhotosViewController: UIViewController {

    // MARK: - Properties

    private let downloadService: PhotosService
    private let albumId: Int
    private var state: State = .loading {
        didSet { render(with: state) }
    }

    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.minimumLineSpacing = Constants.Collection.spacing
        flow.minimumInteritemSpacing = Constants.Collection.spacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = .white
        return collection
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        return activity
    }()

    // MARK: - Life Cycle

    init(albumId: Int, downloadService: PhotosService) {
        self.albumId = albumId
        self.downloadService = downloadService
        super.init(nibName: nil, bundle: nil)
        setupLayout()
        render(with: state)
        updatePhotos()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        title = "Photos"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func render(with state: State) {
        switch state {
        case .loading:
            collectionView.isHidden = true
            activityIndicator.startAnimating()
        case .success:
            collectionView.isHidden = false
            collectionView.reloadData()
            activityIndicator.stopAnimating()
        case .error(let message):
            collectionView.isHidden = true
            activityIndicator.stopAnimating()

            let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.updatePhotos()
            }
            alert.addAction(action)
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard case .success(let photos) = state else { return 0 }
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            case .success(let albums) = state,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                          for: indexPath) as? PhotoCollectionViewCell else {
                                                            return UICollectionViewCell()
        }
        cell.render(with: albums[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacingDelta = Constants.Collection.rowsPerLine * Constants.Collection.spacing
        let width = collectionView.bounds.width / Constants.Collection.rowsPerLine - spacingDelta
        return CGSize(width: width, height: width + Constants.Collection.heightInset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        guard case .success(let albums) = state else { return }
        //        let vc = ControllerFactory.makePhotosViewController(with: albums[indexPath.row].id)
        //        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Network
private extension PhotosViewController {
    func updatePhotos() {
        downloadService.getPhotos(albumId: albumId) { [weak self] in
            guard let self = self else { return }
            self.state = self.convert(result: $0)
        }
    }
}

// MARK: - ViewState
extension PhotosViewController {
    enum State {
        case loading
        case success(photos: [PhotoCollectionViewCell.State])
        case error(String)
    }
}

// MARK: - ViewStateConverter
private extension PhotosViewController {
    func convert(result: Result<[Photo], NetworkError>) -> PhotosViewController.State {
        switch result {
        case .success(let photos):
            return .success(photos: photos.compactMap { photo in
                guard let url = URL(string: photo.thumbnailUrl) else { return nil }
                return PhotoCollectionViewCell.State(imageUrl: url, title: photo.title)
            })
        case .failure:
            return .error("Unknown error")
        }
    }
}

// MARK: - Constants
private extension PhotosViewController {
    enum Constants {
        enum Collection {
            static let rowsPerLine: CGFloat = 3
            static let spacing: CGFloat = 4
            static let heightInset: CGFloat = 20
        }
    }
}
