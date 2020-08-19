//
//  APIService.swift
//  NewsApp
//
//  Created by Arjun P A on 19/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

class APIService: APIServiceInterface {
    
    private let session: URLSession
    
    init(sessionContext: SessionContext = DataSessionContext.commonContext) {
        self.session = sessionContext.session
    }
    
    func request<T>(for request: Requestable, completion: @escaping (Result<APIHTTPDecodableResponse<T>, Error>) -> Void) where T : Decodable {
        do {
            let urlRequest = try request.asURLRequest()
            
            let responseHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else  {
                    completion(.failure(APIServiceError.APIResponseError.failed(.httpStatusCodeFailure)))
                    return
                }
                let responseData = data ?? Data()
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: responseData)
                    completion(.success(APIHTTPDecodableResponse<T>(data: responseData,
                                                                    decoded: decoded,
                                                                    httpResponse: httpResponse)))
                } catch {
                    completion(.failure(error))
                }
            }
            
            let dataTask = self.session.dataTask(with: urlRequest, completionHandler: responseHandler)
            
            dataTask.resume()
            
        } catch {
            completion(.failure(error))
        }
    }
    
    
}
