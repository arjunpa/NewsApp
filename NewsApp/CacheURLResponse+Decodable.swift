//
//  CacheURLResponse+Decodable.swift
//  PhotoCollection
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

extension CachedURLResponse {
    
    func decoded<T: Decodable>(with decodableType: T.Type) throws -> T {
        try JSONDecoder().decode(T.self, from: self.data) as T
    }
}
