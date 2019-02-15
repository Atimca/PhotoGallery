//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import Foundation

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let thumbnailUrl: String
    let title: String
    let url: String
}
