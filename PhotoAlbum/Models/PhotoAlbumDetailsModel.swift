//
//  PhotoAlbumDetailsModel.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import Foundation
typealias PhotoAlbumDetailsModel = [PhotoAlbumDetails]

struct PhotoAlbumDetails: Codable {
    let albumID : Int
    let id: Int
    let title: String
    let url: String
    let thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id
        case title
        case url
        case thumbnailURL = "thumbnailUrl"
    }
}
