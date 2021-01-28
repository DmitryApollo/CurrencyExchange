//
//  CurrencyViewModel.swift
//  CurrencyExchange
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

protocol CurrencyViewModelProtocol: class {
    var networkService: NetworkServiceProtocol! { get set }
    var rates: [CurrencyModel] { get set }
    
    init(networkService: NetworkServiceProtocol)
    var ratesDidChanges: ((Bool, Error?) -> Void)? { get set }
    func getRates(currency: String)
}

final class CurrencyViewModel: CurrencyViewModelProtocol {
    var ratesDidChanges: ((Bool, Error?) -> Void)?
    var ratesByDateDidChanges: ((Bool, Error?) -> Void)?
    
    var networkService: NetworkServiceProtocol!
    var rates: [CurrencyModel] = [] {
        didSet {
            self.ratesDidChanges!(true, nil)
        }
    }
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getRates(currency: String) {
        networkService.getRates(currency: currency) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(var list):
                    list?.rates.removeValue(forKey: "PLN")
                    list?.rates.forEach { (key, value) in
                        let model = CurrencyModel(name: key, value: value)
                        self.rates.append(model)
                    }
                case .failure(let error):
                    self.ratesDidChanges!(false, error)
                }
            }
        }
    }
}
