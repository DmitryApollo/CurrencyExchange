//
//  Router.swift
//  CurrencyExchange
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetailController(with currency: String)
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navController = navigationController {
            guard let ratesVC = assemblyBuilder?.createRatesModule(router: self) else { return }
            navController.viewControllers = [ratesVC]
        }
    }
    
    func showDetailController(with currency: String) {
        if let navController = navigationController {
            guard let detailVC = assemblyBuilder?.createDetailModule(currency: currency, router: self) else { return }
            detailVC.modalPresentationCapturesStatusBarAppearance = true
            navController.pushViewController(detailVC, animated: true)
        }
    }
}
