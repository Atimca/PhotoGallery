//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

struct AlbumsViewStateConverter {
    func convert(result: Result<[Album], NetworkError>) -> AlbumsViewController.State {
        switch result {
        case .success(let albums):
            return .success(albums: albums.map { AlbumTableViewCell.State(id: $0.id, title: $0.title) })
        case .failure:
            return .error("Unknown error")
        }
    }
}
