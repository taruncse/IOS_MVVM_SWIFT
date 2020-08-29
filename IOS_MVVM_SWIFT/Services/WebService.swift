//
//  WebService.swift
//  IOS_MVVM_SWIFT
//
//  Created by Tarun on 30/8/20.
//  Copyright © 2020 Tarun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T:Codable> {
    
    init(url: URL) {
        self.targetUrl = url
    }
    
    let targetUrl : URL
    var httpMethod : HttpMethod = .get
    var body: Data? = nil
}

class WebService {
    
    func loadData<T>(resources: Resource<T>, completion : @escaping(Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: resources.targetUrl)
        request.httpMethod = resources.httpMethod.rawValue
        request.httpBody = resources.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data , error == nil else {
                completion(.failure(.domainError))
                return
            }
            
            if let result = try? JSONDecoder().decode(T.self, from: data){
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }else {
                completion(.failure(.decodingError))
            }
        }
    }
}
