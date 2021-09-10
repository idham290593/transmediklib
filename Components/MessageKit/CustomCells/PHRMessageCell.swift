//
//  PHRMessageCell.swift
//  Pasien
//
//  Created by Idham Kurniawan on 24/06/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//

//
import Foundation
import UIKit
import MessageKit
//import PromiseKit
import Alamofire
import Kingfisher
import SwiftyJSON

/// A subclass of `MessageContentCell` used to display text messages.
open class PHRMessageCell: MessageContentCell {
    
    /// The image view display the media content.
  
//
//    open var ekg: UIImageView = {
//        let view = UIImageView()
//        view.contentMode = .scaleAspectFill
//        view.clipsToBounds = true
//        view.layer.masksToBounds = true
//        return view
//    }()
//
//
//    open var pmr: UIImageView = {
//        let view = UIImageView()
//        view.contentMode = .scaleAspectFill
//        view.clipsToBounds = true
//        view.layer.masksToBounds = true
//        return view
//    }()
//
//    open var phr: UIImageView = {
//        let view = UIImageView()
//        view.contentMode = .scaleAspectFill
//        view.clipsToBounds = true
//        view.layer.masksToBounds = true
//        return view
//    }()
    
    
    open var konfirmasi : UIView = {
        let view = UIView()
        return view
    }()
    
    open var messageView: UIView = {
        let view = UIView()
        return view
    }()
    
//    open var viewphr : UIView = {
//        let view = UIView()
//        return view
//    }()
    
    open var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
   
    

    open var title = MessageLabel()
    open var link = MessageLabel()

    var texts = ""
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageView.addSubview(title)
        title.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 15).isActive = true
        title.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -15).isActive = true
        title.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 15).isActive = true
        title.translatesAutoresizingMaskIntoConstraints = false

        

        
        messageContainerView.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageContainerView.backgroundColor = .white
        messageView.my_fillSuperview()
        messageView.layoutSubviews()
        messageContainerView.layoutSubviews()
    }
    

    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.title.text = ""
        self.title.attributedText = nil
      
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        messageView.frame = messageContainerView.bounds
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        
        messageView.layoutSubviews()
        messageContainerView.layoutSubviews()
        
       
        
        title.text = "Apakah dokter boleh melihat informasi kesehatan Anda?"
        title.font = .boldSystemFont(ofSize: 15)
        title.sizeToFit()
       
       
        link.font = .boldSystemFont(ofSize: 15)
        link.sizeToFit()
        link.translatesAutoresizingMaskIntoConstraints = false

        
        if case .attributedText(let attributedItem) = message.kind {
            let textItem = attributedItem.string
        
            texts = textItem
            if textItem == "PHR Request"{
                messageView.addSubview(konfirmasi)
                konfirmasi.addSubview(link)

                konfirmasi.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 15).isActive = true
                konfirmasi.heightAnchor.constraint(equalToConstant: 50).isActive = true
                konfirmasi.centerXAnchor.constraint(equalTo: messageView.centerXAnchor).isActive = true

                konfirmasi.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15).isActive = true
                konfirmasi.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15).isActive = true
                
                konfirmasi.translatesAutoresizingMaskIntoConstraints = false
                konfirmasi.layer.cornerRadius = 8
                konfirmasi.layer.borderWidth = 1
                konfirmasi.layer.borderColor = UIColor.white.cgColor
                konfirmasi.backgroundColor = .blue
                
                
                link.text = "Konfirmasi"
                link.textColor = .white
                link.textAlignment = .center
                
                link.centerYAnchor.constraint(equalTo: konfirmasi.centerYAnchor).isActive = true
                link.centerXAnchor.constraint(equalTo: konfirmasi.centerXAnchor).isActive = true
                link.heightAnchor.constraint(equalTo: konfirmasi.heightAnchor).isActive = true
                link.widthAnchor.constraint(equalTo: konfirmasi.widthAnchor).isActive = true

                link.layoutIfNeeded()
                
            }else  if textItem == "ALLOWED"{
                messageView.addSubview(link)
                link.text = "Permintaan disetujui"
                link.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15).isActive = true
                link.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
                link.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15).isActive = true
                link.textColor = .orange
                konfirmasi.backgroundColor = .clear
                konfirmasi.layer.borderColor = UIColor.clear.cgColor
                link.textAlignment = .left

                
            }else{
                
                messageView.addSubview(link)
                link.text = "Permintaan ditolak"
                link.textColor = .red
                link.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
                konfirmasi.backgroundColor = .clear
                link.textAlignment = .left
                konfirmasi.layer.borderColor = UIColor.clear.cgColor

                link.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15).isActive = true
                link.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15).isActive = true
                
                
                
            }
            
            
        }
        

        messageView.setNeedsLayout()
        messageView.layoutIfNeeded()
        
        messageContainerView.setNeedsLayout()
        messageContainerView.layoutIfNeeded()
    }
    
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        //let touchLocation = gesture.location(in: self)
        
        if texts == "PHR Request"{
            let touchLocation_link = gesture.location(in: konfirmasi)
            
            if (link.frame.contains(touchLocation_link) && !link.isHidden) {
                delegate?.didTapMessage(in: self)
            }
         
            else {
                super.handleTapGesture(gesture)
            }
        }
     
    }
    
    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        //return link.handleGesture(touchPoint)
        return true
    }
    
}
