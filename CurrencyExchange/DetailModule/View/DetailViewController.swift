//
//  DetailViewController.swift
//  CurrencyExchange
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {

    var viewModel: DetailViewModelProtocol!
    var router: RouterProtocol!
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var errorAlert: UIAlertController?
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.currency
        view.backgroundColor = .white
        setUpTableView()
        setUpActivityIndicator()
        prepareViewModelObserver()
        let startDateString = makeDateString(date: getLastWeekMonday())
        viewModel.getHistoricalRates(startAt: startDateString, endAt: makeDateString(date: Date()))
    }
    
    private func makeDateString(date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    private func getLastWeekMonday() -> Date {
        let calendar = Calendar.current
        let lastWeekDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
        var comps = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: lastWeekDate)
        comps.weekday = 2
        let mondayInWeek = calendar.date(from: comps)!
        return mondayInWeek
    }
    
    //MARK: set up UI
    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "currencyCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
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
        viewModel.ratesByDateDidChanges = { [weak self] (finished, error) in
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

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ratesWithDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyTableViewCell
        
        let object = self.viewModel.ratesWithDate[indexPath.row]
        cell?.currencyLabel.text = object.date
        cell?.valueLabel.text = String(format: "%.4f", object.value)
        
        return cell ?? UITableViewCell()
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

