//
//  PhotoAlbumCollectionViewCell.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Properties
    static let cellNib = UINib(nibName: "PhotoAlbumCollectionViewCell", bundle: nil)
    static let cellId = "PhotoAlbumCollectionViewCellId"
    var albumModel: PhotoAlbum? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: - Management
    private func bindViewModel() {
        if let albumModel = albumModel {
            titleLabel.text = albumModel.title
            
            if let image = albumModel.imageURL {
                imageView.downloadImage(from: image)
            } else {
                imageView.image = UIImage(named: "smallPlaceholder")
            }
        }
    }
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}
