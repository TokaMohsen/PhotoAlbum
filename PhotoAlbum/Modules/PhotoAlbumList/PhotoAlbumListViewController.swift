//
//  PhotoAlbumListViewController.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import UIKit
import RxSwift
import RxDataSources

class PhotoAlbumListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var noDataView: UIView!
    
    // MARK: - Properties
    private let viewModel : PhotoAlbumListViewModel
    private let disposeBag = DisposeBag()
    private var layout: UICollectionViewFlowLayout = {
         let layout = UICollectionViewFlowLayout()
         let width = UIScreen.main.bounds.size.width
         layout.estimatedItemSize = CGSize(width: width, height: 10)
         return layout
     }()
    
    // MARK: - Initialization
    init(viewModel: PhotoAlbumListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "PhotoAlbumListViewController" , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setupCollectionView()
        bindViews()
        setupCellTapHandling()
        viewModel.getAlbumsDetails()
    }

    // MARK: - Management
    private func setupCollectionView() {
        collectionView.register(PhotoAlbumCollectionViewCell.cellNib , forCellWithReuseIdentifier: PhotoAlbumCollectionViewCell.cellId)
        
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: - Rx Setup
    private func bindViews() {
        bindActivityIndicator()
        bindViewModel()
        bindNoDataView()
    }
    
    // get photo albums to assign to collection cells
    private func bindViewModel() {
        self.viewModel.cells.asObservable().bind(to: self.collectionView.rx.items(cellIdentifier: PhotoAlbumCollectionViewCell.cellId, cellType: PhotoAlbumCollectionViewCell.self)) {_, element, cell in
            cell.albumModel = element
        }.disposed(by: self.disposeBag)
    }

    // show or hide the view telling user that there is no data to preview
    private func bindNoDataView(){
        self.viewModel.isEmptyView
            .bind(to: noDataView.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    
    // show or hide activity indicator
    private func bindActivityIndicator(){
        self.viewModel.activityIndicator
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    
    // handle navigation to selected Album photos
    private func setupCellTapHandling() {
        collectionView
            .rx
            .modelSelected(PhotoAlbum.self)
            .subscribe(
                onNext: { [weak self] album in
                    
                    self?.viewModel.navigateToPhotoAlbumDetails(with: album.id)
                    
                    if let selectedRowIndexPath = self?.collectionView.indexPathsForSelectedItems?.first {
                        self?.collectionView?.deselectItem(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}

// handle search bar action
extension PhotoAlbumListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchForAlbum(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let keyWord = searchBar.text {
            viewModel.searchForAlbum(searchText: keyWord)
        }
    }
}


