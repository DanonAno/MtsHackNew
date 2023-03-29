//
//  Application.swift
//  MtsHackNew-tvOS
//
//  Created by  Даниил on 29.03.2023.
//

import UIKit

final class Application {
    
    static let shared = Application()
    var window: UIWindow?
    
    
    func configureMainInterface(in window: UIWindow) {
        self.updateApperance()
        self.window = window
        toStartVC()
        return
    }
    func updateApperance() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.white // устанавливаем цвет фона
        navigationBarAppearance.tintColor = UIColor.black
    }
    func toStartVC() {
        let navigationController = UINavigationController()
        let navigator = BaseNavigator(navigationController: navigationController)
        window?.rootViewController = navigationController
        navigator.toStartVC()
    }
}

