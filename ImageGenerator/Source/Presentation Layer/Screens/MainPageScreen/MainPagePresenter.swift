//
//  MainPagePresenter.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import Foundation

protocol MainPagePresentationLogic: AnyObject {
    func presentInitialData()
    func presentImage(response: MainPageDataFlow.PresentGeneratedImageFlow.Response)
    func presentAddedToFavorites()
    func presentNetworkError(with error: NetworkError)
}

final class MainPagePresenter {
    
    //MARK: - Properties
    
    weak var viewController: MainPageDisplayLogic?
}

//MARK: - MainPagePresentationLogic

extension MainPagePresenter: MainPagePresentationLogic {
    func presentInitialData() {
        let viewModel = MainPageDataFlow.ViewModel(
            generateImageButtonModel: makeButtonModel(),
            addToFavoritesButtonModel: makeAddToFavoritesButtonModel())
        viewController?.configure(with: viewModel)
    }
    
    func presentImage(response: MainPageDataFlow.PresentGeneratedImageFlow.Response) {
        viewController?.configureImage(with: makeViewModel(with: response))
    }
    
    func presentAddedToFavorites() {
        viewController?.configureAddedToFavorites(with: makeFavoritesViewModel())
    }
    
    func presentNetworkError(with error: NetworkError) {
        guard let viewModel = makeErrorViewModel(with: error) else { return }
        viewController?.configureErrorAlert(with: viewModel)
    }
}

//MARK: - Private

private extension MainPagePresenter {
    func makeButtonModel() -> DefaultButtonModel {
        DefaultButtonModel(
            title: Constants.generateImageButtonTitle,
            titleColor: .white,
            buttonColor: .systemBlue)
    }
    
    func makeAddToFavoritesButtonModel() -> DefaultButtonModel {
        DefaultButtonModel(
            title: Constants.addToFavoritesButtonTitle,
            titleColor: .white,
            buttonColor: .systemGreen)
    }
    
    func makeViewModel(with response: MainPageDataFlow.PresentGeneratedImageFlow.Response) -> MainPageDataFlow.PresentGeneratedImageFlow.ViewModel{
        MainPageDataFlow.PresentGeneratedImageFlow.ViewModel(imageData: response.imageData)
    }
    
    func makeFavoritesViewModel() -> MainPageDataFlow.AlertFlow.ViewModel {
        MainPageDataFlow.AlertFlow.ViewModel(
            alertTitle: Constants.addedToFavoritesAlertTitle,
            alertMessage: Constants.addedToFavoritesAlertMessage)
    }
    
    func makeErrorViewModel(with error: NetworkError) -> MainPageDataFlow.AlertFlow.ViewModel? {
        switch error {
        case .successfulConnection:
            return nil
        case .connectionFailed:
            return MainPageDataFlow.AlertFlow.ViewModel(
                alertTitle: Constants.errorTitle,
                alertMessage: Constants.connectionFailedErrorMessage
            )
        case .redirection:
            return MainPageDataFlow.AlertFlow.ViewModel(
                alertTitle: Constants.errorTitle,
                alertMessage: Constants.redirectionErrorMessage
            )
        case .encodingFailed:
            return MainPageDataFlow.AlertFlow.ViewModel(
                alertTitle: Constants.errorTitle,
                alertMessage: Constants.encodingFailedErrorMessage
            )
        case .missingUrl:
            return MainPageDataFlow.AlertFlow.ViewModel(
                alertTitle: Constants.errorTitle,
                alertMessage: Constants.missingUrlErrorMessage
            )
        case .serverError:
            return MainPageDataFlow.AlertFlow.ViewModel(
                alertTitle: Constants.errorTitle,
                alertMessage: Constants.serverErrorMessage
            )
        case .clientError:
            return MainPageDataFlow.AlertFlow.ViewModel(
                alertTitle: Constants.errorTitle,
                alertMessage: Constants.clientErrorMessage
            )
        }
    }
}

//MARK: - Constants

private extension MainPagePresenter {
    enum Constants {
        static let generateImageButtonTitle: String = "Сгенерировать изображение"
        static let addedToFavoritesAlertTitle: String = "Добавлено!"
        static let addedToFavoritesAlertMessage: String = "Изображение и строка успешно добавлены в избранное"
        static let addToFavoritesButtonTitle: String = "Добаить в избранное"
        
        static let errorTitle: String = "Упс!"
        static let connectionFailedErrorMessage: String = "Не удалось подключиться к серверу."
        static let redirectionErrorMessage: String = "Сервер перенаправил запрос на другой URL."
        static let encodingFailedErrorMessage: String = "Не удалось закодировать данные запроса."
        static let missingUrlErrorMessage: String = "Отсутствует URL запроса."
        static let serverErrorMessage: String = "Сервер столкнулся с ошибкой при обработке запроса."
        static let clientErrorMessage: String = "Запрос недействителен или не может быть обработан сервером."
    }
}
