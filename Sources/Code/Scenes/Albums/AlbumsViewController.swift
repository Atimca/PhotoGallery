//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import UIKit

class AlbumsViewController: UIViewController {

    // MARK: - Properties

    private let downloadService: AlbumsService
    private var state: State = .loading {
        didSet { render(with: state) }
    }

    // MARK: - UI Components
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.identifier)
        table.rowHeight = Constants.TableView.rowHeight
        return table
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let style: UIActivityIndicatorView.Style
        if #available(iOS 13.0, *) {
            style = .medium
        } else {
            style = .gray
        }
        let activity = UIActivityIndicatorView(style: style)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        return activity
    }()

    // MARK: - Life Cycle

    init(downloadService: AlbumsService) {
        self.downloadService = downloadService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        updateAlbums()
    }

    // MARK: - Layout

    private func setupLayout() {
        title = "Albums"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
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
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource
extension AlbumsViewController: UITableViewDataSource {
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
extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard case .success(let albums) = state else { return }
        let vc = ControllerFactory.makePhotosViewController(with: albums[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Network
extension AlbumsViewController {
    private func updateAlbums() {
        state = .loading
        downloadService.getAlbums { [weak self] in
            guard let self = self else { return }
            self.state = self.convert(result: $0)
        }
    }
}

// MARK: - ViewState
extension AlbumsViewController {
    enum State {
        case loading
        case success(albums: [AlbumTableViewCell.State])
        case error(String)
    }
}

// MARK: - ViewStateConverter
private extension AlbumsViewController {
    func convert(result: Result<[Album], NetworkError>) -> AlbumsViewController.State {
        switch result {
        case .success(let albums):
            return .success(albums: albums.map { AlbumTableViewCell.State(id: $0.id, title: $0.title) })
        case .failure:
            return .error("Unknown error")
        }
    }
}

// MARK: - Constants
private extension AlbumsViewController {
    enum Constants {
        enum TableView {
            static let rowHeight: CGFloat = 44
        }
    }
}
