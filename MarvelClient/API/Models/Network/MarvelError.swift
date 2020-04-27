//
//  MarvelError.swift
//  MarvelClient
//
//  Created by Nico Prananta on 2020/04/27.
//  Copyright © 2020 nico.fyi. All rights reserved.
//

import Foundation

public enum MarvelError: Error {
    case decoding
    case encoding
    case server(message: String)
}
