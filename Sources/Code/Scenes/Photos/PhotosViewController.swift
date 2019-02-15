//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import UIKit

class PhotosViewController: UIViewController {

    // MARK: - Properties

    private let downloadService: AlbumsService
    private var state: State = .loading {
        didSet { render(with: state) }
    }

    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collection
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        return activity
    }()

    // MARK: - Life Cycle

    init(downloadService: AlbumsService) {
        self.downloadService = downloadService
        super.init(nibName: nil, bundle: nil)
        setupLayout()
        render(with: state)
        updateAlbums()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        title = "Albums"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func render(with state: State) {
        switch state {
        case .loading:
            tableView.isHidden = true
            activityIndicator.startAnimating()
        case .success:
            tableView.isHidden = false
            tableView.reloadData()
            activityIndicator.stopAnimating()
        case .error(let message):
            tableView.isHidden = true
            activityIndicator.stopAnimating()

            let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.updateAlbums()
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource
extension PhotosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .success(let albums) = state else { return 0 }
        return albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            case .success(let albums) = state,
            let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.identifier,
                                                     for: indexPath) as? AlbumTableViewCell else {
                                                        return UITableViewCell()
        }
        cell.render(with: albums[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PhotosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .success(let albums) = state else { return }
        let vc = ControllerFactory.makePhotosViewController(with: albums[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Network
private extension PhotosViewController {
    func updateAlbums() {
        downloadService.getAlbums { [weak self] in
            guard let self = self else { return }
            self.state = self.convert(result: $0)
        }
    }
}

// MARK: - ViewState
extension PhotosViewController {
    enum State {
        case loading
        case success(albums: [AlbumTableViewCell.State])
        case error(String)
    }
}

// MARK: - ViewStateConverter
private extension PhotosViewController {
    func convert(result: Result<[Album], NetworkError>) -> AlbumsViewController.State {
        switch result {
        case .success(let albums):
            return .success(albums: albums.map { AlbumTableViewCell.State(id: $0.id, title: $0.title) })
        case .failure:
            return .error("Unknown error")
        }
    }
}