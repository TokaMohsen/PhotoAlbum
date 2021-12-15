//
//  PhotoAlbumListModel.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import Foundation

typealias PhotoAlbumListModel = [PhotoAlbum]

struct PhotoAlbum: Codable {
    let userID : Int
    let id: Int
    let title: String
    
    var imageURL: String? // Local property

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id
        case title
        case imageURL
    }
}

extension PhotoAlbum {
    init(album: PhotoAlbum) {
        self.userID = album.userID
        self.id = album.id
        self.title = album.title
        self.imageURL = album.imageURL
    }
}
