//
//  CustomMessagesFlowLayout.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import MessageKit

open class CustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    
    open lazy var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)
    open lazy var mediaOnlyMessageSizeCalculator = MediaMessageSizeCalculator(layout: self)
    open lazy var textWithMediaMessageSizeCalculator = TextWithMediaMessageSizeCalculator(layout: self)
    open lazy var urlMessageSizeCalculator = UrlMessageSizeCalculator(layout: self)
    open lazy var catatanMessageSizeCalculator = CatatanMessageSizeCalculator(layout: self)
    open lazy var resepDokterMessageSizeCalculator = ResepDokterMessageSizeCalculator(layout: self)
    open lazy var phrMessageSizeCalculator = PHRMessageSizeCalculator(layout: self)
    open lazy var imageloadMessageSizeCalculator = ImageloadMessageSizeCalculator(layout: self)


    open override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        
        if isSectionReservedForTypingIndicator(indexPath.section) {
            return typingIndicatorSizeCalculator
        }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        if case .custom = message.kind {
            return customMessageSizeCalculator
        }
        else if case .text = message.kind {
            if let msg = message as? MockMessage {
                if msg.type == AppSettings.URL_TYPE {
                    return urlMessageSizeCalculator
                }
                else if msg.type == AppSettings.PHR_REQ {
                    return phrMessageSizeCalculator
                }
                else if msg.type == AppSettings.SPA_TYPE || msg.type == AppSettings.CATATAN_TYPE  {
                    return catatanMessageSizeCalculator
                }
                else if msg.type == AppSettings.RESEP_DOKTER_TYPE {
                    return resepDokterMessageSizeCalculator
                }else if msg.type == AppSettings.IMAGE_TYPE {
                    return imageloadMessageSizeCalculator
                }
            }
        }
        else if case .attributedText = message.kind {
            if let msg = message as? MockMessage {
                if msg.type == AppSettings.URL_TYPE {
                    return urlMessageSizeCalculator
                }
                else if msg.type == AppSettings.PHR_REQ {
                    return phrMessageSizeCalculator
                }
                else if msg.type == AppSettings.SPA_TYPE || msg.type == AppSettings.CATATAN_TYPE {
                    return catatanMessageSizeCalculator
                }
                else if msg.type == AppSettings.RESEP_DOKTER_TYPE {
                    return resepDokterMessageSizeCalculator
                }else if msg.type == AppSettings.IMAGE_TYPE {
                    return imageloadMessageSizeCalculator
                }
            }
        }
        else if case .video(let mediaitem) = message.kind {
            if let videoItem = mediaitem as? VideoMediaItem {
                if videoItem.attributedText != nil && !(videoItem.attributedText?.string.isEmpty)! {
                    //media with text
                    return textWithMediaMessageSizeCalculator
                }
                else {
                    return mediaOnlyMessageSizeCalculator
                }
            }
        }
        else if case .photo(let mediaitem) = message.kind {
            if let photoitem = mediaitem as? ImageMediaItem {
                if photoitem.attributedText != nil && !(photoitem.attributedText?.string.isEmpty)! {
                    //media with text
                    return textWithMediaMessageSizeCalculator
                }
                else {
                    return mediaOnlyMessageSizeCalculator
                }
            }
        }
        
        return super.cellSizeCalculatorForItem(at: indexPath)
    }
    
    open override func messageSizeCalculators() -> [MessageSizeCalculator] {
        var superCalculators = super.messageSizeCalculators()
        // Append any of your custom `MessageSizeCalculator` if you wish for the convenience
        // functions to work such as `setMessageIncoming...` or `setMessageOutgoing...`
        superCalculators.append(customMessageSizeCalculator)
        superCalculators.append(mediaOnlyMessageSizeCalculator)
        superCalculators.append(textWithMediaMessageSizeCalculator)
        superCalculators.append(urlMessageSizeCalculator)
        superCalculators.append(catatanMessageSizeCalculator)
        superCalculators.append(resepDokterMessageSizeCalculator)
        superCalculators.append(phrMessageSizeCalculator)
        superCalculators.append(imageloadMessageSizeCalculator)


        return superCalculators
    }
}

open class CustomMessageSizeCalculator: MessageSizeCalculator {
    
    public override init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        self.layout = layout
    }
    
    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let layout = layout else { return .zero }
        let collectionViewWidth = layout.collectionView?.bounds.width ?? 0
        let contentInset = layout.collectionView?.contentInset ?? .zero
        let inset = layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
        return CGSize(width: collectionViewWidth - inset, height: 44)
    }
  
}
