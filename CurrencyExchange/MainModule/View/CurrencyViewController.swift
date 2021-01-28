//
//  CurrencyViewController.swift
//  CurrencyExchange
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit
import SnapKit

class CurrencyViewController: UIViewController {

    var viewModel: CurrencyViewModelProtocol!
    var router: RouterProtocol!
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var errorAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Rate to PLN"
        
        view.backgroundColor = .white
        setUpTableView()
        setUpActivityIndicator()
        prepareViewModelObserver()
        viewModel.getRates(currency: "PLN")
    }
    
    //MARK: set up UI
    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "currencyCell")
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    private func prepareViewModelObserver() {
        viewModel.ratesDidChanges = { [weak self] (finished, error) in
            guard let self = self else { return }
            if let error = error {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                self.errorAlert?.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                guard let errorAlert = self.errorAlert else { return }
                self.present(errorAlert, animated: true)
                return
            }
            
            if finished {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.tableView.isHidden = false
            }
        }
    }
}

extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyTableViewCell
        
        let object = self.viewModel.rates[indexPath.row]
        cell?.currencyLabel.text = object.name
        cell?.valueLabel.text = String(format: "%.3f", object.value)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currency = viewModel.rates[indexPath.row].name
        router.showDetailController(with: currency)
    }
    
}

extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

