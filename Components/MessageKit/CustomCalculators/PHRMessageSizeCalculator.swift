//
//  PHRMessageSizeCalculator.swift
//  Pasien
//
//  Created by Idham Kurniawan on 24/06/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//


import Foundation
import MessageKit
import SwiftyJSON

open class PHRMessageSizeCalculator: MessageSizeCalculator {
    
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

        return CGSize(width: 350, height: 120)
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

//    internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
//        let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
//        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
//
//        return rect.size
//    }
}
