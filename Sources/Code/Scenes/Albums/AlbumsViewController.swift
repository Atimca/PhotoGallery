//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import UIKit

class AlbumsViewController: UIViewController {

    private let viewConverter: AlbumsViewStateConverter
    private let downloadService: AlbumsService

    init(viewConverter: AlbumsViewStateConverter, downloadService: AlbumsService) {
        self.viewConverter = viewConverter
        self.downloadService = downloadService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlbumsViewController {
    enum State {
        case success(albums: [AlbumTableViewCell.State])
        case error(String)
    }
}
