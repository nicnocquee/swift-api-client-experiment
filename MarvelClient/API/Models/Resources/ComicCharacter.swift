//
//  ComicCharacter.swift
//  MarvelClient
//
//  Created by Nico Prananta on 2020/04/27.
//  Copyright © 2020 nico.fyi. All rights reserved.
//

import Foundation

public struct ComicCharacter: Decodable, CustomStringConvertible {
    let id: Int
    let name: String?
    let thumbnail: MarvelImage?

    public var description: String {
        return "{ id: \(id), name: \(name ?? ""), thumbnail: \(thumbnail?.url?.absoluteString ?? "") }"
    }
}
