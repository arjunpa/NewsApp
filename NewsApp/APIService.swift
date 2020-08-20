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
            
            let responseHandler: (Result<(response: HTTPURLResponse?, data: Data), Error>) -> Void = { result in
                
                switch result {
                case .success(let response):
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: response.data)
                        completion(.success(APIHTTPDecodableResponse<T>(data: response.data,
                                                                        decoded: decoded,
                                                                        httpResponse: response.response)))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
            self.dataRequest(for: urlRequest, completion: responseHandler)
            
        } catch {
            completion(.failure(error))
        }
    }
    
    func request(for request: Requestable, completion: @escaping (Result<APIHTTPDataResponse, Error>) -> Void) {
        self.dataRequest(for: request) { result in
            switch result {
            case .success(let response):
                completion(.success(APIHTTPDataResponse(data: response.data, httpResponse: response.response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func dataRequest(for request: Requestable,
                             completion: @escaping (Result<(response: HTTPURLResponse?, data: Data), Error>) -> Void) {
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
                completion(.success((response: httpResponse, data: responseData)))
            }
            
            let dataTask = self.session.dataTask(with: urlRequest, completionHandler: responseHandler)
            
            dataTask.resume()
            
        } catch {
            completion(.failure(error))
        }
    }
}
