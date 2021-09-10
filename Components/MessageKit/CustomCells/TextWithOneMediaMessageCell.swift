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
open class TextWithOneMediaMessageCell: TextWithMediaMessageCell {
    /// The play button view to display on video messages.
    
    
    // MARK: - Methods
    /// Responsible for setting up the constraints of the cell's subviews.
    open  func setupConstraints() {
        //imageView.my_fillSuperview()
        
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
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor)
        
        imageViewTop?.isActive = true
        imageViewLeading?.isActive = true
        imageViewTrailing?.isActive = true
        imageViewBottom?.isActive = true
        
        stackView.my_fillSuperview()
        
        playButtonView.my_centerInSuperview()
        playButtonView.my_constraint(equalTo: CGSize(width: 35, height: 35))
    }
    
    open override  func setupSubviews() {
        super.setupSubviews()
        
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        mediaView.addSubview(imageView)
        stackView.addArrangedSubview(mediaView)
        stackView.addArrangedSubview(textLabel)
        messageContainerView.addSubview(stackView)
        messageContainerView.addSubview(playButtonView)
        setupConstraints()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.textLabel.text = ""
        self.textLabel.attributedText = nil
        self.playButtonView.isHidden = true
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
    }
}

