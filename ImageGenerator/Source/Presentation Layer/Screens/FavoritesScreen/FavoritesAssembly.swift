//
//  FavoritesAssembly.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

struct FavoritesAssembly: ModuleAssembler {
    typealias Context = Any?
    typealias ViewController = FavoritesViewController

    func build(with _: Any?) throws -> ViewController {
        let presenter = FavoritesPresenter()
        let generatedImageStorage = GeneratedImageStorage.shared
        let provider = FavoritesProvider(generatedImageStorage: generatedImageStorage)
        let interactor = FavoritesInteractor(presenter: presenter, provider: provider)
        let viewController = FavoritesViewController(interactor: interactor)
        presenter.viewController = viewController

        return viewController
    }
}
