//
//  ApplicationCoordinator.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import UIKit

class ApplicationCoordinator {
    private(set) var window: UIWindow?
    
    func start(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
    
    private lazy var rootNavigationController: UINavigationController = {
        let service = PhotoAlbumListService()
        let viewModel = PhotoAlbumListViewModel(coordinator: self, photoAlbumListService: service)
        let viewController = PhotoAlbumListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()
    
}

extension ApplicationCoordinator: PhotoAlbumListCoordinatorProtocol{
    func navigateToPhotoAlbumDetails(with photos: [PhotoAlbumDetails]) {
        let viewModel = PhotoAlbumDetailsViewModel(coordinator: self, photos: photos)
        let viewController = PhotoAlbumDetailsViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}
