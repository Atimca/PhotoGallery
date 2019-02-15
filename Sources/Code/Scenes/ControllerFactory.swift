//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import UIKit

enum ControllerFactory {
    static var makeAlbumsViewController: UIViewController {
        return AlbumsViewController(downloadService: AlbumsService(networkClient: NetworkClient()))
    }

    static func makePhotosViewController(with albumId: Int) -> UIViewController {
        return UIViewController()
    }
}
