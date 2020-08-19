//
//  Request.swift
//  PhotoCollection
//
//  Created by Arjun P A on 18/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct Request: Requestable {
    
    let url: URLFormable
    let httpMethod: RequestMethod
    let parameters: RequestParameters?
    let headers: RequestHeaders?
    let encoding: RequestEncoding
    
    init(url: URLFormable,
         method: RequestMethod,
         parameters: RequestParameters?,
         headers: RequestHeaders?,
         encoding: RequestEncoding) {
        self.url = url
        self.httpMethod = method
        self.parameters = parameters
        self.headers = headers
        self.encoding = encoding
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(with: self.url, method: self.httpMethod, headers: self.headers)
        request.allHTTPHeaderFields = self.headers
        if let parameters = self.parameters {
            request = try self.encoding.encode(request, with: parameters)
        }
        return request
    }
}

struct CacheableRequest: CacheRequestable {
    
    let request: Request
    
    let expiry: CacheExpiry
    
    init(request: Request, expiry: CacheExpiry) {
        self.request = request
        self.expiry = expiry
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlRequest = try self.request.asURLRequest()
        guard let method = urlRequest.httpMethod, RequestMethod(rawValue: method) == .some(.get) else {
            throw APIServiceError.CacheableRequestError.invalidMethod
        }
        return urlRequest
    }
}
