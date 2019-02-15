//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import Foundation

struct AlbumsService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

extension AlbumsService {
    func getAlbums(completion: @escaping (Result<[Album], NetworkError>) -> Void) {
        networkClient.performGet(endpoint: Constants.endpoint, for: Array<Album>.self, completion: completion)
    }
}

private extension AlbumsService {
    enum Constants {
        static let endpoint = URL(string: "https://jsonplaceholder.typicode.com/albums")!
    }
}
