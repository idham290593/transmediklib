//
//  Imageloadmessagecell.swift
//  Pasien
//
//  Created by Idham Kurniawan on 14/07/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//


import Foundation
import UIKit
import MessageKit
import Alamofire
import Kingfisher
import SwiftyJSON

/// A subclass of `MessageContentCell` used to display text messages.
open class Imageloadmessagecell: MessageContentCell {

    open var images : UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    open var messageView: UIView = {
        let view = UIView()
        return view
    }()

 


    var texts = ""
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageView.addSubview(images)
        images.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 0).isActive = true
        images.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: 0).isActive = true
        images.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 0).isActive = true
        images.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 0).isActive = true

        images.translatesAutoresizingMaskIntoConstraints = false

        

        
        messageContainerView.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageContainerView.backgroundColor = .white
        messageView.my_fillSuperview()
        messageView.layoutSubviews()
        messageContainerView.layoutSubviews()
    }
    

    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        messageView.frame = messageContainerView.bounds
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        
        messageView.layoutSubviews()
        messageContainerView.layoutSubviews()
        
        
        if case .attributedText(let attributedItem) = message.kind {
            let textItem = attributedItem.string
        
            texts = textItem
            let url = URL(string: texts)
            images.kf.setImage(with: url)
        }
        
        
        
        

        messageView.setNeedsLayout()
        messageView.layoutIfNeeded()
        
        messageContainerView.setNeedsLayout()
        messageContainerView.layoutIfNeeded()
    }
    
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        //let touchLocation = gesture.location(in: self)
        delegate?.didTapMessage(in: self)
     
    }
    
    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        //return link.handleGesture(touchPoint)
        return true
    }
    
}
