//
//  FourMediaOnlyMessageCell.swift
//  mybpjs
//
//  Created by Adam M Riyadi on 23/04/20.
//  Copyright © 2020 Adam M Riyadi. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

/// A subclass of `MessageContentCell` used to display text messages.
open class FourMediaOnlyMessageCell: MediaOnlyMessageCell {
    /// The play button view to display on video messages.
    
    
    // MARK: - Methods
    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        //imageView.my_fillSuperview()
        imageView2.isHidden = false
        imageView3.isHidden = false
        imageView4.isHidden = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        imageView4.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mediaView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5).isActive = true
        mediaView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -5).isActive = true
        mediaView.heightAnchor.constraint(equalToConstant: AppSettings.mediaCellHeight).isActive = true
        mediaView.widthAnchor.constraint(equalToConstant: AppSettings.mediaCellWidth).isActive = true
        //imageView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5).isActive = true
        //imageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -5).isActive = true
        //imageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        mediaViewLeading = mediaView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        mediaViewTrailing = mediaView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        
        mediaViewLeading!.isActive = true
        mediaViewTrailing!.isActive = true
        
        imageViewTop = imageView.topAnchor.constraint(equalTo: mediaView.topAnchor)
        imageViewLeading = imageView.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor)
        imageViewTrailing = imageView.trailingAnchor.constraint(equalTo: mediaView.centerXAnchor)
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: mediaView.centerYAnchor)
                
        imageView2Top = imageView2.topAnchor.constraint(equalTo: mediaView.topAnchor)
        imageView2Leading = imageView2.leadingAnchor.constraint(equalTo: mediaView.centerXAnchor)
        imageView2Trailing = imageView2.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor)
        imageView2Bottom = imageView2.bottomAnchor.constraint(equalTo: mediaView.centerYAnchor)
        
        imageView3Top = imageView3.topAnchor.constraint(equalTo: mediaView.centerYAnchor)
        imageView3Leading = imageView3.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor)
        imageView3Trailing = imageView3.trailingAnchor.constraint(equalTo: mediaView.centerXAnchor)
        imageView3Bottom = imageView3.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor)
        
        imageView4Top = imageView4.topAnchor.constraint(equalTo: mediaView.centerYAnchor)
        imageView4Leading = imageView4.leadingAnchor.constraint(equalTo: mediaView.centerXAnchor)
        imageView4Trailing = imageView4.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor)
        imageView4Bottom = imageView4.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor)
        
        badgeLabelBottom = badgeLabel.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: -5)
        badgeLabelTrailing = badgeLabel.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor, constant: -5)
        badgeLabelWidth = badgeLabel.widthAnchor.constraint(equalToConstant: 24)
        badgeLabelHeight = badgeLabel.heightAnchor.constraint(equalToConstant: 24)
        
        badgeLabelBottom?.isActive = true
        badgeLabelTrailing?.isActive = true
        badgeLabelHeight?.isActive = true
        badgeLabelWidth?.isActive = true
        
        imageViewTop?.isActive = true
        imageViewLeading?.isActive = true
        imageViewTrailing?.isActive = true
        imageViewBottom?.isActive = true
        
        imageView2Top?.isActive = true
        imageView2Leading?.isActive = true
        imageView2Trailing?.isActive = true
        imageView2Bottom?.isActive = true
        
        imageView3Top?.isActive = true
        imageView3Leading?.isActive = true
        imageView3Trailing?.isActive = true
        imageView3Bottom?.isActive = true
        
        imageView4Top?.isActive = true
        imageView4Leading?.isActive = true
        imageView4Trailing?.isActive = true
        imageView4Bottom?.isActive = true
        
        stackView.my_fillSuperview()
    }
    
    open override  func setupSubviews() {
        super.setupSubviews()
        badgeLabel.badgeColor = AppColor.shared.instance(traitCollection).badgeColor
        badgeLabel.textColor = AppColor.shared.instance(traitCollection).badgeTextColor
        
        imageView.layer.maskedCorners = [.layerMinXMinYCorner]
        imageView2.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        imageView3.layer.maskedCorners = [.layerMinXMaxYCorner]
        imageView4.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        mediaView.addSubview(imageView)
        mediaView.addSubview(imageView2)
        mediaView.addSubview(imageView3)
        mediaView.addSubview(imageView4)
        mediaView.addSubview(badgeLabel)
        stackView.addArrangedSubview(mediaView)
        messageContainerView.addSubview(stackView)
        setupConstraints()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        badgeLabel.badgeColor = AppColor.shared.instance(traitCollection).badgeColor
        badgeLabel.textColor = AppColor.shared.instance(traitCollection).badgeTextColor
        badgeLabelWidth?.isActive = false
        badgeLabelHeight?.isActive = false
        badgeLabel.text = ""
        
        self.imageView.image = nil
        self.imageView2.image = nil
        self.imageView3.image = nil
        self.imageView4.image = nil
        self.imageView2.isHidden = false
        self.imageView3.isHidden = false
        self.imageView4.isHidden = false
        self.badgeLabel.isHidden = true
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
    }
}


