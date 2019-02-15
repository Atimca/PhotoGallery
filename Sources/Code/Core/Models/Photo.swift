//
// Copyright © 2019 Smirnov Maxim. All rights reserved. 
//

import Foundation

struct Photo: Codable {
    let albumID: Int
    let id: Int
    let thumbnailURL: String
    let title: String
    let url: String
}
