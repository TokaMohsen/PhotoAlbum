//
//  PhotoAlbumRequest.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import Moya


enum PhotoAlbumRequest {
    case fetchPhotoAlbumList
    case fetchPhotoAlbumDetails
}

extension PhotoAlbumRequest: TargetType {
    var path: String {
        switch self {
        case .fetchPhotoAlbumList:
            return  Constants.photoAlbumListPath
        case .fetchPhotoAlbumDetails:
            return Constants.photoAlbumDetailsPath
        }
    }
    
    // Can added different methods if needed
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .fetchPhotoAlbumList:
            return .requestPlain
        case .fetchPhotoAlbumDetails:
            return .requestPlain
        }
    }
}
