//
//  MockMessageItems.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import CoreLocation
import MessageKit
import AVFoundation


struct CoordinateItem: LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: AppSettings.mediaCellWidth, height: AppSettings.mediaCellHeight)
    }
    
}

struct ImageMediaItem: MediaItem {
    
    var image: UIImage?
    var url: URL?
    var images: [UIImage]?
    var urls: [URL]?
    var thumbnailUrls: [URL]?
    var placeholderImage: UIImage
    var size: CGSize
    var attributedText: NSAttributedString?
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: AppSettings.mediaCellWidth, height: AppSettings.mediaCellHeight)
        self.placeholderImage = UIImage()
    }
    
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: AppSettings.mediaCellWidth, height: AppSettings.mediaCellHeight)
        self.placeholderImage = UIImage()
    }
    
    
    init(images: [UIImage], attributedText: NSAttributedString?) {
        self.images = images
        self.attributedText = attributedText
        self.size = CGSize(width: AppSettings.mediaCellWidth, height: AppSettings.mediaCellHeight)
        self.placeholderImage = UIImage()
    }
    
    
    init(images: [UIImage], urls:[URL], attributedText: NSAttributedString?) {
        self.images = images
        self.urls = urls
        self.attributedText = attributedText
        self.size = CGSize(width: AppSettings.mediaCellWidth, height: AppSettings.mediaCellHeight)
        self.placeholderImage = UIImage()
    }
    
    
    init(thumbnailUrls: [URL], urls:[URL], attributedText: NSAttributedString?) {
        self.thumbnailUrls = thumbnailUrls
        self.urls = urls
        self.attributedText = attributedText
        self.size = CGSize(width: AppSettings.mediaCellWidth, height: AppSettings.mediaCellHeight)
        self.placeholderImage = UIImage()
    }
}


struct VideoMediaItem: MediaItem {
    
    var image: UIImage?
    var url: URL?
    var thumbnailUrl: URL?
    var placeholderImage: UIImage
    var size: CGSize
    var attributedText: NSAttributedString?
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: AppSettings.mediaCellWidth, height: AppSettings.mediaCellHeight)
        self.placeholderImage = UIImage()
    }
    
    
    init(thumbnail: UIImage, url: URL, attributedText: NSAttributedString?) {
        self.image = thumbnail
        self.url = url
        self.attributedText = attributedText
        self.size = CGSize(width: AppSettings.mediaCellWidth, height: AppSettings.mediaCellHeight)
        self.placeholderImage = UIImage()
    }
    
    
    init(thumbnailUrl: URL, url: URL, attributedText: NSAttributedString?) {
        self.thumbnailUrl = thumbnailUrl
        self.url = url
        self.attributedText = attributedText
        self.size = CGSize(width: AppSettings.mediaCellWidth, height: AppSettings.mediaCellHeight)
        self.placeholderImage = UIImage()
    }
}

struct MockAudiotem: AudioItem {
    
    var url: URL
    var size: CGSize
    var duration: Float
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 160, height: 35)
        // compute duration
        let audioAsset = AVURLAsset(url: url)
        self.duration = Float(CMTimeGetSeconds(audioAsset.duration))
    }
    
}

struct MockContactItem: ContactItem {
    
    var displayName: String
    var initials: String
    var phoneNumbers: [String]
    var emails: [String]
    
    init(name: String, initials: String, phoneNumbers: [String] = [], emails: [String] = []) {
        self.displayName = name
        self.initials = initials
        self.phoneNumbers = phoneNumbers
        self.emails = emails
    }
    
}
