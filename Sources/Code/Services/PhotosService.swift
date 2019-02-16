//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import Foundation

struct PhotosService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

extension PhotosService {
    func getPhotos(albumId: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        networkClient.performGet(endpoint: Constants.endpoint(with: albumId), for: Array<Photo>.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

private extension PhotosService {
    enum Constants {
        static func endpoint(with albumId: Int) -> URL {
            return URL(string: "https://jsonplaceholder.typicode.com/photos?albumId=\(albumId)")!
        }
    }
}
