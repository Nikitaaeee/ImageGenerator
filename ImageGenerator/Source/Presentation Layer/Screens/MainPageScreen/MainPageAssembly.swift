//
//  MainPageAssembly.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import Foundation

struct MainPageAssembly: ModuleAssembler {
    typealias Context = Any?
    typealias ViewController = MainPageViewController

    func build(with _: Any?) throws -> ViewController {
        let presenter = MainPagePresenter()
        let networkManager = MainScreenNetworkManager()
        let router = MainPageRouter()
        let generatedImageStorage = GeneratedImageStorage.shared
        let provider: MainPageProviderProtocol = MainScreenProvider(
            networkManager: networkManager,
            generatedImageStorage: generatedImageStorage)
        let interactor = MainPageInteractor(presenter: presenter, provider: provider)
        let viewController = MainPageViewController(interactor: interactor, router: router)
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
