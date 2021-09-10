//
//  TextWithMediaMessageCell.swift
//  mybpjs
//
//  Created by Adam M Riyadi on 19/04/20.
//  Copyright © 2020 Adam M Riyadi. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import Kingfisher

/// A subclass of `MessageContentCell` used to display text messages.
open class MediaOnlyMessageCell: MessageContentCell {
    /// The play button view to display on video messages.
    
    var mediaViewTrailing : NSLayoutConstraint?
    var mediaViewLeading : NSLayoutConstraint?
    
    var imageViewTop: NSLayoutConstraint?
    var imageViewLeading: NSLayoutConstraint?
    var imageViewTrailing: NSLayoutConstraint?
    var imageViewBottom: NSLayoutConstraint?
    
    var imageView2Top: NSLayoutConstraint?
    var imageView2Leading: NSLayoutConstraint?
    var imageView2Trailing: NSLayoutConstraint?
    var imageView2Bottom: NSLayoutConstraint?
    
    var imageView3Top: NSLayoutConstraint?
    var imageView3Leading: NSLayoutConstraint?
    var imageView3Trailing: NSLayoutConstraint?
    var imageView3Bottom: NSLayoutConstraint?
    
    var imageView4Top: NSLayoutConstraint?
    var imageView4Leading: NSLayoutConstraint?
    var imageView4Trailing: NSLayoutConstraint?
    var imageView4Bottom: NSLayoutConstraint?
    
    var badgeLabelTrailing: NSLayoutConstraint?
    var badgeLabelBottom: NSLayoutConstraint?
    var badgeLabelWidth: NSLayoutConstraint?
    var badgeLabelHeight: NSLayoutConstraint?
    
    open lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        return playButtonView
    }()
    
    /// The image view display the media content.
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    open var imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.isHidden = true
        return imageView
    }()
    open var imageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.isHidden = true
        return imageView
    }()
    open var imageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.isHidden = true
        return imageView
    }()
    
    open var mediaView: UIView = {
        let view = UIView()
        return view
    }()
    
    open var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    
    let badgeLabel:UIBadgeLabel = {
        let badge = UIBadgeLabel()
        badge.textAlignment = .center
        badge.font = UIFont.boldSystemFont(ofSize: 18)
        badge.isHidden = true
        badge.badgeColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        badge.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return badge
    }()
    
    open override func setupSubviews() {
        super.setupSubviews()
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        //displayDelegate.configureMediaMessageImageView(imageView, for: message, at: indexPath, in: messagesCollectionView)
        let dataSource = messagesCollectionView.messagesDataSource
        
        if (dataSource!.isFromCurrentSender(message: message)) {
            mediaViewLeading?.constant = 5
            mediaViewTrailing?.constant = -10
            
            mediaView.updateConstraints()
        }
        else {
            mediaViewLeading?.constant = 10
            mediaViewTrailing?.constant = -5
            
            mediaView.updateConstraints()
        }
        
        switch message.kind {
        case .photo(let mediaItem):
            playButtonView.isHidden = true
            if let photoItem = mediaItem as? ImageMediaItem {
                if (photoItem.image != nil) {
                    imageView.image = photoItem.image
                }
                else if photoItem.url != nil {
                    DispatchQueue.main.async {
                        if let url = photoItem.url  {
                            self.imageView.kf.indicatorType = .activity
                            self.imageView.kf.setImage(with: url)
                        }
                    }
                }
                else if (photoItem.images != nil && photoItem.images!.count > 0) {
                    DispatchQueue.main.async {
                        self.addImagesToImageView(photoItem)
                    }
                    /*imageView.animationImages = photoItem.images!
                    imageView.animationDuration = 2.0
                    imageView.startAnimating()*/
                }
                else if (photoItem.urls != nil && photoItem.urls!.count > 0) {
                    DispatchQueue.main.async {
                        self.addUrlsToImageView(photoItem)
                    }
                    
                    /*var images: [UIImage] = []
                    imageView.animationImages = images
                    photoItem.images = images
                    
                    imageView.animationDuration = 5.0
                    DispatchQueue.main.async {
                        photoItem.urls!.forEach({
                            ImageDownloader.default.downloadImage(with: $0, options: [], progressBlock: nil) {
                               (image, error, url, data) in
                                images.append(image!)
                                if images.count == photoItem.urls!.count {
                                    self.imageView.animationImages = images
                                    photoItem.images = images
                                    self.imageView.startAnimating()
                                }
                            }
                        })
                    }*/
                }
            }
            break
        case .video(let mediaItem):
            if let videoItem = mediaItem as? VideoMediaItem {
                if (videoItem.image != nil) {
                    imageView.image = videoItem.image
                }
                else if videoItem.thumbnailUrl != nil {
                    DispatchQueue.main.async {
                        if let url = videoItem.thumbnailUrl  {
                            self.imageView.kf.indicatorType = .activity
                            self.imageView.kf.setImage(with: url)
                        }
                    }
                }
            }
            else {
                imageView.image = mediaItem.image ?? mediaItem.placeholderImage
            }
            playButtonView.isHidden = false
            break
        default:
            break
        }
    }
    
    private func addImagesToImageView(_ photoItem: ImageMediaItem) {
        
        if photoItem.images!.count == 1 {
            imageView.image = photoItem.images![0]
        }
        else if photoItem.images!.count == 2 {
            imageView.image = photoItem.images![0]
            imageView2.image = photoItem.images![1]
        }
        else if photoItem.images!.count == 3 {
            
            imageView.image = photoItem.images![0]
            imageView2.image = photoItem.images![1]
            imageView3.image = photoItem.images![2]
        }
        else if photoItem.images!.count >= 4 {
            
            if photoItem.images!.count > 4 {
                let rest = photoItem.images!.count - 4
                setBadge(rest)
            }
            
            imageView.image = photoItem.images![0]
            imageView2.image = photoItem.images![1]
            imageView3.image = photoItem.images![2]
            imageView4.image = photoItem.images![3]
        }
    }
    
    
    private func addUrlsToImageView(_ photoItem: ImageMediaItem) {
        
        if photoItem.thumbnailUrls!.count == 1 {
            imageView.kf.indicatorType = .activity
            
            if let url1 = photoItem.thumbnailUrls?[0]  {
                imageView.kf.setImage(with: url1)
            }
        }
        else if photoItem.thumbnailUrls!.count == 2 {
            imageView.kf.indicatorType = .activity
            imageView2.kf.indicatorType = .activity
            
            if let url1 = photoItem.thumbnailUrls?[0]  {
                imageView.kf.setImage(with: url1)
            }
            
            if let url2 = photoItem.thumbnailUrls?[1] {
                imageView2.kf.setImage(with: url2)
            }
        }
        else if photoItem.thumbnailUrls!.count == 3 {
            
            imageView.kf.indicatorType = .activity
            imageView2.kf.indicatorType = .activity
            imageView3.kf.indicatorType = .activity
            
            if let url1 = photoItem.thumbnailUrls?[0]  {
                imageView.kf.setImage(with: url1)
            }
            
            if let url2 = photoItem.thumbnailUrls?[1] {
                imageView2.kf.setImage(with: url2)
            }
            
            if let url3 = photoItem.thumbnailUrls?[2]  {
                imageView3.kf.setImage(with: url3)
            }
        }
        else if photoItem.thumbnailUrls!.count >= 4 {
            
            imageView.kf.indicatorType = .activity
            imageView2.kf.indicatorType = .activity
            imageView3.kf.indicatorType = .activity
            imageView4.kf.indicatorType = .activity
            
            if photoItem.urls!.count > 4 {
                let rest = photoItem.urls!.count - 4
                setBadge(rest)
            }
            
            if let url1 = photoItem.thumbnailUrls?[0]  {
                imageView.kf.setImage(with: url1)
            }
            
            if let url2 = photoItem.thumbnailUrls?[1] {
                imageView2.kf.setImage(with: url2)
            }
            
            if let url3 = photoItem.thumbnailUrls?[2]  {
                imageView3.kf.setImage(with: url3)
            }
            
            if let url4 = photoItem.thumbnailUrls?[3]  {
                imageView4.kf.setImage(with: url4)
            }
        }
    }
    
    
    private func setBadge(_ num: Int) {
        badgeLabel.text = "\(num)+ "
        
        let width = badgeLabel.intrinsicContentSize.width + 5
        badgeLabelWidth?.isActive = false
        badgeLabelHeight?.isActive = false
        badgeLabelWidth = badgeLabel.widthAnchor.constraint(equalToConstant: width)
        badgeLabelHeight = badgeLabel.heightAnchor.constraint(equalToConstant: width)
        badgeLabelWidth?.isActive = true
        badgeLabelHeight?.isActive = true
        
        badgeLabel.updateConstraints()
        badgeLabel.isHidden = false
    }
    
    
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: imageView)
        guard imageView.frame.contains(touchLocation) else {
            super.handleTapGesture(gesture)
            return
        }
        delegate?.didTapMessage(in: self)
    }
}
