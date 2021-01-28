//
//  DetailViewModel.swift
//  CurrencyExchange
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

protocol DetailViewModelProtocol: class {
    var networkService: NetworkServiceProtocol! { get set }
    var ratesWithDate: [CurrencyDateModel] { get set }
    var currency: String { get set }
    
    init(currency: String, networkService: NetworkServiceProtocol)
    var ratesByDateDidChanges: ((Bool, Error?) -> Void)? { get set }
    func getHistoricalRates(startAt: String, endAt: String)
}

final class DetailViewModel: DetailViewModelProtocol {
    var networkService: NetworkServiceProtocol!
    
    var ratesWithDate: [CurrencyDateModel] = [] {
        didSet {
            self.ratesByDateDidChanges!(true, nil)
        }
    }
    var currency: String
    var ratesByDateDidChanges: ((Bool, Error?) -> Void)?
    
    init(currency: String, networkService: NetworkServiceProtocol) {
        self.currency = currency
        self.networkService = networkService
    }
    
    func getHistoricalRates(startAt: String, endAt: String) {
            networkService.getHistoricalRates(startAt: startAt, endAt: endAt, forCurrency: currency) { [weak self] (result) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let list):
                        var array: [CurrencyDateModel] = []
                        list?.forEach({ (key, value) in
                            if let currencyValue = value.values.first {
                                let model = CurrencyDateModel(date: key, value: currencyValue)
                                array.append(model)
                            }
                        })
                        array.sort(by: { $0.date > $1.date })
                        self.ratesWithDate = array
                    case .failure(let error):
                        self.ratesByDateDidChanges!(false, error)
                    }
                }
            }
        }
    
    
}
