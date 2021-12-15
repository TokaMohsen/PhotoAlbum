//
//  PhotoAlbumListViewModel.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import Foundation
import RxSwift
import RxCocoa


protocol PhotoAlbumListCoordinatorProtocol {
    func navigateToPhotoAlbumDetails(with photos: [PhotoAlbumDetails])
}

class PhotoAlbumListViewModel{
    // MARK: - Properties
    private var photoAlbumListService: PhotoAlbumListServiceProtocol
    private var fetchedAlbums = [PhotoAlbum]()
    private var photoAlbumDetails = [PhotoAlbumDetails]()
    private let coordinator: PhotoAlbumListCoordinatorProtocol
    private let emptyView = BehaviorRelay<Bool>(value: true)
    private let hideActivityIndicator = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    private let dispatchGroup = DispatchGroup()

    // MARK: - Binding Properties
    let cells = BehaviorRelay<[PhotoAlbum]>(value: [])
    var isEmptyView: Observable<Bool> {
        return emptyView.asObservable()
    }
    var activityIndicator: Observable<Bool> {
        return hideActivityIndicator.asObservable()
    }

    // MARK: - Initialization
    init(coordinator: PhotoAlbumListCoordinatorProtocol, photoAlbumListService: PhotoAlbumListServiceProtocol) {
        self.coordinator = coordinator
        self.photoAlbumListService = photoAlbumListService
    }
    
    // MARK: - Management
    //get all Photo albums from api and binding it to view controller
    func getAlbumsDetails() {
        self.hideActivityIndicator.accept(false)
        
        self.dispatchGroup.enter()
        photoAlbumListService.fetchAlbums().subscribe(
            onNext: { [weak self] photoAlbums in
                guard let self = self else{return}
                
                self.dispatchGroup.leave()

                self.fetchedAlbums = photoAlbums
                
                if photoAlbums.isEmpty {
                    self.emptyView.accept(false)
                } else {
                    self.emptyView.accept(true)
                }
            },
            onError: { [weak self] error in
                guard let self = self else{return}
                
                self.dispatchGroup.leave()
                self.emptyView.accept(false)
            }
        )
        .disposed(by: disposeBag)
        
        self.dispatchGroup.enter()
        photoAlbumListService.fetchPhotos().subscribe(
            onNext: { [weak self] albumDetailsObject in
                guard let self = self else{return}
                
                self.dispatchGroup.leave()
                self.photoAlbumDetails = albumDetailsObject
            },
            onError: { [weak self] error in
                guard let self = self else{return}
                self.dispatchGroup.leave()
            }
        )
        .disposed(by: disposeBag)
        
        self.dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            let resultAlbums = self.fetchedAlbums.compactMap({ [weak self] album -> PhotoAlbum? in
                guard let self = self else{return nil}
                
                var newAlbum = album
                newAlbum.imageURL = self.getRandomCoverPhoto(with: album.id)
                return newAlbum
            })
            
            self.fetchedAlbums = resultAlbums
            self.cells.accept(resultAlbums)
            self.hideActivityIndicator.accept(true)
        })
    }
    
    func searchForAlbum(searchText: String) {
        if searchText.isEmpty {
            self.emptyView.accept(true)
            self.cells.accept(fetchedAlbums)
            
        } else {
            let userID = Int(searchText) ?? 0
            let albums = fetchedAlbums.filter({$0.userID == userID})
            if albums.isEmpty {
                self.emptyView.accept(false)
            } else {
                self.emptyView.accept(true)
                self.cells.accept(albums)
            }
        }
    }
    
    private func getRandomCoverPhoto(with albumID: Int) -> String {
        let albumDetails = photoAlbumDetails.filter({$0.albumID == albumID})
        let randomIndex = Int.random(in: 0..<albumDetails.count)
        return albumDetails[randomIndex].thumbnailURL
    }
    
    // MARK: - User Action
    // navigate to photos view to show specific album's photos
    func navigateToPhotoAlbumDetails(with albumID: Int) {
        let photos = photoAlbumDetails.filter({$0.albumID == albumID})
        self.coordinator.navigateToPhotoAlbumDetails(with: photos)
    }
}
