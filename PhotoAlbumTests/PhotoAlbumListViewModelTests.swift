//
//  PhotoAlbumListViewModelTests.swift
//  PhotoAlbumTests
//
//  Created by toka mohsen on 09/12/2021.
//

import XCTest
import RxSwift
@testable import PhotoAlbum

class PhotoAlbumListViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
   }

    override func tearDown() {
        super.tearDown()
    }
    

    func testAlbumsCount_WhenAPIReturnAllData() {
        let viewModel = PhotoAlbumListViewModel(coordinator: ApplicationCoordinator(), photoAlbumListService: serviceSuccessMock())
        viewModel.getPhotoAlbumList()
        XCTAssertNotEqual(viewModel.cells.value.count, 0)
    }

    func testAlbumsCount_WhenDataReturnsError() {
        let viewModel = PhotoAlbumListViewModel(coordinator: ApplicationCoordinator(), photoAlbumListService: serviceFailureMock())
        viewModel.getPhotoAlbumList()
        XCTAssertEqual(viewModel.cells.value.count , 0)
    }

}

class serviceSuccessMock: PhotoAlbumListServiceProtocol {
    func fetchAlbums() -> Observable<PhotoAlbumListModel> {
        return Observable.create { observer -> Disposable in
            let albums = [PhotoAlbum(userID: 0, id: 0, title: "Test")]
            let model = PhotoAlbumListModel(albums)
            observer.onNext(model)
            return Disposables.create()
        }
    }
}

class serviceFailureMock: PhotoAlbumListServiceProtocol {
    func fetchAlbums() -> Observable<PhotoAlbumListModel> {
        return Observable.create { observer -> Disposable in
            observer.onError(TError.generalError)
            return Disposables.create()
        }
    }
}
