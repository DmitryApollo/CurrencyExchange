//
//  Model.swift
//  CurrencyExchange
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

struct CurrencyListByDateResponse: Codable {
    var rates: [String: [String : Double]]
}

struct CurrencyDateModel {
    let date: String
    let value: Double
    
    init(date: String, value: Double) {
        self.date = date
        self.value = value
    }
}
