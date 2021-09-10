//
//  MockMessage.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import CoreLocation
import MessageKit
import AVFoundation

internal struct MockMessage: MessageType {
    
    var messageId: String
    var sender: SenderType {
        return user
    }
    var sentDate: Date
    var kind: MessageKind
    
    var user: MockUser
    var status: String
    
    var type: String?
    
    private init(kind: MessageKind, user: MockUser, messageId: String, date: Date, status: String) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
        self.status = status
    }
    
    private init(kind: MessageKind, user: MockUser, messageId: String, date: Date, status: String, type: String?) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
        self.status = status
        self.type = type
    }
    
    init(custom: Any?, user: MockUser, messageId: String, date: Date, status: String) {
        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date, status: status)
    }
    
    init(text: String, user: MockUser, messageId: String, date: Date, status: String) {
        /*let font = UIFont.systemFont(ofSize: 14)
         let attributes = [NSAttributedString.Key.font: font]
         let attr_text = NSAttributedString(string: text, attributes: attributes)
         
         self.init(kind: .attributedText(attr_text), user: user, messageId: messageId, date: date)*/
        self.init(kind: .text(text), user: user, messageId: messageId, date: date, status: status)
    }
    
    init(attributedText: NSAttributedString, user: MockUser, messageId: String, date: Date, status: String, type: String?) {
        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date, status: status, type: type)
    }
    
    init(location: CLLocation, user: MockUser, messageId: String, date: Date, status: String) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), user: user, messageId: messageId, date: date, status: status)
    }
    
    init(emoji: String, user: MockUser, messageId: String, date: Date, status: String) {
        self.init(kind: .emoji(emoji), user: user, messageId: messageId, date: date, status: status)
    }
    
    init(audioURL: URL, user: MockUser, messageId: String, date: Date, status: String) {
        let audioItem = MockAudiotem(url: audioURL)
        self.init(kind: .audio(audioItem), user: user, messageId: messageId, date: date, status: status)
    }
    
    init(contact: MockContactItem, user: MockUser, messageId: String, date: Date, status: String) {
        self.init(kind: .contact(contact), user: user, messageId: messageId, date: date, status: status)
    }
    
    //photo media item
    init(images: [UIImage], attributedText: NSAttributedString?, user: MockUser, messageId: String, date: Date, status: String) {
        let mediaItem = ImageMediaItem(images: images, attributedText: attributedText)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date, status: status)
    }
    
    init(images: [UIImage], imageUrls: [URL], attributedText: NSAttributedString?, user: MockUser, messageId: String, date: Date, status: String) {
        let mediaItem = ImageMediaItem(images: images, urls: imageUrls, attributedText: attributedText)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date, status: status)
    }
    
    init(thumbnailUrls: [URL], imageUrls: [URL], attributedText: NSAttributedString?, user: MockUser, messageId: String, date: Date, status: String) {
        let mediaItem = ImageMediaItem(thumbnailUrls: thumbnailUrls, urls: imageUrls, attributedText: attributedText)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date, status: status)
    }
    //photo media item
    
    
    //video media item
    init(thumbnail: UIImage, url: URL, attributedText: NSAttributedString?, user: MockUser, messageId: String, date: Date, status: String) {
        let mediaItem = VideoMediaItem(thumbnail: thumbnail, url: url, attributedText: attributedText)
        self.init(kind: .video(mediaItem), user: user, messageId: messageId, date: date, status: status)
    }
    
    init(thumbnailUrl: URL, url: URL, attributedText: NSAttributedString?, user: MockUser, messageId: String, date: Date, status: String) {
        let mediaItem = VideoMediaItem(thumbnailUrl: thumbnailUrl, url: url, attributedText: attributedText)
        self.init(kind: .video(mediaItem), user: user, messageId: messageId, date: date, status: status)
    }
    //video media item
}
