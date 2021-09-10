//
//  CatatanMessageCell.swift
//  Pasien
//
//  Created by Adam M Riyadi on 14/10/20.
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
open class CatatanMessageCell: MessageContentCell {
    
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
    open var content = MessageLabel()
    
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
        
        checkbox.sizeToFit()
        headerView.addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.topAnchor.constraint(equalTo: title.topAnchor).isActive = true
        checkbox.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        checkbox.isHidden = true
        
        detailView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: detailView.topAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: detailView.leadingAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        
        detailView.addSubview(link)
        link.translatesAutoresizingMaskIntoConstraints = false
        link.bottomAnchor.constraint(equalTo: detailView.bottomAnchor).isActive = true
        link.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
        link.isHidden = true
        
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
        
//        headerView.bringSubviewToFront(checkbox)
        headerView.bringSubview(toFront: checkbox)

    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.content.text = ""
        self.title.text = ""
        
        self.content.attributedText = nil
        self.title.attributedText = nil
        
        self.imageView.image = nil
        self.link.isHidden = false
        self.checkbox.isHidden = true
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        if case .attributedText(let attributedItem) = message.kind {
            let textItem = attributedItem.string
            let json = JSON(parseJSON: textItem)
            
            if json["spa"].exists() {
                link.isHidden = false
                checkbox.isHidden = true
                
                imageView.image = UIImage(named: "catatan-icon", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)?.resizeWithWidth(width: 32)
                imageView.sizeToFit()
                
                title.text = LocalizationHelper.getInstance()!.catatan_dari_dokter
                title.font = .boldSystemFont(ofSize: 18)
                title.sizeToFit()
                
                let underlineAttributedString = NSAttributedString(string: LocalizationHelper.getInstance()!.detail_catatan, attributes:
                     [ NSAttributedString.Key.underlineStyle:  NSNotification.Name.UIDeviceOrientationDidChange,
                      .font: UIFont.systemFont(ofSize: 14),
                      NSAttributedString.Key.foregroundColor: UIColor.darkGray
                     ]
               //swift 4.2
//                                                                   [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
//                                                                    .font: UIFont.systemFont(ofSize: 14),
//                                                                    NSAttributedString.Key.foregroundColor: UIColor.darkGray
//                                                                   ]
                )
                link.attributedText = underlineAttributedString
                link.sizeToFit()
                
                let spa = json["spa"]
                var symptoms = spa["symptoms"].string
                symptoms = symptoms?.replacingOccurrences(of: "|", with: "\r\n")
                //let possible_diagnosis = spa["possible_diagnosis"].string
                //let advice = spa["advice"].string
                
                let text = NSMutableAttributedString()
                text.append(NSAttributedString(string: "\(LocalizationHelper.getInstance()!.symptoms) :\r\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]) )
                text.append(NSAttributedString(string: symptoms! , attributes: [.font: UIFont.systemFont(ofSize: 14)]) )
                /*text.append(NSAttributedString(string: "\(LocalizationHelper.getInstance()!.possible_diagnosis) :\r\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]) )
                text.append(NSAttributedString(string: possible_diagnosis! + "\r\n\r\n", attributes: [.font: UIFont.systemFont(ofSize: 14)]) )
                text.append(NSAttributedString(string: "\(LocalizationHelper.getInstance()!.advice) :\r\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]) )
                text.append(NSAttributedString(string: advice! , attributes: [.font: UIFont.systemFont(ofSize: 14)]) )*/
                
                content.attributedText =  text
                content.sizeToFit()
            }
            else if json["note"].exists() {
                link.isHidden = true
                checkbox.isHidden = true
                
                imageView.image = UIImage(named: "notes-icon", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)?.resizeWithWidth(width: 32)
                imageView.sizeToFit()
                
                let catatan = json["note"].string
                var next_schedule = json["next_schedule"].string
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: next_schedule!)
                
                dateFormatter.dateFormat = "E, d MMM yyyy"
                next_schedule = dateFormatter.string(from: date!)
                
                let titleText = NSMutableAttributedString()
                titleText.append(NSAttributedString(string: "\(LocalizationHelper.getInstance()!.chat_lagi_pada) :\r\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]) )
                titleText.append(NSAttributedString(string: next_schedule! , attributes: [.font: UIFont.systemFont(ofSize: 12)]) )
                
                title.attributedText = titleText
                title.sizeToFit()
                
                let text = NSMutableAttributedString()
                text.append(NSAttributedString(string: "\(LocalizationHelper.getInstance()!.pesan_dokter) :\r\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]) )
                text.append(NSAttributedString(string: catatan! , attributes: [.font: UIFont.systemFont(ofSize: 14)]) )
                
                content.attributedText =  text
                content.sizeToFit()
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
    }
    
    
    
    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        //return link.handleGesture(touchPoint)
        return true
    }
    
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        //let touchLocation = gesture.location(in: self)
        let touchLocation_link = gesture.location(in: detailView)
        let touchLocation_checkbox = gesture.location(in: headerView)
        
        if (link.frame.contains(touchLocation_link) && !link.isHidden) {
            delegate?.didTapMessage(in: self)
        }
        else if (checkbox.frame.contains(touchLocation_checkbox) && !checkbox.isHidden ) {
            checkbox.isChecked = !(checkbox.isChecked)
            delegate?.didTapMessage(in: self)
        }
        else {
            super.handleTapGesture(gesture)
        }
    }
}
