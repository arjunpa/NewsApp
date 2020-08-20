//
//  KeyedDecodingContainer.swift
//  NewsApp
//
//  Created by Arjun P A on 19/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

extension KeyedDecodingContainerProtocol {
    
    func decodeURLByAddingPercentEncoding(_ type: URL.Type, forKey key: Self.Key) throws -> URL {
        var urlString = try self.decode(String.self, forKey: key)
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
        guard let url = URL(string: urlString) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "URL can't be formed after adding percent encoding")
        }
        return url
    }
}
