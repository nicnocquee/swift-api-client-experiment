//
//  MarvelImage.swift
//  MarvelClient
//
//  Created by Nico Prananta on 2020/04/27.
//  Copyright © 2020 nico.fyi. All rights reserved.
//

import Foundation

public struct MarvelImage: Decodable {
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case fileExtension = "extension"
    }

    var path: String
    var fileExtension: String

    var url: URL? {
        return  URL(string: "\(path).\(fileExtension)")
    }
}
