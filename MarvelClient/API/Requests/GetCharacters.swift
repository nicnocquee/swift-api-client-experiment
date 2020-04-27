//
//  GetCharacters.swift
//  MarvelClient
//
//  Created by Nico Prananta on 2020/04/27.
//  Copyright © 2020 nico.fyi. All rights reserved.
//

import Foundation

public struct GetCharacters: APIRequest {
    public typealias ResponseResult = [ComicCharacter]

    public var path: String {
        return "characters"
    }

    public let limit: Int?
    public let offset: Int?

    public init(limit: Int? = nil,
                offset: Int? = nil) {
        self.limit = limit
        self.offset = offset
    }
}
