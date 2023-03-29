//
//  BaseNavigator.swift
//  MtsHackNew-tvOS
//
//  Created by  Даниил on 29.03.2023.
//

import UIKit
import RxSwift

protocol BaseNavigatorProtocol {
    func toStartVC()
    func toFilmVC()
}

final class BaseNavigator: BaseNavigatorProtocol {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toStartVC() {
        let registerViewModel = RegisterViewModel(navigator: self)
        let registerVC = RegisterViewController(viewModel: registerViewModel, navigator: self)
        navigationController.pushViewController(registerVC, animated: true)
    }
    func toFilmVC() {
        let vc = VideoPlayerViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}

