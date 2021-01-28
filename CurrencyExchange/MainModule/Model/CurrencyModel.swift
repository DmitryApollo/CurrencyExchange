//
//  CurrencyModel.swift
//  CurrencyExchange
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

struct CurrencyListResponse: Codable {
    var rates: [String : Double]
    
    enum CodingKeys: String, CodingKey {
        case rates
    }
}

struct CurrencyModel {
    let name: String
    let value: Double
    
    init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
}
