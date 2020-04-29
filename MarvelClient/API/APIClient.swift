//
//  APIClient.swift
//  MarvelClient
//
//  Created by Nico Prananta on 2020/04/27.
//  Copyright © 2020 nico.fyi. All rights reserved.
//

import Foundation

public typealias ResultCallback<Value> = (Result<Value, Error>) -> Void
public protocol APIClient {
    func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.ResponseResult> ) -> Void
}

public class MarvelAPIClient: APIClient {
    private let session: URLSession

    private let baseEndpointUrl: URL
    private let publicKey: String
    private let privateKey: String

    public init (publicKey: String,
                 privateKey: String,
                 baseEndpointUrl: String = "https://gateway.marvel.com:443/v1/public/",
                 session: URLSession = URLSession(configuration: .default)) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.baseEndpointUrl = URL(string: baseEndpointUrl)!
        self.session = session
    }

    public func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.ResponseResult>) {
        let endpoint = request.endpoint(baseEndpointUrl: baseEndpointUrl, publicKey: publicKey, privateKey: privateKey)

        let task = session.dataTask(with: endpoint) { (data, response, error) in
            if let data = data {
                do {
                    let marvelResponse = try JSONDecoder().decode(MarvelResponse<T.ResponseResult>.self, from: data)
                    
                    guard marvelResponse.code.description == "200" else {
                        throw MarvelError.server(message: marvelResponse.code.description)
                    }
                    if let marvelResponseData = marvelResponse.data {
                        completion(.success(marvelResponseData.results))
                    } else if let message = marvelResponse.status {
                        completion(.failure(MarvelError.server(message: message)))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(MarvelError.server(message: "Failed")))
            }
        }

        task.resume()
    }
}
