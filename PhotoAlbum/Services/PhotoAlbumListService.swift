//
//  PhotoAlbumListService.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import Moya
import RxSwift

protocol PhotoAlbumListServiceProtocol {
    func fetchAlbums()-> Observable<PhotoAlbumListModel>
    func fetchPhotos()-> Observable<PhotoAlbumDetailsModel>
}
class PhotoAlbumListService: PhotoAlbumListServiceProtocol {
    // fetch albums
    func fetchAlbums() -> Observable<PhotoAlbumListModel> {
        return Observable.create { observer -> Disposable in
            
            MoyaClient<PhotoAlbumRequest>.Request(provider: MoyaProvider<PhotoAlbumRequest>(), target: .fetchPhotoAlbumList , model: PhotoAlbumListModel.self) { result in
                switch result {
                case .failure:
                    observer.onError(TError.generalError)
                case let .success(data):
                    observer.onNext(data)
                }
            }
            
            return Disposables.create()
        }
    }
    // fetch album photos
    func fetchPhotos()-> Observable<PhotoAlbumDetailsModel> {
        return Observable.create { observer -> Disposable in
            MoyaClient<PhotoAlbumRequest>.Request(provider: MoyaProvider<PhotoAlbumRequest>(), target: .fetchPhotoAlbumDetails , model: PhotoAlbumDetailsModel.self) { result in
                switch result {
                case .failure(_):
                    observer.onError(TError.generalError)
                case let .success(data):
                    observer.onNext(data)
                }
            }
            return Disposables.create()
        }
    }
}
