//
//  Requestable.swift
//  NewsApp
//
//  Created by Arjun P A on 18/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

typealias RequestParameters = [String: Any]
typealias RequestHeaders = [String: String]

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

enum CacheExpiry {
    case never
    case aged(TimeInterval)
}

protocol Requestable {
    func asURLRequest() throws -> URLRequest
}

extension URLRequest: Requestable {
    
    func asURLRequest() throws -> URLRequest {
        return self
    }
}

protocol CacheRequestable: Requestable  {
    var expiry: CacheExpiry { get }
}
