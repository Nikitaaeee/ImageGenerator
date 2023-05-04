//
//  ImageGeneratorTabBar.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import UIKit

final class ImageGeneratorTabBar: UITabBarController {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers(configureViewControllersArray(), animated: false)
        configureTabBarItems()
        tabBar.backgroundColor = .white
    }
}

//MARK: - Private

private extension ImageGeneratorTabBar {
    func configureViewControllersArray() -> [UINavigationController] {
        guard let mainPageViewController = try? MainPageAssembly().build(),
              let favoriteImagesViewController = try? FavoritesAssembly().build()
        else { return [UINavigationController(rootViewController: UIViewController())] }
        
        let viewControllersArray = [
            UINavigationController(rootViewController: mainPageViewController),
            UINavigationController(rootViewController: favoriteImagesViewController)
        ]
        
        configureTabBarItem(for: mainPageViewController, with: Constants.MainPageController)
        configureTabBarItem(for: favoriteImagesViewController, with: Constants.FavoriteImagesController)
        
        return viewControllersArray
    }
    
    func configureTabBarItems() {
        self.tabBar.tintColor = .systemBlue
    }
    
    func configureTabBarItem(for viewController: UIViewController?, with constants: Constants) {
        guard let image = UIImage(named: constants.imageName) else { return }
        viewController?.tabBarItem = UITabBarItem(
            title: constants.title,
            image: image,
            selectedImage: image)
    }
}

//MARK: - Constants

private extension ImageGeneratorTabBar {
    enum Constants {
        case MainPageController
        case FavoriteImagesController
        
        var title: String {
            switch self {
            case .MainPageController: return "Создать"
            case .FavoriteImagesController: return "Избранное"
            }
        }
        
        var imageName: String {
            switch self {
            case .MainPageController: return "house"
            case .FavoriteImagesController: return "star"
            }
        }
    }
}
