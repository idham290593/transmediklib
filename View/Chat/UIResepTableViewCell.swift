//
//  UIResepTableViewCell.swift
//  Pasien
//
//  Created by Adam M Riyadi on 16/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class UIResepTableViewCell: UITableViewCell {
    var json: JSON? {
        didSet {
            if (json!["medicines_name"].exists()) {
                medicineNameLabel.text = json!["medicines_name"].string
            }
            if (json!["rule"].exists()) {
                ruleLabel.text = json!["rule"].string
            }
            if (json!["period"].exists()) {
                periodLabel.text = "\(LocalizationHelper.getInstance()?.waktu ?? "") : \(json!["period"].string ?? "-")"
            }
            if (json!["note"].exists()) {
                noteLabel.text = "\(LocalizationHelper.getInstance()?.catatan ?? "") : \(json!["note"].string ?? "-")"
            }
            if (json!["qty"].exists()) {
                qtyLabel.text = json!["qty"].string
            }
        }
    }
    
    let medicineNameLabel:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ruleLabel:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let periodLabel:UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let noteLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let qtyLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .right
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(qtyLabel)
        contentView.addSubview(medicineNameLabel)
        contentView.addSubview(ruleLabel)
        contentView.addSubview(periodLabel)
        contentView.addSubview(noteLabel)
        
        medicineNameLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: 5).isActive = true
        medicineNameLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor).isActive = true
        
        qtyLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        qtyLabel.leadingAnchor.constraint(equalTo: medicineNameLabel.trailingAnchor).isActive = true
        qtyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        
        ruleLabel.topAnchor.constraint(equalTo:self.medicineNameLabel.bottomAnchor, constant: 5).isActive = true
        ruleLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor).isActive = true
        
        periodLabel.topAnchor.constraint(equalTo:self.ruleLabel.bottomAnchor).isActive = true
        periodLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor).isActive = true
        
        noteLabel.topAnchor.constraint(equalTo:self.periodLabel.bottomAnchor).isActive = true
        noteLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor).isActive = true
        noteLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        qtyLabel.sizeToFit()
        medicineNameLabel.sizeToFit()
        ruleLabel.sizeToFit()
        periodLabel.sizeToFit()
        noteLabel.sizeToFit()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
