//
//  TargetTypeExtension.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import Foundation
import Moya

extension TargetType {
    var baseURL: URL {
        return URL(string: Constants.baseURL)!
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return nil
    }
}
