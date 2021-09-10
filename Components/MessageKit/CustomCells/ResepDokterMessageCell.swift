//
//  ResepDokterMessageCell.swift
//  Pasien
//
//  Created by Adam M Riyadi on 15/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
//import PromiseKit
import Alamofire
import Kingfisher
import SwiftyJSON

/// A subclass of `MessageContentCell` used to display text messages.
open class ResepDokterMessageCell: MessageContentCell {
    
    /// The image view display the media content.
    open var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    open var messageView: UIView = {
        let view = UIView()
        return view
    }()
    
    open var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    open var detailView: UIView = {
        let view = UIView()
        return view
    }()
    
    open var lineView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexString: "#D8DEE2")
        return view
    }()
    
    open var lineView2: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexString: "#D8DEE2")
        return view
    }()
    
    open var content: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.spacing = 1
        view.distribution = .fill
        return view
    }()
    
    var checkbox: UICheckBox = {
       let view = UICheckBox()
        view.isChecked = false
        view.setTitle(" \(LocalizationHelper.getInstance()!.ingatkan_saya)", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        return view
    }()
    
    
    open var title = MessageLabel()
    open var link = MessageLabel()
    open var berlakuLabel = MessageLabel()
    open var dateLabel = MessageLabel()
    
    open override func setupSubviews() {
        super.setupSubviews()
        
        headerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        
        headerView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        
        detailView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: detailView.topAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: detailView.leadingAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        
        detailView.addSubview(link)
        link.translatesAutoresizingMaskIntoConstraints = false
        link.topAnchor.constraint(equalTo: content.bottomAnchor, constant: 5).isActive = true
        link.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        
        detailView.addSubview(berlakuLabel)
        berlakuLabel.translatesAutoresizingMaskIntoConstraints = false
        berlakuLabel.topAnchor.constraint(equalTo: link.bottomAnchor, constant: 5).isActive = true
        berlakuLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor).isActive = true
        
        detailView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: link.bottomAnchor, constant: 5).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        detailView.layoutSubviews()
        
        detailView.addSubview(lineView2)
        lineView2.translatesAutoresizingMaskIntoConstraints = false
        lineView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView2.centerYAnchor.constraint(equalTo: berlakuLabel.centerYAnchor).isActive = true
        lineView2.leadingAnchor.constraint(equalTo: berlakuLabel.trailingAnchor, constant: 3).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: lineView2.trailingAnchor, constant: 3).isActive = true
        lineView2.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -3).isActive = true
        
        detailView.addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.topAnchor.constraint(equalTo: berlakuLabel.bottomAnchor, constant: 3).isActive = true
        checkbox.leadingAnchor.constraint(equalTo: detailView.leadingAnchor).isActive = true
        checkbox.isHidden = true
        messageView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 30).isActive = true
        headerView.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15).isActive = true
        headerView.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15).isActive = true
        
        messageView.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 25).isActive = true
        lineView.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15).isActive = true
        lineView.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        messageView.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30).isActive = true
        detailView.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15).isActive = true
        detailView.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15).isActive = true
        detailView.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10).isActive = true
        
        messageContainerView.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        messageView.my_fillSuperview()
        messageView.layoutSubviews()
        messageContainerView.layoutSubviews()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.content.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        self.title.text = ""
        
        self.title.attributedText = nil
        self.dateLabel.text = ""
        
        self.imageView.image = nil
    }
    
    //open override func layoutSubviews() {
    //    super.layoutSubviews()
        //messageView.frame = messageContainerView.bounds
    //}
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        messageView.layoutSubviews()
        messageContainerView.layoutSubviews()
        
        if case .attributedText(let attributedItem) = message.kind {
            let textItem = attributedItem.string
            let json = JSON(parseJSON: textItem)
            
            if json["recipes"].exists() {
                //link.isHidden = false
                checkbox.isHidden = true
                imageView.image = UIImage(named: "resep-icon", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)?.resizeWithWidth(width: 32)
                
                title.text = LocalizationHelper.getInstance()!.resep_digital
                title.font = .boldSystemFont(ofSize: 18)
                title.sizeToFit()
                
                let underlineAttributedString = NSAttributedString(string: LocalizationHelper.getInstance()!.detail_obat, attributes:
                     [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDash.rawValue,
                      .font: UIFont.systemFont(ofSize: 14),
                      NSAttributedString.Key.foregroundColor: UIColor.darkGray
                     ]
                )
                link.textAlignment = .right
                link.attributedText = underlineAttributedString
                link.sizeToFit()
                
                berlakuLabel.text = LocalizationHelper.getInstance()!.resep_berlaku
                berlakuLabel.font = .systemFont(ofSize: 14)
                berlakuLabel.sizeToFit()
                
                var expires = json["expires"].string
                expires = String(expires?.prefix(10) ?? "")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: expires!)
                
                dateFormatter.dateFormat = "E, d MMM yyyy"
                expires = dateFormatter.string(from: date!)
                
                dateLabel.text = expires
                dateLabel.textAlignment = .right
                dateLabel.font = .systemFont(ofSize: 14)
                dateLabel.sizeToFit()

                buildResepView(json: json)
            }
        }
    }
    
    func buildResepView(json: JSON) {
        print("jsonn")
        print(json)
        
        let _view = UIView()
        content.addArrangedSubview(_view)
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
        _view.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
        _view.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        
        
        let label : UILabel = {
           let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .boldSystemFont(ofSize: 14)
            label.text = LocalizationHelper.getInstance()!.nama_obat
            label.textColor = .darkGray
            return label
        }()
        
        let label2 : UILabel = {
           let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .boldSystemFont(ofSize: 14)
            label.text = LocalizationHelper.getInstance()!.jumlah
            label.textAlignment = .right
            label.textColor = .darkGray
            return label
        }()
        
        label.sizeToFit()
        label2.sizeToFit()
        
        _view.addSubview(label2)
        label2.topAnchor.constraint(equalTo: _view.topAnchor).isActive = true
        label2.trailingAnchor.constraint(equalTo: _view.trailingAnchor).isActive = true
        label2.widthAnchor.constraint(equalTo: _view.widthAnchor, multiplier: 0.2, constant: 10).isActive = true
        
        _view.addSubview(label)
        label.topAnchor.constraint(equalTo: _view.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: _view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: label2.leadingAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: _view.widthAnchor, multiplier: 0.8, constant: -10 ).isActive = true
        _view.heightAnchor.constraint(equalTo: label.heightAnchor, constant: 5).isActive = true
        
        for (key,subJson):(String, JSON) in json["recipes"] {
            
            let _view = UIView()
            content.addArrangedSubview(_view)
            _view.translatesAutoresizingMaskIntoConstraints = false
            _view.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
            _view.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
            _view.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
            
            let label : UILabel = {
               let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = .systemFont(ofSize: 14)
                label.text = subJson["medicines_name"].string
                label.numberOfLines = 0
                return label
            }()
            
            let label2 : UILabel = {
               let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = .systemFont(ofSize: 14)
                label.text = "\(String(subJson["qty"].int ?? 0)) \(subJson["unit"].string ?? "")"
                label.numberOfLines = 0
                label.textAlignment = .right
                return label
            }()
            
            label.sizeToFit()
            label2.sizeToFit()
            
            _view.addSubview(label2)
            label2.topAnchor.constraint(equalTo: _view.topAnchor).isActive = true
            label2.trailingAnchor.constraint(equalTo: _view.trailingAnchor).isActive = true
            label2.widthAnchor.constraint(equalTo: _view.widthAnchor, multiplier: 0.2, constant: 10).isActive = true
            
            _view.addSubview(label)
            label.topAnchor.constraint(equalTo: _view.topAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: _view.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: label2.leadingAnchor).isActive = true
            label.widthAnchor.constraint(equalTo: _view.widthAnchor, multiplier: 0.8, constant: -10).isActive = true
            _view.heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
        }
        content.setNeedsLayout()
        content.layoutIfNeeded()
        
        detailView.sizeToFit()
        detailView.setNeedsLayout()
        detailView.layoutIfNeeded()
        
        messageView.setNeedsLayout()
        messageView.layoutIfNeeded()
        
        messageContainerView.setNeedsLayout()
        messageContainerView.layoutIfNeeded()
    }
    
    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        //return link.handleGesture(touchPoint)
        return true
    }
    
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        
        let touchLocation_link = gesture.location(in: detailView)
        let touchLocation_checkbox = gesture.location(in: detailView)
        
        if (link.frame.contains(touchLocation_link) && !link.isHidden) {
            delegate?.didTapMessage(in: self)
        }
        else if (checkbox.frame.contains(touchLocation_checkbox) && !checkbox.isHidden) {
            checkbox.isChecked = !(checkbox.isChecked)
            delegate?.didTapMessageBottomLabel(in: self)
        }
        else {
            super.handleTapGesture(gesture)
        }
    }
}
