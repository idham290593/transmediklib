//
//  TextWithFourMediaMessageCell.swift
//  mybpjs
//
//  Created by Adam M Riyadi on 23/04/20.
//  Copyright © 2020 Adam M Riyadi. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

/// A subclass of `MessageContentCell` used to display text messages.
open class TextWithTwoMediaMessageCell: TextWithMediaMessageCell {
    /// The play button view to display on video messages.
    
    
    // MARK: - Methods
    /// Responsible for setting up the constraints of the cell's subviews.
    open  func setupConstraints() {
        //imageView.my_fillSuperview()
        imageView2.isHidden = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        
        mediaView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5).isActive = true
        mediaView.heightAnchor.constraint(equalToConstant: AppSettings.mediaCellHeight).isActive = true
        mediaView.widthAnchor.constraint(equalToConstant: AppSettings.mediaCellWidth).isActive = true
        //mediaView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 5).isActive = true
        //mediaView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -5).isActive = true
        //mediaView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true

        textLabel.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 0).isActive = true
        //textLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -5).isActive = true

        mediaViewLeading = mediaView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        mediaViewTrailing = mediaView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        textLabelLeading = textLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        textLabelTrailing = textLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        
        mediaViewLeading!.isActive = true
        mediaViewTrailing!.isActive = true
        textLabelTrailing!.isActive = true
        textLabelLeading!.isActive = true
        
        imageViewTop = imageView.topAnchor.constraint(equalTo: mediaView.topAnchor)
        imageViewLeading = imageView.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor)
        imageViewTrailing = imageView.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor)
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: mediaView.centerYAnchor)
                
        imageView2Top = imageView2.topAnchor.constraint(equalTo: mediaView.centerYAnchor)
        imageView2Leading = imageView2.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor)
        imageView2Trailing = imageView2.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor)
        imageView2Bottom = imageView2.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor)
        
        imageViewTop?.isActive = true
        imageViewLeading?.isActive = true
        imageViewTrailing?.isActive = true
        imageViewBottom?.isActive = true
        
        imageView2Top?.isActive = true
        imageView2Leading?.isActive = true
        imageView2Trailing?.isActive = true
        imageView2Bottom?.isActive = true
        
        stackView.my_fillSuperview()
    }
    
    open override  func setupSubviews() {
        super.setupSubviews()
        
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView2.layer.maskedCorners = []
        
        mediaView.addSubview(imageView)
        mediaView.addSubview(imageView2)
        stackView.addArrangedSubview(mediaView)
        stackView.addArrangedSubview(textLabel)
        messageContainerView.addSubview(stackView)
        setupConstraints()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.imageView2.image = nil
        self.imageView2.isHidden = false
        self.textLabel.text = ""
        self.textLabel.attributedText = nil
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
    }
}

