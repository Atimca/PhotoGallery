//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import UIKit

class AlbumsViewController: UIViewController {

    // MARK: - Properties

    private let downloadService: AlbumsService

    // MARK: - Life Cycle

    init(downloadService: AlbumsService) {
        self.downloadService = downloadService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewState
extension AlbumsViewController {
    enum State {
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
