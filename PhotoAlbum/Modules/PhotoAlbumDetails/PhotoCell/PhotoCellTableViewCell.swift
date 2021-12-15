//
//  PhotoCellTableViewCell.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import UIKit

class PhotoCellTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Properties
    static let cellNib = UINib(nibName: "PhotoCellTableViewCell", bundle: nil)
    static let cellId = "PhotoCellTableViewCellId"
    var photoModel: PhotoAlbumDetails? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Management
    private func bindViewModel() {
        if let photoModel = photoModel {
            titleLabel.text = photoModel.title
            photoImageView.downloadImage(from: photoModel.thumbnailURL)
        }
    }
}
