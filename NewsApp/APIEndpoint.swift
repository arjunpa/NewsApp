//
//  APIEndpoint.swift
//  NewsApp
//
//  Created by Arjun P A on 19/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

enum APIEndPoint: String, URLFormable {
    case photosAPI = "https://moedemo-93e2e.firebaseapp.com/assignment/NewsApp/articles.json"
    
    func asURL() throws -> URL {
        try self.rawValue.asURL()
    }
}
