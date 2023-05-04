//
//  MainPageRouter.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import UIKit

protocol MainPageRoutes {
    func showAlert(with viewModel: MainPageDataFlow.AlertFlow.ViewModel)
}

final class MainPageRouter {
    
    //MARK: - Properties
    
    weak var viewController: MainPageViewController?
}

//MARK: - MainPageRoutes

extension MainPageRouter: MainPageRoutes {
    func showAlert(with viewModel: MainPageDataFlow.AlertFlow.ViewModel) {
        let alert = UIAlertController(
            title: viewModel.alertTitle,
            message: viewModel.alertMessage,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: Constants.alertActionTitle, style: .cancel)
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}

//MARK: - Constants

private extension MainPageRouter {
    enum Constants {
        static let alertActionTitle: String = "OK"
    }
}
