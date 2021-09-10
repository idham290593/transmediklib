//
//  CatatanMessageSizeCalculator.swift
//  Pasien
//
//  Created by Adam M Riyadi on 14/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import MessageKit
import SwiftyJSON

open class CatatanMessageSizeCalculator: MessageSizeCalculator {
    
    public var incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 18)
    public var outgoingMessageLabelInsets = UIEdgeInsets(top: 7, left: 13, bottom: 7, right: 8)

    //public var messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
    public var messageLabelFont = UIFont.boldSystemFont(ofSize: 14)
    let spacingX : CGFloat = 60
    let spacingY : CGFloat  = 72
    
    public override init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        self.layout = layout
    }
    
    internal func messageLabelInsets(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageLabelInsets : incomingMessageLabelInsets
    }

    open override func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
        let maxWidth = UIScreen.main.bounds.width - spacingX
        let textInsets = messageLabelInsets(for: message)
        return maxWidth - textInsets.horizontal
    }

    open override func messageContainerSize(for message: MessageType) -> CGSize {
        let maxWidth = UIScreen.main.bounds.width - spacingX

        var messageContainerSize: CGSize
        var attributedText: NSAttributedString
        
        attributedText = NSAttributedString(string: "", attributes: [.font: messageLabelFont])
        
        if case .attributedText(let attributedItem) = message.kind {
            let textItem = attributedItem.string
            let json = JSON(parseJSON: textItem)
            
            if json["spa"].exists() {
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

                attributedText = text
            }
            else if json["note"].exists() {
                let catatan = json["note"].string
                
                let text = NSMutableAttributedString()
                text.append(NSAttributedString(string: "\(LocalizationHelper.getInstance()!.pesan_dokter) :\r\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]) )
                text.append(NSAttributedString(string: catatan! , attributes: [.font: UIFont.systemFont(ofSize: 14)]) )
                
                attributedText =  text
            }
        }
        
        let messageInsets = messageLabelInsets(for: message)
        
        messageContainerSize = labelSize(for: attributedText, considering: maxWidth)
        
        messageContainerSize.height += messageInsets.vertical + spacingY
        messageContainerSize.width = maxWidth + messageInsets.horizontal
        return messageContainerSize
    }

    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }

        let dataSource = messagesLayout.messagesDataSource
        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)

        attributes.messageLabelInsets = messageLabelInsets(for: message)
        attributes.messageLabelFont = messageLabelFont

        switch message.kind {
        case .attributedText(let text):
            guard !text.string.isEmpty else { return }
            guard let font = text.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else { return }
            attributes.messageLabelFont = font
        default:
            break
        }
    }

    internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        
        return rect.size
    }
}

