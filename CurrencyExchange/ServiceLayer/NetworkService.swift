//
//  NetworkService.swift
//  CurrencyExchange
//
//  Created by Дмитрий on 13/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getRates(currency: String, completion: @escaping (Result<CurrencyListResponse?, Error>) -> Void)
    func getHistoricalRates(startAt: String, endAt: String, forCurrency: String, completion: @escaping (Result<[String: [String : Double]]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func getRates(currency: String, completion: @escaping (Result<CurrencyListResponse?, Error>) -> Void) {
        let urlString = "https://api.exchangeratesapi.io/latest?base=\(currency)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "No support this title", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else {
                    let error = NSError(domain: "data not found", code: 404, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let obj = try JSONDecoder().decode(CurrencyListResponse.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getHistoricalRates(startAt: String, endAt: String, forCurrency: String, completion: @escaping (Result<[String: [String : Double]]?, Error>) -> Void) {
        let urlString = "https://api.exchangeratesapi.io/history?start_at=\(startAt)&end_at=\(endAt)&symbols=\(forCurrency)&base=PLN"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "No support this title", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else {
                    let error = NSError(domain: "data not found", code: 404, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let dict = try JSONDecoder().decode(CurrencyListByDateResponse.self, from: data)
                completion(.success(dict.rates))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
