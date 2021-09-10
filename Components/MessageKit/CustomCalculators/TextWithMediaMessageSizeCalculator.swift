//
//  TextWithMediaMessageSizeCalculator.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import MessageKit

open class TextWithMediaMessageSizeCalculator: MessageSizeCalculator {

    public var incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 8)
    public var outgoingMessageLabelInsets = UIEdgeInsets(top: 7, left: 13, bottom: 7, right: 8)

    public var messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
    
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
        let maxWidth = super.messageContainerMaxWidth(for: message)
        let textInsets = messageLabelInsets(for: message)
        return maxWidth - textInsets.horizontal
    }

    open override func messageContainerSize(for message: MessageType) -> CGSize {
        var maxWidth = messageContainerMaxWidth(for: message)
        
        let sizeForMediaItem = { (maxWidth: CGFloat, item: MediaItem) -> CGSize in
            /*if maxWidth < item.size.width {
                // Maintain the ratio if width is too great
                let height = maxWidth * item.size.height / item.size.width
                return CGSize(width: maxWidth, height: height)
            }*/
            return item.size
        }

        var messageContainerSize: CGSize
        var attributedText: NSAttributedString
        
        attributedText = NSAttributedString(string: "", attributes: [.font: messageLabelFont])
        
        var itemSize: CGSize? = nil
        
        switch message.kind {
            case .photo(let mediaItem):
                if let photoItem = mediaItem as? ImageMediaItem {
                    attributedText = NSAttributedString(string: photoItem.attributedText?.string ?? "", attributes: [.font: messageLabelFont])

                    itemSize = sizeForMediaItem(photoItem.size.width , photoItem)
                }
                break
            case .video(let mediaItem):
                if let videoItem = mediaItem as? VideoMediaItem {
                    attributedText = NSAttributedString(string: videoItem.attributedText?.string ?? "", attributes: [.font: messageLabelFont])

                    itemSize = sizeForMediaItem(videoItem.size.width , videoItem)
                }
                break
            default:
                fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
        
        let messageInsets = messageLabelInsets(for: message)
        
        if itemSize != nil {
            //if maxWidth < itemSize!.width {
                maxWidth = itemSize!.width - messageInsets.horizontal
            //}
        }
        messageContainerSize = labelSize(for: attributedText, considering: maxWidth)
        
        if itemSize != nil {
            messageContainerSize.height += messageInsets.vertical + itemSize!.height
            messageContainerSize.width = maxWidth + messageInsets.horizontal
        }
        else {
            messageContainerSize.height += messageInsets.vertical
            messageContainerSize.width += messageInsets.horizontal
        }
        
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
            case .photo(let mediaItem):
                if let photoItem = mediaItem as? ImageMediaItem {
                    guard !photoItem.attributedText!.string.isEmpty else { return }
                    guard let font = photoItem.attributedText!.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else { return }
                    attributes.messageLabelFont = font
                }
                break
            case .video(let mediaItem):
                if let videoItem = mediaItem as? VideoMediaItem {
                    guard !videoItem.attributedText!.string.isEmpty else { return }
                    guard let font = videoItem.attributedText!.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else { return }
                    attributes.messageLabelFont = font
                }
                break
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
