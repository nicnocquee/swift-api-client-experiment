//
//  MarvelResponse.swift
//  MarvelClient
//
//  Created by Nico Prananta on 2020/04/27.
//  Copyright © 2020 nico.fyi. All rights reserved.
//

import Foundation

public struct MarvelResponse<Results: Decodable>: Decodable {
    public let status: String?
    public let code: Int
    public let data: MarvelResponseData<Results>?
}

public struct MarvelResponseData<Results: Decodable>: Decodable {
    public let offset: Int
    public let limit: Int
    public let total: Int
    public let count: Int
    public let results: Results
}
