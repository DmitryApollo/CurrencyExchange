//
//  CurrencyTableViewCell.swift
//  CurrencyExchange
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit
import SnapKit
 
class CurrencyTableViewCell: UITableViewCell {
    let currencyLabel = UILabel()
    let valueLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layoutIfNeeded()
        contentView.addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints { (maker) in
            maker.height.equalToSuperview()
            maker.width.equalTo(contentView.frame.width/3)
            maker.leading.equalToSuperview().offset(20)
            maker.centerY.equalToSuperview()
        }
        
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (maker) in
            maker.height.equalToSuperview()
            maker.width.equalTo(contentView.frame.width/2.5)
            maker.trailing.equalToSuperview().offset(-20)
            maker.centerY.equalToSuperview()
        }
        valueLabel.textAlignment = .right

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        currencyLabel.text = ""
        valueLabel.text = ""
    }
}
