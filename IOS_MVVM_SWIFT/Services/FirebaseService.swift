//
//  FirebaseService.swift
//  IOS_MVVM_SWIFT
//
//  Created by DreamOnline on 31/8/20.
//  Copyright © 2020 Tarun. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

struct FirebaseResource<T:Codable> {
    var data: Any
    init(data: Any) {
        self.data = data
    }
}

class FirebaseService {
    
    func loadData<T>(resources: FirebaseResource<T>, completion : @escaping(Result<T, NetworkError>) -> Void) {
        
        Database.database().reference().childByAutoId().setValue(resources.data) { (err, resp) in
            guard err == nil else {
                completion(.failure(.domainError))
                return
            }
            resp.observe(.value, with: { snapshot in
                guard let value = snapshot.value else { return }
                do {
                    let model = try FirebaseDecoder().decode(T.self, from: value)
                    completion(.success(model))
                } catch {
                    completion(.failure(.decodingError))
                }
            })
        }
        /*URLSession.shared.dataTask(with: request) { data, response, error in
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
        }*/
    }
}
