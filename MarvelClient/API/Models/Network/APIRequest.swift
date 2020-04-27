//
//  APIRequest.swift
//  MarvelClient
//
//  Created by Nico Prananta on 2020/04/27.
//  Copyright © 2020 nico.fyi. All rights reserved.
//

import Foundation
import CryptoKit

public protocol APIRequest: Encodable {
    associatedtype ResponseResult: Decodable
    var path: String { get }
    var method: String { get }
}

public extension APIRequest {
    var method: String {
        return "GET"
    }
}

public extension APIRequest {
    func encodeParams () throws -> [URLQueryItem] {
        let paramsData = try JSONEncoder().encode(self) // 1
        let parameters = try JSONDecoder().decode([String: ParamValue].self, from: paramsData) // 2
        return parameters.map { URLQueryItem(name: $0, value: $1.description) } //3
    }
}


public extension APIRequest {
    func endpoint(baseEndpointUrl: URL, publicKey: String, privateKey: String) -> URL {
        guard let baseUrl = URL(string: self.path, relativeTo: baseEndpointUrl) else {
            fatalError("Bad resourceName: \(self.path)")
        }

        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!

        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = Insecure.MD5.hash(data: Data("\(timestamp)\(privateKey)\(publicKey)".utf8))
        let commonQueryItems = [
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: hash.compactMap { String(format: "%02x", $0) }.joined()),
            URLQueryItem(name: "apikey", value: publicKey)
        ]

        let customQueryItems: [URLQueryItem]

        do {
            customQueryItems = try self.encodeParams()
        } catch {
            fatalError("Wrong parameters: \(error)")
        }

        components.queryItems = commonQueryItems + customQueryItems

        return components.url!
    }
}

enum ParamValue: Decodable, CustomStringConvertible {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let string = try? container.decode(String.self) {
            self = .string(string)
        }  else if let bool = try? container.decode(Bool.self) {
           self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
           self = .int(int)
        } else if let double = try? container.decode(Double.self) {
           self = .double(double)
        } else {
            throw MarvelError.decoding
        }
    }

    var description: String {
        switch self {
        case .string(let string):
            return string
        case .bool(let bool):
            return String(describing: bool)
        case .int(let int):
            return String(describing: int)
        case .double(let double):
            return String(describing: double)
        }
    }
}
