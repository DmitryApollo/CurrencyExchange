//
//  AssemblyBuilder.swift
//  CurrencyExchange
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createRatesModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(currency: String, router: RouterProtocol) -> UIViewController
}

class AssemblyModelBuilder: AssemblyBuilderProtocol {
    func createRatesModule(router: RouterProtocol) -> UIViewController {
        let view = CurrencyViewController()
        let networkService = NetworkService()
        view.viewModel = CurrencyViewModel(networkService: networkService)
        view.router = router
        return view
    }
    
    func createDetailModule(currency: String, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let networkService = NetworkService()
        view.viewModel = DetailViewModel(currency: currency, networkService: networkService)
        view.router = router
        return view
    }
}
