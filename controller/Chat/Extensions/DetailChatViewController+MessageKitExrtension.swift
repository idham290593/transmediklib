//
//  DetailChatViewController+MessageKitExrtension.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import AVFoundation
import AVKit
import MobileCoreServices
import InputBarAccessoryView
import Lightbox
import SwiftyJSON

extension DetailChatViewController {
    
    // MARK: - Helpers
    
    func insertMessage(_ message: MockMessage) {
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func updateMessage(_ message: MockMessage, at: Int) {
        messageList[at] = message
        messagesCollectionView.reloadSections([at])
    }
    
    func removeMessage(at: Int) {
        messageList.remove(at: at)
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.deleteSections([at])
            
        }) { [weak self] _ in
            
        }
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    // MARK: - MessagesDataSource
    
    func currentSender() -> SenderType {
        return MockUser(senderId: currentUser!.objectId!, displayName: (currentUser!.username ?? currentUser!.email)!)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
}


// MARK: - MessageCellDelegate

extension DetailChatViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            print("Failed to identify message")
            return
        }
        
        switch message.kind {
        case .text(let textItem):
            if let msg = message as? MockMessage {
                if msg.type == AppSettings.URL_TYPE {
                    willOpenUrl(text: textItem)
                }
                else if msg.type == AppSettings.SPA_TYPE {
                    let vc = CatatanDokterViewController()
                    vc.json = JSON(parseJSON: textItem)
                    vc.consultation = currentConsultation
                    vc.date = msg.sentDate
                    
                    self.present(vc, animated: true, completion: nil)
                }
                else if msg.type == AppSettings.RESEP_DOKTER_TYPE {
                    
                    let vcs = UIStoryboard(name: "Chat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "ResepViewController") as? ResepViewController
                    vcs?.json = JSON(parseJSON: textItem)
                    vcs?.consultation = currentConsultation
                    self.present(vcs!, animated: true, completion: nil)
                    
//                    let vc = ResepDokterViewController()
//                    vc.json = JSON(parseJSON: textItem)
//                    vc.consultation = currentConsultation
//                    vc.date = msg.sentDate
//
////                    vc.consultationEnded = self.consultationEnded
//
//                    self.resepViewController = vc
//                    self.present(vc, animated: true, completion: nil)
                }
                else if msg.type == AppSettings.IMAGE_TYPE {
//                    let vc = UIStoryboard(name: "Sizeimage", bundle: nil).instantiateViewController(withIdentifier: "sizeimageViewController") as? sizeimageViewController
//                    vc.consultationEnded = self.consultationEnded

                    print(JSON(parseJSON: textItem))
                    
//                    self.present(vc!, animated: true, completion: nil)
                }
                else if msg.type == AppSettings.CATATAN_TYPE {
                    let json = JSON(parseJSON: textItem)
                    if json["note"].exists() {
                        let catatan = json["note"].string
                        var next_schedule = json["next_schedule"].string
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = dateFormatter.date(from: next_schedule!)
                        
                        dateFormatter.dateFormat = "E, d MMM yyyy"
                        next_schedule = dateFormatter.string(from: date!)
                        
                        var description = "\(LocalizationHelper.getInstance()?.dokter ?? "") :  \(currentConsultation?.doctor?.full_name ?? "")\r\n"
                        description += "\(LocalizationHelper.getInstance()?.chat_lagi_pada ?? "") : \(next_schedule ?? "")\r\n"
                        description += "\(LocalizationHelper.getInstance()?.pesan_dokter ?? "") :\r\n\(catatan ?? "")"
                        
                        EventHelper.addEventToCalendar(id : msg.messageId, title: "\(AppSettings.APPS_NAME) : \(LocalizationHelper.getInstance()?.jadwal_konsultasi ?? "")", description: description, startDate: date!, endDate: date!) { (result, error) in
                            DispatchQueue.main.async {
                                if (result) {
                                    Toast.show(message: LocalizationHelper.getInstance()?.event_added ?? "", controller: self)
                                }
                                else {
                                    Toast.show(message: error as! String, controller: self)
                                }
                            }
                        }
                    }
                }
            }
            break
        case .attributedText(let textItem):
            if let msg = message as? MockMessage {
                if msg.type == AppSettings.URL_TYPE {
                    willOpenUrl(text: textItem.string)
                }
                else if msg.type == AppSettings.SPA_TYPE {
                    let vc = CatatanDokterViewController()
                    vc.json = JSON(parseJSON: textItem.string)
                    vc.consultation = currentConsultation
                    vc.date = msg.sentDate
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
                else if msg.type == AppSettings.PHR_REQ {

                    let alert = UIAlertController(title: "Infomasi Kesehatan Pasien", message: "", preferredStyle: .actionSheet)
                    let Tolak = UIAlertAction(title: "Tolak", style: .default) { ( _ ) in
                       
                        self.updatestausphr(status: "DENIED", message_id:  message.messageId, consultation_id: String(self.currentConsultation!.consultation_id!))
                    }
                    let Terima = UIAlertAction(title: "Terima", style: .default) { ( _ ) in
                        self.updatestausphr(status: "ALLOWED", message_id:  message.messageId, consultation_id: String(self.currentConsultation!.consultation_id!))

                    }
                    
                 
                    alert.addAction(Terima)
                    alert.addAction(Tolak)
                   
                    
                    self.present(alert, animated: true, completion: nil)

                }
                else if msg.type == AppSettings.IMAGE_TYPE {
                    let vc = UIStoryboard(name: "Sizeimage", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "sizeimageViewController") as? sizeimageViewController

                    vc?.gambar = textItem.string
                   
                    self.present(vc!, animated: true, completion: nil)
                }
                
                
                else if msg.type == AppSettings.RESEP_DOKTER_TYPE {
                    let vcs = UIStoryboard(name: "Chat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "ResepViewController") as? ResepViewController
                    vcs?.json = JSON(parseJSON: textItem.string)
                    vcs?.consultation = currentConsultation
                    self.present(vcs!, animated: true, completion: nil)
                    
                    
//                    let vc = ResepDokterViewController()
//                    vc.json = JSON(parseJSON: textItem.string)
//                    vc.consultation = currentConsultation
//                    vc.date = msg.sentDate
////                    vc.consultationEnded = self.consultationEnded
//                    
//                    self.resepViewController = vc
//                    self.present(vc, animated: true, completion: nil)
                }
                else if msg.type == AppSettings.CATATAN_TYPE {
                    let json = JSON(parseJSON: textItem.string)
                    if json["note"].exists() {
                        let catatan = json["note"].string
                        var next_schedule = json["next_schedule"].string
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = dateFormatter.date(from: next_schedule!)
                        
                        dateFormatter.dateFormat = "E, d MMM yyyy"
                        next_schedule = dateFormatter.string(from: date!)
                        
                        var description = "\(LocalizationHelper.getInstance()?.dokter ?? "") :  \(currentConsultation?.doctor?.full_name ?? "")\r\n"
                        description += "\(LocalizationHelper.getInstance()?.chat_lagi_pada ?? "") : \(next_schedule ?? "")\r\n"
                        description += "\(LocalizationHelper.getInstance()?.pesan_dokter ?? "") :\r\n\(catatan ?? "")"
                        
                        EventHelper.addEventToCalendar(id : msg.messageId, title: "\(AppSettings.APPS_NAME) : \(LocalizationHelper.getInstance()?.jadwal_konsultasi ?? "")", description: description, startDate: date!, endDate: date!) { (result, error) in
                            DispatchQueue.main.async {
                                if (result) {
                                    Toast.show(message: LocalizationHelper.getInstance()?.event_added ?? "", controller: self)
                                }
                                else {
                                    Toast.show(message: error as! String, controller: self)
                                }
                            }
                        }
                    }
                }
            }
            break
        case .photo(let photoItem):
            /// if we don't have a url, that means it's simply a pending message
            willPreviewPhoto(photo: photoItem)
            break
        case .video(let videoItem):
            willPreviewVideo(video: videoItem)
            break
        default:
            break
        }
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        print("Image tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
        
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            print("Failed to identify message")
            return
        }
        
        switch message.kind {
        case .text(let textItem):
            if let msg = message as? MockMessage {
                if msg.type == AppSettings.RESEP_DOKTER_TYPE {
                    let json = JSON(parseJSON: textItem)
                    if json["recipes"].exists() {
                        var expires = json["expires"].string
                        expires = String(expires?.prefix(10) ?? "")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = dateFormatter.date(from: expires!)
                        
                        dateFormatter.dateFormat = "E, d MMM yyyy"
                        expires = dateFormatter.string(from: date!)
                        
                        let title = "\(AppSettings.APPS_NAME) : \(LocalizationHelper.getInstance()?.resep_expire ?? "")"
                        
                        var description = "\(LocalizationHelper.getInstance()?.dokter ?? "") :  \(currentConsultation?.doctor?.full_name ?? "")\r\n"
                        description += "\(LocalizationHelper.getInstance()?.resep_berlaku ?? "") : \(expires ?? "")"
                        
                        EventHelper.addEventToCalendar(id : msg.messageId, title: title, description: description, startDate: date!, endDate: date!) { (result, error) in
                            DispatchQueue.main.async {
                                if (result) {
                                    Toast.show(message: LocalizationHelper.getInstance()?.event_added ?? "", controller: self)
                                }
                                else {
                                    Toast.show(message: error as! String, controller: self)
                                }
                            }
                        }
                    }
                }
            }
            break
        case .attributedText(let textItem):
            if let msg = message as? MockMessage {
                if msg.type == AppSettings.RESEP_DOKTER_TYPE {
                    let json = JSON(parseJSON: textItem.string)
                    if json["recipes"].exists() {
                        var expires = json["expires"].string
                        expires = String(expires?.prefix(10) ?? "")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = dateFormatter.date(from: expires!)
                        
                        dateFormatter.dateFormat = "E, d MMM yyyy"
                        expires = dateFormatter.string(from: date!)
                        
                        let title = "\(AppSettings.APPS_NAME) : \(LocalizationHelper.getInstance()?.resep_expire ?? "")"
                        
                        var description = "\(LocalizationHelper.getInstance()?.dokter ?? "") :  \(currentConsultation?.doctor?.full_name ?? "")\r\n"
                        description += "\(LocalizationHelper.getInstance()?.resep_berlaku ?? "") : \(expires ?? "")"
                        
                        EventHelper.addEventToCalendar(id : msg.messageId, title: title, description: description, startDate: date!, endDate: date!) { (result, error) in
                            DispatchQueue.main.async {
                                if (result) {
                                    Toast.show(message: LocalizationHelper.getInstance()?.event_added ?? "", controller: self)
                                }
                                else {
                                    Toast.show(message: error as! String, controller: self)
                                }
                            }
                        }
                    }
                }
            }
            break
        case .photo(let photoItem):
            /// if we don't have a url, that means it's simply a pending message
            break
        case .video(let videoItem):
            break
        default:
            break
        }
    }
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            print("Failed to identify message when audio cell receive tap gesture")
            return
        }
        guard audioController.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }
    
    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }
    
    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }
    
    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
    
}

// MARK: - MessageLabelDelegate

extension DetailChatViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }
    
    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }
    
    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }
    
    
    func willOpenUrl(text: String) {
        let urlDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = urlDetector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            
            var url = text[range].description
            if !url.contains("http") {
                url = "http://" + url
            }
            
            var chromeUrl = url.replacingOccurrences(of: "http://", with: "googlechrome://")
            chromeUrl = chromeUrl.replacingOccurrences(of: "https://", with: "googlechromes://")
            
            if UIApplication.shared.canOpenURL(URL(string: chromeUrl)!) {
                UIApplication.shared.open(URL(string: chromeUrl)!)
            }
            else {
                UIApplication.shared.open(URL(string: url)!)
            }
            
            break
        }
    }
    
    func willPreviewVideo(video: MediaItem) {
        if let media = video as? VideoMediaItem {
            if media.url != nil {
                
                /*var text = media.attributedText?.string ?? ""
                 let imgs = [LightboxImage(imageURL: media.thumbnailUrl!, text: text, videoURL: media.url!)]
                 let controller = LightboxController(images: imgs)
                 controller.modalPresentationStyle = .fullScreen
                 controller.dynamicBackground = true
                 self.present(controller, animated: true)*/
                
                let player = AVPlayer(url: media.url!)
                let playerViewController = AVPlayerViewController()
                playerViewController.modalPresentationStyle = .popover
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }
    }
    
    func willPreviewPhoto(photo: MediaItem) {
        if let media = photo as? ImageMediaItem {
            
            if media.image != nil {
                
                let imgs = [LightboxImage(image: media.image ?? UIImage())]
                let controller = LightboxController(images: imgs)
                controller.modalPresentationStyle = .fullScreen
                controller.dynamicBackground = true
                self.present(controller, animated: true)
            }
            else if media.url != nil {
                
                let imgs = [LightboxImage(imageURL: media.url!)]
                let controller = LightboxController(images: imgs)
                controller.modalPresentationStyle = .fullScreen
                controller.dynamicBackground = true
                self.present(controller, animated: true)
            }
            else if (media.images != nil && media.images!.count > 0 && (media.urls == nil || media.urls!.count <= 0)) {
                var imgs : [LightboxImage] = []
                for i in 0..<media.images!.count {
                    imgs.append(LightboxImage(image: media.images![i] ))
                }
                
                let controller = LightboxController(images: imgs)
                controller.modalPresentationStyle = .fullScreen
                controller.dynamicBackground = true
                self.present(controller, animated: true)
            }
            else if (media.urls != nil && media.urls!.count > 0) {
                var urls : [LightboxImage] = []
                for i in 0..<media.urls!.count {
                    urls.append(LightboxImage(imageURL: media.urls![i] ))
                }
                
                let controller = LightboxController(images: urls)
                controller.modalPresentationStyle = .fullScreen
                controller.dynamicBackground = true
                self.present(controller, animated: true)
                
                /*DispatchQueue.main.async {
                 media.urls!.forEach({
                 ImageDownloader.default.downloadImage(with: $0, options: [], progressBlock: nil) {
                 (image, error, url, data) in
                 controller.images.append(LightboxImage(image: image!))
                 }
                 })
                 }*/
            }
        }
    }
}


// MARK: - MessageInputBarDelegate

extension DetailChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        /*let attributedText = messageInputBar.inputTextView.attributedText!
         let range = NSRange(location: 0, length: attributedText.length)
         attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
         
         let substring = attributedText.attributedSubstring(from: range)
         let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
         print("Autocompleted: `", substring, "` with context: ", context ?? [])
         }*/
        
        if !CheckInternet.Connection(){
            return Toast.show(message: "Tolong cek koneksi anda!.", controller: self)
        }
        
        let attachments = attachmentManager.attachments
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        mediaType = "image"
        
        /*messageInputBar.reloadInputViews()
         messageInputBar.layoutIfNeeded()*/
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        
        isTyping = false
        
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components, attachments)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
}



extension DetailChatViewController: AttachmentManagerDelegate {
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        self.messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        self.messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        if manager.attachments.count <= 0 {
            self.videoThumbnail = nil
            self.videoUrl = nil
        }
        self.messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.willOpenCamera();
        }
        
        let galleryAction = UIAlertAction(title: "Photos", style: .default) { (action) in
            self.willOpenGallery();
        }
        
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(photoAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(action)
        
        self.navigationController?.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func setAttachmentManager(active: Bool) {
        let topStackView = self.messageInputBar.topStackView
        
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
            
            self.messageInputBar.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
            self.messageInputBar.layoutIfNeeded()
        }
    }
    
}

extension DetailChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func willOpenCamera() {
        let vc = UIImagePickerController()
        if mediaType == "video" {
            attachmentManager.invalidate()
            attachmentManager.showAddAttachmentCell = true
        }
        
        self.videoThumbnail = nil
        self.videoUrl = nil
        
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        mediaType = "image"
        self.present(vc, animated: true)
    }
    
    func willOpenGallery() {
        let vc = UIImagePickerController()
        if mediaType == "video" {
            attachmentManager.invalidate()
            attachmentManager.showAddAttachmentCell = true
        }
        
        self.videoThumbnail = nil
        self.videoUrl = nil
        
        vc.sourceType = .photoLibrary
        vc.mediaTypes = [kUTTypeImage as String]
        vc.allowsEditing = true
        vc.delegate = self
        mediaType = "image"
        self.present(vc, animated: true)
    }
    
    func willOpenVideo() {
        let vc = UIImagePickerController()
        
        attachmentManager.invalidate()
        attachmentManager.showAddAttachmentCell = false
        
        self.videoThumbnail = nil
        self.videoUrl = nil
        
        vc.sourceType = .photoLibrary
        vc.mediaTypes = [kUTTypeMovie as String]
        vc.allowsEditing = true
        vc.delegate = self
        mediaType = "video"
        self.present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info imagepicket")
        print(info)
        print("=============")
        print(info["UIImagePickerControllerMediaType"])
        print(info["UIImagePickerControllerEditedImage"])
        dismiss(animated: true, completion: {
            self.attachmentManager.showAddAttachmentCell = true

            self.videoThumbnail = nil
            self.videoUrl = nil

            if let pickedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                if let image1 = pickedImage.resizeWithWidth(width: AppSettings.maxImageWidth) {
                    self.sendimage(dataimage: image1)
                }
            }
            
            else if let pickedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                if let image1 = pickedImage.resizeWithWidth(width: AppSettings.maxImageWidth) {
                    self.sendimage(dataimage: image1)

                }
            }

        })
        
      
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("info imagepicket")
        print(info)

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        dismiss(animated: true, completion: {
            if self.mediaType == "video" {
                self.attachmentManager.showAddAttachmentCell = false
//                if let videoURL = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL {


                if   let videoURL = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerControllerMediaURL as UIImagePickerController.InfoKey)] as? URL {

                    let asset = AVURLAsset(url: videoURL, options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    do {
                        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                        self.videoThumbnail = UIImage(cgImage: cgImage).resizeWithWidth(width: AppSettings.videoThumbnailWidth)

                        /*self.videoUrl = videoURL
                         print(self.videoUrl)

                         let handled = self.attachmentManager.handleInput(of: self.videoThumbnail!)
                         if !handled {
                         // throw error
                         print("error")
                         }*/

                        let name = "\(Int(Date().timeIntervalSince1970)).mp4"

                        let dispatchgroup = DispatchGroup()

                        dispatchgroup.enter()

                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let outputurl = documentsURL.appendingPathComponent(name)
                        var videoOuputURL = outputurl
                        self.convertVideo(toMPEG4FormatForVideo: videoURL as URL, outputURL: outputurl) { (session) in

                            videoOuputURL = session.outputURL!
                            dispatchgroup.leave()

                        }
                        dispatchgroup.wait()

                        self.videoUrl = videoOuputURL

                        let handled = self.attachmentManager.handleInput(of: self.videoThumbnail!)
                        if !handled {
                            // throw error
                            print("error")
                        }

                    } catch let error {
                        print("*** Error generating thumbnail: \(error.localizedDescription)")
                    }
                }
            }
            else {
                self.attachmentManager.showAddAttachmentCell = true

                self.videoThumbnail = nil
                self.videoUrl = nil

                if let pickedImage = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerControllerEditedImage as UIImagePickerController.InfoKey)] as? UIImage {
                    if let image1 = pickedImage.resizeWithWidth(width: AppSettings.maxImageWidth) {
                        self.sendimage(dataimage: image1)
//                        let handled = self.attachmentManager.handleInput(of: image1)
//                        self.database.request { (user) in
//                            if user != nil {
//                                self.apichat.sendimagechat(images: image1, token :user![0].token!, consul: String(self.currentConsultation?.consultation_id ?? 0) ) { (status, msg, url) in
//                                    if status{
//                                        self.sendimage(data: url!)
//
//                                    }
//                                }
//                            }
//                        }

//                        if !handled {
//                            // throw error
//                            print("error")
//                        }
                    }
                }
                else if let pickedImage = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerControllerOriginalImage as UIImagePickerController.InfoKey)] as? UIImage {
                    if let image1 = pickedImage.resizeWithWidth(width: AppSettings.maxImageWidth) {
                        self.sendimage(dataimage: image1)

//                        self.database.request { (user) in
//                            if user != nil {
//                                self.apichat.sendimagechat(images: image1, token :user![0].token!, consul: String(self.currentConsultation?.consultation_id ?? 0) ) { (status, msg, url) in
//                                    if status{
//                                        self.sendimage(data: url!)
//
//                                    }
//                                }
//                            }
//                        }
//                        let handled = self.attachmentManager.handleInput(of: image1)
//                        if !handled {
//                            // throw error
//                            print("error")
//                        }
                    }
                }
            }
        })
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key as String, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input as String
    }
    
    func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        if FileManager.default.fileExists(atPath: outputURL.absoluteString) {
            try! FileManager.default.removeItem(at: outputURL as URL)
        }
        let asset = AVURLAsset(url: inputURL as URL, options: nil)
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
    }
    
    
    
    @objc  func configureMessageCollectionView() {
        
        messagesCollectionView.showsVerticalScrollIndicator = false
        messagesCollectionView.showsHorizontalScrollIndicator = false
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
//        messagesCollectionView.addSubview(refreshControl)
        
        layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        
        // Set outgoing avatar to overlap with the message bubble
        //layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAvatarSize(.zero)
        
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 8, bottom: outgoingAvatarOverlap, right: 0)))
        //layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 18, bottom: outgoingAvatarOverlap, right: 0)))
        //layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: -18, bottom: outgoingAvatarOverlap, right: 18))
        
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        layout?.setMessageIncomingAccessoryViewPosition(.messageBottom)
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
        
        messagesCollectionView.messagesLayoutDelegate = self as MessagesLayoutDelegate
        messagesCollectionView.messagesDisplayDelegate = self as MessagesDisplayDelegate
        
//        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    @objc  func configureMessageInputBar() {
        
        messageInputBar.delegate = self
        //messageInputBar.inputTextView.delegate = self
//        messageInputBar.inputTextView.tintColor = AppColor.shared.instance(traitCollection).messageBarBackgroundColor
        messageInputBar.inputTextView.tintColor = .white

        messageInputBar.sendButton.setTitleColor(AppColor.shared.instance(traitCollection).buttonTextColor, for: .normal)
        messageInputBar.sendButton.setTitleColor(AppColor.shared.instance(traitCollection).buttonTextColor, for: .highlighted)
        
        messageInputBar.isTranslucent = false
        messageInputBar.separatorLine.isHidden = true
        //messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        //UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        /*if #available(iOS 13.0, *) {
         messageInputBar.inputTextView.textColor = .label
         messageInputBar.inputTextView.placeholderTextColor = .secondaryLabel
         //messageInputBar.inputTextView.placeholderLabel.textColor = .secondaryLabel
         messageInputBar.backgroundView.backgroundColor = .systemBackground
         } else {
         messageInputBar.inputTextView.textColor = .black
         messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
         messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
         }*/
        //messageInputBar.inputTextView.textColor = .black
        configureInputBarItems()
    }
    
    
    private func configureInputBarItems() {
        
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        //messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.image = UIImage(named: "send", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)?.withTintColor(.white)
//        messageInputBar.sendButton.image = UIImage(named: "Vector")?.withTintColor(.blue)
//        messageInputBar.sendButton.backgroundColor = .clear
//        messageInputBar.sendButton.imageView?.backgroundColor = .clear
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.middleContentViewPadding.right = -38
        messageInputBar.middleContentViewPadding.left = -30
        
        let attachButton = self.makeButton(named: "plus-round")
        //attachButton.isHidden = true
        let leftItems = [ attachButton ]
        messageInputBar.setStackViewItems(leftItems, forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 28, animated: false)
        messageInputBar.leftStackView.isHidden = true
        messageInputBar.leftStackView.alignment = .center
        
        
        messageInputBar.inputPlugins = [attachmentManager]
        /*let charCountButton = InputBarButtonItem()
         .configure {
         $0.title = "0/140"
         $0.contentHorizontalAlignment = .right
         $0.setTitleColor(UIColor(white: 0.6, alpha: 1), for: .normal)
         $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
         $0.setSize(CGSize(width: 50, height: 25), animated: false)
         }.onTextViewDidChange { (item, textView) in
         item.title = "\(textView.text.count)/140"
         let isOverLimit = textView.text.count > 140
         item.inputBarAccessoryView?.shouldManageSendButtonEnabledState = !isOverLimit // Disable automated management when over limit
         if isOverLimit {
         item.inputBarAccessoryView?.sendButton.isEnabled = false
         }
         let color = isOverLimit ? .red : UIColor(white: 0.6, alpha: 1)
         item.setTitleColor(color, for: .normal)
         }*/
        //let bottomItems = [.flexibleSpace, charCountButton]
        messageInputBar.middleContentViewPadding.bottom = 0
        
        // This just adds some more flare
    }
    
    // MARK: - Helpers
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        //return true
        return indexPath.section % 5 == 0// && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageList[indexPath.section].user.senderId == messageList[indexPath.section - 1].user.senderId
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].user.senderId == messageList[indexPath.section + 1].user.senderId
    }
    
    func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
        //let displayName = self.currentChat?.user?.name ?? ""
        //updateTitleView(title: displayName, subtitle: isHidden ? "" : "Typing...")
        
        setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
            if success, self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func makeButton(named: String) -> InputBarButtonItem {
        
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(1)
                $0.image = UIImage(named: named, in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)?.resizeWithWidth(width: 28)!.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 28, height: 36), animated: false)
                //$0.tintColor = UIColor(white: 0.8, alpha: 1)
                $0.tintColor = AppColor.shared.instance(self.traitCollection).buttonTextColor
                $0.contentEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
            }.onEnabled {
                $0.tintColor = AppColor.shared.instance(self.traitCollection).buttonTextColor
            }.onDisabled {
                $0.tintColor = AppColor.shared.instance(self.traitCollection).buttonTextColor
            }.onSelected {
                $0.tintColor = AppColor.shared.instance(self.traitCollection).buttonTextColor
            }.onDeselected {
                $0.tintColor = AppColor.shared.instance(self.traitCollection).buttonTextColor
            }.onTouchUpInside {
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                let photoAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                    self.willOpenCamera();
                }
                
                let galleryAction = UIAlertAction(title: "Photos", style: .default) { (action) in
                    self.willOpenGallery();
                }
                
               
                
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                actionSheet.addAction(photoAction)
                actionSheet.addAction(galleryAction)
//                actionSheet.addAction(videoAction)
                actionSheet.addAction(action)
                
                if let popoverPresentationController = actionSheet.popoverPresentationController {
                    popoverPresentationController.sourceView = $0
                    popoverPresentationController.sourceRect = $0.frame
                }
                self.navigationController?.present(actionSheet, animated: true, completion: nil)
            }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func detailChatCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }
        
        // Very important to check this when overriding `cellForItemAt`
        // Super method will handle returning the typing indicator cell
        guard !isSectionReservedForTypingIndicator(indexPath.section) else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        if case .custom = message.kind {
            let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }
        else if case .text = message.kind {
            if let msg = message as? MockMessage {
                //custom cellview for text kind
                if msg.type == AppSettings.URL_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(UrlMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.SPA_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(CatatanMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.CATATAN_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(CatatanMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.RESEP_DOKTER_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(ResepDokterMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.SESSION_ENDED_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.SYSTEM_MESSAGE_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
            }
        }
        else if case .attributedText = message.kind {
            if let msg = message as? MockMessage {
                //custom cellview for attributedText kind
                if msg.type == AppSettings.URL_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(UrlMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.SPA_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(CatatanMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.CATATAN_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(CatatanMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.RESEP_DOKTER_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(ResepDokterMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.PHR_REQ {
                    
                    let cell = messagesCollectionView.dequeueReusableCell(PHRMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.IMAGE_TYPE {
                    
                    let cell = messagesCollectionView.dequeueReusableCell(Imageloadmessagecell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.SESSION_ENDED_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else if msg.type == AppSettings.SYSTEM_MESSAGE_TYPE {
                    let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
            }
        }
        else if case .video(let mediaItem) = message.kind {
            if let videoItem = mediaItem as? VideoMediaItem {
                if videoItem.attributedText != nil && !(videoItem.attributedText?.string.isEmpty)! {
                    let cell = messagesCollectionView.dequeueReusableCell(TextWithOneMediaMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
                else {
                    let cell = messagesCollectionView.dequeueReusableCell(OneMediaOnlyMessageCell.self, for: indexPath)
                    cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                    return cell
                }
            }
        }
        else if case .photo(let mediaItem) = message.kind {
            if let photoItem = mediaItem as? ImageMediaItem {
                if photoItem.attributedText != nil && !(photoItem.attributedText?.string.isEmpty)! {
                    if (photoItem.images?.count ?? 0) >= 4 || (photoItem.urls?.count ?? 0) >= 4 {
                        let cell = messagesCollectionView.dequeueReusableCell(TextWithFourMediaMessageCell.self, for: indexPath)
                        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                        return cell
                    }
                    else if photoItem.images?.count == 3 || photoItem.urls?.count == 3 {
                        let cell = messagesCollectionView.dequeueReusableCell(TextWithThreeMediaMessageCell.self, for: indexPath)
                        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                        return cell
                    }
                    else if photoItem.images?.count == 2 || photoItem.urls?.count == 2 {
                        let cell = messagesCollectionView.dequeueReusableCell(TextWithTwoMediaMessageCell.self, for: indexPath)
                        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                        return cell
                    }
                    else {
                        let cell = messagesCollectionView.dequeueReusableCell(TextWithOneMediaMessageCell.self, for: indexPath)
                        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                        return cell
                    }
                }
                else {
                    if (photoItem.images?.count ?? 0) >= 4 || (photoItem.urls?.count ?? 0) >= 4 {
                        let cell = messagesCollectionView.dequeueReusableCell(FourMediaOnlyMessageCell.self, for: indexPath)
                        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                        return cell
                    }
                    else if photoItem.images?.count == 3 || photoItem.urls?.count == 3 {
                        let cell = messagesCollectionView.dequeueReusableCell(ThreeMediaOnlyMessageCell.self, for: indexPath)
                        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                        return cell
                    }
                    else if photoItem.images?.count == 2 || photoItem.urls?.count == 2 {
                        let cell = messagesCollectionView.dequeueReusableCell(TwoMediaOnlyMessageCell.self, for: indexPath)
                        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                        return cell
                    }
                    else {
                        let cell = messagesCollectionView.dequeueReusableCell(OneMediaOnlyMessageCell.self, for: indexPath)
                        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                        return cell
                    }
                }
            }
        }
        
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    // MARK: - MessagesDataSource
}
// MARK: - MessagesDisplayDelegate

extension DetailChatViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? AppColor.shared.instance(traitCollection).chatTextColor : AppColor.shared.instance(traitCollection).chatTextColor2
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention:
            if isFromCurrentSender(message: message) {
                return [.foregroundColor:  AppColor.shared.instance(traitCollection).textColor]
            } else {
                return [.foregroundColor: AppColor.shared.instance(traitCollection).clickLabelTextColor]
            }
        //default: return MessageLabel.defaultAttributes
        default: return [
            NSAttributedString.Key.foregroundColor: AppColor.shared.instance(traitCollection).chatTextColor,
//            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDash.rawValue,
            NSAttributedString.Key.underlineColor: AppColor.shared.instance(traitCollection).chatTextColor,
        ]
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        /*return isFromCurrentSender(message: message) ? .primaryColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)*/
        return isFromCurrentSender(message: message) ? AppColor.shared.instance(traitCollection).chatBackgroundColor : AppColor.shared.instance(traitCollection).chatBackgroundColor2
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.topRight)
            corners.formUnion(.bottomLeft)
            /*corners.formUnion(.topLeft)
             corners.formUnion(.bottomLeft)
             if !isPreviousMessageSameSender(at: indexPath) {
             corners.formUnion(.topRight)
             }
             if !isNextMessageSameSender(at: indexPath) {
             corners.formUnion(.bottomRight)
             }*/
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomRight)
            /*corners.formUnion(.topRight)
             corners.formUnion(.bottomRight)
             if !isPreviousMessageSameSender(at: indexPath) {
             }
             if !isNextMessageSameSender(at: indexPath) {
             corners.formUnion(.bottomLeft)
             }*/
        }
        
        let borderColor:UIColor = isFromCurrentSender(message: message) ? AppColor.shared.instance(self.traitCollection).chatBorderColor : AppColor.shared.instance(self.traitCollection).chatBorderColor2
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.borderColor = borderColor.cgColor
            view.layer.mask = mask
        }
        
        /*guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
         fatalError("Ouch. nil data source for messages")
         }
         
         let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
         
         
         let msg = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView) as! MockMessage
         
         //print(msg.status + " = " + msg.messageId)
         let borderColor:UIColor = isFromCurrentSender(message: message) ? AppColor.shared.instance(self.traitCollection).chatBorderColor : AppColor.shared.instance(self.traitCollection).chatBorderColor2
         return .bubbleTailOutline(borderColor, corner, .curved)*/
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        /*let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
         avatarView.set(avatar: avatar)
         avatarView.isHidden = isNextMessageSameSender(at: indexPath)
         avatarView.layer.borderWidth = 2
         avatarView.layer.borderColor = UIColor.primaryColor.cgColor*/
        avatarView.isHidden = true
    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
        
        /*accessoryView.subviews.forEach { $0.removeFromSuperview() }
         accessoryView.backgroundColor = .clear
         
         let shouldShow = Int.random(in: 0...10) == 0
         guard shouldShow else { return }
         
         let button = UIButton(type: .infoLight)
         button.tintColor = .primaryColor
         accessoryView.addSubview(button)
         button.frame = accessoryView.bounds
         button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
         accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
         accessoryView.backgroundColor = UIColor.primaryColor.withAlphaComponent(0.3)*/
        accessoryView.isHidden = true
    }
    
    // MARK: - Location Messages
    
    
    // MARK: - Audio Messages
    
    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return self.isFromCurrentSender(message: message) ? .white : .primaryColor
    }
    
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        audioController.configureAudioCell(cell, message: message) // this is needed especily when the cell is reconfigure while is playing sound
    }
    
    /*func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)
     {
     switch message.kind {
     case .photo(let mediaItem):
     /// if we don't have a url, that means it's simply a pending message
     if let photoItem = mediaItem as? ImageMediaItem {
     if (photoItem.image != nil) {
     imageView.image = photoItem.image
     }
     else if photoItem.url != nil {
     guard let url = photoItem.url else {
     imageView.kf.indicator?.startAnimatingView()
     return
     }
     imageView.kf.indicatorType = .activity
     imageView.kf.setImage(with: url)
     }
     else if (photoItem.images != nil && photoItem.images!.count > 0) {
     imageView.animationImages = photoItem.images!
     imageView.animationDuration = 2.0
     imageView.startAnimating()
     }
     else if (photoItem.urls != nil && photoItem.urls!.count > 0) {
     print("array URLS")
     }
     }
     default:
     break
     }
     }*/
    
}

// MARK: - MessagesLayoutDelegate

extension DetailChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 40
        }
        return 0
        
        
    }
    
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        /*if isFromCurrentSender(message: message) {
         return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
         } else {
         if isTimeLabelVisible(at: indexPath) {
         return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
         }
         else {
         return !isPreviousMessageSameSender(at: indexPath) ? (20 + outgoingAvatarOverlap) : 0
         }
         }*/
        return 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 2
    }
    
    func typingIndicatorViewSize(in messagesCollectionView: MessagesCollectionView) -> CGSize {
        let height = 28
        
        return CGSize(width: messagesCollectionView.bounds.size.width, height: CGFloat(height))
        
    }
}
