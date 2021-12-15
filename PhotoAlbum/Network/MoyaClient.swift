//
//  MoyaClient.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import Foundation
import Moya

class MoyaClient<Target: TargetType> {
    class func Request<T: Codable>(provider: MoyaProvider<Target>, target: Target, model: T.Type?, completion: @escaping (Result<T, TError>) -> Void) {
        
        provider.request(target,
                         callbackQueue: DispatchQueue.main,
                         progress: { (progress) in
                         }, completion: { response in
                            switch response {
                            case .success(let value):
                                do {
                                    let dataModel = try JSONDecoder().decode(T.self, from: value.data)
                                    completion(.success(dataModel))
                                } catch {
                                    completion(.failure(.jsonParseError))
                                }
                            case .failure(_):
                                completion(.failure(.generalError))
                            }
                         }
        )
    }
}
