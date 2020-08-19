//
//  RequestEncoding.swift
//  PhotoCollection
//
//  Created by Arjun P A on 18/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol RequestEncoding {
    func encode(_ request: Requestable, with parameters: RequestParameters?) throws -> URLRequest
}

struct GetRequestEncoding: RequestEncoding {
    
    func encode(_ request: Requestable, with parameters: RequestParameters?) throws -> URLRequest {
        return try RequestURLEncoding().encode(request, with: parameters)
    }
}

struct PostRequestEncoding: RequestEncoding {
    
    func encode(_ request: Requestable, with parameters: RequestParameters?) throws -> URLRequest {
        return try RequestJSONEncoding().encode(request, with: parameters)
    }
}
