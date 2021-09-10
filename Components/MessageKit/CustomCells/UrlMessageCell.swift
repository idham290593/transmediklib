//
//  UrlMessageCell.swift
//  mybpjs
//
//  Created by Adam M Riyadi on 23/04/20.
//  Copyright © 2020 Adam M Riyadi. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import URLEmbeddedView

/// A subclass of `MessageContentCell` used to display text messages.
open class UrlMessageCell: TextWithMediaMessageCell {
    /// The play button view to display on video messages.
    
    /// The image view display the media content.
    open var embeddedView: URLEmbeddedView = {
        let view = URLEmbeddedView()
        //view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.textProvider[.title].font = .boldSystemFont(ofSize: 12)
        view.textProvider[.description].font = .systemFont(ofSize: 12)
        view.textProvider[.domain].font = .systemFont(ofSize: 12)
        view.textProvider[.noDataTitle].font = .systemFont(ofSize: 12)
        return view
    }()
    // MARK: - Methods
    /// Responsible for setting up the constraints of the cell's subviews.
    open  func setupConstraints() {
        //imageView.my_fillSuperview()
        //imageView.contentMode = .scaleAspectFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        embeddedView.translatesAutoresizingMaskIntoConstraints = false
        
        mediaView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5).isActive = true
        mediaView.heightAnchor.constraint(equalToConstant: AppSettings.urlCellHeight).isActive = true
        mediaView.widthAnchor.constraint(equalToConstant: AppSettings.urlCellWidth).isActive = true
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
        
        embeddedView.topAnchor.constraint(equalTo: mediaView.topAnchor).isActive = true
        embeddedView.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor).isActive = true
        embeddedView.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor).isActive = true
        embeddedView.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor).isActive = true
        
        stackView.my_fillSuperview()
    }
    
    open override  func setupSubviews() {
        super.setupSubviews()
        
        mediaView.backgroundColor = .white
        
        embeddedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mediaView.clipsToBounds = true
        mediaView.layer.masksToBounds = true
        mediaView.layer.cornerRadius = 10
        mediaView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        mediaView.addSubview(embeddedView)
        stackView.addArrangedSubview(mediaView)
        stackView.addArrangedSubview(textLabel)
        messageContainerView.addSubview(stackView)
        setupConstraints()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.textLabel.text = ""
        self.textLabel.attributedText = nil
    }
    
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError("MessageKitError.nilMessagesDisplayDelegate")
        }
        
        let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)
        
        let dataSource = messagesCollectionView.messagesDataSource
        
        if (dataSource!.isFromCurrentSender(message: message)) {
            
            mediaViewLeading!.constant = 5
            mediaViewTrailing!.constant = -10
            //textLabelLeading!.constant = 5
            //textLabelTrailing!.constant = -10
            
            textLabel.updateConstraints()
            mediaView.updateConstraints()
        }
        else {
            
            mediaViewLeading!.constant = 10
            mediaViewTrailing!.constant = -5
            //textLabelLeading!.constant = 10
            //textLabelTrailing!.constant = -5
            
            textLabel.updateConstraints()
            mediaView.updateConstraints()
        }
            
        
        if case .text(let textItem) = message.kind {
            DispatchQueue.main.async {
                self.generateLinkPreview(text: textItem)
            }
            
            textLabel.configure {
                textLabel.enabledDetectors = enabledDetectors
                for detector in enabledDetectors {
                    let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                    textLabel.setAttributes(attributes, detector: detector)
                }
                
                textLabel.text = textItem
            }
        }
        else if case .attributedText(let attributedItem) = message.kind {
            DispatchQueue.main.async {
                let textItem = attributedItem.string
                self.generateLinkPreview(text: textItem)
            }
            
            textLabel.configure {
                textLabel.enabledDetectors = enabledDetectors
                for detector in enabledDetectors {
                    let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                    textLabel.setAttributes(attributes, detector: detector)
                }
                
                textLabel.attributedText = attributedItem
            }
        }
    }
    
    func generateLinkPreview(text: String) {
        
        let urlDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = urlDetector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            
            var url = text[range].description
            if !url.contains("http") {
                url = "http://" + url
            }
            embeddedView.load(urlString: url)
            break
        }
    }
}

