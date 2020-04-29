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
    public let code: String
    public let data: MarvelResponseData<Results>?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case code = "code"
        case data = "data"
    }

     public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let status = try? container.decode(String.self, forKey: .status)
        let codeString = try? container.decode(String.self, forKey: .code)
        let codeInt = try? container.decode(Int.self, forKey: .code)
        let data = try? container.decode(MarvelResponseData<Results>.self, forKey: .data)

        self.status = status

        // the code can be string or int from the server
        self.code = codeString ?? String(describing: codeInt ?? 0)
        self.data = data
   }
}

public struct MarvelResponseData<Results: Decodable>: Decodable {
    public let offset: Int?
    public let limit: Int?
    public let total: Int?
    public let count: Int?
    public let results: Results
}
