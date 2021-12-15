//
//  PhotoAlbumDetailsViewController.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import UIKit
import RxSwift

class PhotoAlbumDetailsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var photosTableView: UITableView!
    
    // MARK: - Properties
    private let viewModel : PhotoAlbumDetailsViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init(viewModel: PhotoAlbumDetailsViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: "PhotoAlbumDetailsViewController" , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViews()
        setupTableView()
        setupCellTapHandling()
    }
    
    // MARK: - Management
    private func setupTableView() {
        photosTableView.register(PhotoCellTableViewCell.cellNib , forCellReuseIdentifier: PhotoCellTableViewCell.cellId)
        
        photosTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Rx Setup
    private func bindViews() {
        bindViewModel()
    }
    
    private func bindViewModel() {
        self.viewModel.PhotosCells.bind(to: self.photosTableView.rx.items(cellIdentifier: PhotoCellTableViewCell.cellId, cellType: PhotoCellTableViewCell.self)) {_, element, cell in
            cell.photoModel = element
        }.disposed(by: self.disposeBag)
    }
    
    // hande user action on photo cells
    private func setupCellTapHandling() {
        photosTableView
            .rx
            .modelSelected(PhotoAlbumDetails.self)
            .subscribe(
                onNext: { [weak self] photo in
                    guard let self = self else{return}
                    
                    self.displayFullImage(with: photo.url)
                    
                    if let selectedRowIndexPath = self.photosTableView.indexPathForSelectedRow {
                        self.photosTableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    // dismiss the full screen photo preview if user tapped on any point in screen
    @objc private func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    // display photo in full screen mode
    private func displayFullImage(with photoUrl: String) {
        let newImageView = UIImageView()
        newImageView.downloadImage(from: photoUrl)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 0.5)
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage(sender:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
}

extension PhotoAlbumDetailsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
