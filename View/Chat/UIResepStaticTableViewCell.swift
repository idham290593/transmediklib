//
//  UIResepStaticTableViewCell.swift
//  Pasien
//
//  Created by Adam M Riyadi on 18/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class UIResepStaticTableViewCell: UIView {
    var json: JSON? {
        didSet {
            if (json!["medicines_name"].exists()) {
                medicineNameLabel.text = json!["medicines_name"].string
            }
            if (json!["rule"].exists()) {
                ruleLabel.text = json!["rule"].string
            }
            if (json!["period"].exists()) {
                let text = NSMutableAttributedString()
                text.append(NSAttributedString(string: "\(LocalizationHelper.getInstance()?.waktu ?? "") : ", attributes:
                        [.font: UIFont.systemFont(ofSize: 12)]) )
                text.append(NSAttributedString(string: json!["period"].string ?? "-" , attributes: [.font: UIFont.systemFont(ofSize: 12),
                     NSAttributedString.Key.foregroundColor: UIColor(hexString: "#5E5C5C")]) )
                periodLabel.attributedText = text
            }
            if (json!["note"].exists()) {
                let text = NSMutableAttributedString()
                text.append(NSAttributedString(string: "\(LocalizationHelper.getInstance()?.catatan ?? "") : ", attributes:
                        [.font: UIFont.systemFont(ofSize: 12)]) )
                text.append(NSAttributedString(string: json!["note"].string ?? "-" , attributes: [.font: UIFont.systemFont(ofSize: 12),
                     NSAttributedString.Key.foregroundColor: UIColor(hexString: "#5E5C5C")]) )
                noteLabel.attributedText = text
            }
            if (json!["qty"].exists()) {
                qtyLabel.text = "\(String(json!["qty"].int ?? 0)) \(json!["unit"].string ?? "")"
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
        view.font = .systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#5E5C5C")
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
    
    let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#C4C4C4")
        return view
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
        setupView(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
        setupView(frame: frame)
    }

    public convenience init() {
        self.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
        setupView(frame: .zero)
    }
    
     func setupView(frame: CGRect) {
        self.addSubview(qtyLabel)
        self.addSubview(medicineNameLabel)
        self.addSubview(ruleLabel)
        self.addSubview(periodLabel)
        self.addSubview(noteLabel)
        self.addSubview(lineView)
        
        medicineNameLabel.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        medicineNameLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor).isActive = true
        
        qtyLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        qtyLabel.leadingAnchor.constraint(equalTo: medicineNameLabel.trailingAnchor).isActive = true
        qtyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        ruleLabel.topAnchor.constraint(equalTo:self.medicineNameLabel.bottomAnchor).isActive = true
        ruleLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor).isActive = true
        
        periodLabel.topAnchor.constraint(equalTo:self.ruleLabel.bottomAnchor).isActive = true
        periodLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor).isActive = true
        
        noteLabel.topAnchor.constraint(equalTo:self.periodLabel.bottomAnchor).isActive = true
        noteLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor).isActive = true
        
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 7).isActive = true
        lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        qtyLabel.sizeToFit()
        medicineNameLabel.sizeToFit()
        ruleLabel.sizeToFit()
        periodLabel.sizeToFit()
        noteLabel.sizeToFit()
    }
}
