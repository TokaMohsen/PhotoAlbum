//
//  PhotoAlbumDetailsViewModel.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class PhotoAlbumDetailsViewModel {
    // MARK: - Properties
    private let coordinator: PhotoAlbumListCoordinatorProtocol
    private let cells = BehaviorRelay<[PhotoAlbumDetails]>(value: [])
    
    // MARK: - Binding Properties
    let disposeBag = DisposeBag()
    var PhotosCells: Observable<[PhotoAlbumDetails]> {
        return cells.asObservable()
    }
    
    // MARK: - Initialization
    init(coordinator: PhotoAlbumListCoordinatorProtocol, photos: [PhotoAlbumDetails]) {
        self.coordinator = coordinator
        cells.accept(photos)
    }
    
    // MARK: - Management

}
