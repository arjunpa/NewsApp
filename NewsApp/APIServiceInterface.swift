//
//  APIServiceInterface.swift
//  NewsApp
//
//  Created by Arjun P A on 18/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol APIServiceInterface {
    func request<T: Decodable>(for request: Requestable, completion: @escaping (Result<APIHTTPDecodableResponse<T>, Error>) -> Void)
}
