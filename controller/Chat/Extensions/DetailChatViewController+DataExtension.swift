//
//  DetailChatViewController+DataExtension.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import MessageKit
import InputBarAccessoryView
import Kingfisher
import Parse
import ParseLiveQuery
import SwiftyJSON

extension DetailChatViewController {
    
 
    
    
    internal func insertMessages(_ data: [Any], _ attachments: [AttachmentManager.Attachment]?) {
        self.updateTyping(status: nil)
        
        if data.count <= 0 {
            //sendAttachments(attachments)
        }
        else {
            if (attachments != nil && attachments!.count > 0) {
                //sendTextMessageWithAttachments(data, attachments)
            }
            else {
                print("send text message")
                sendTextMessage(data, AppSettings.TEXT_TYPE)
            }
        }
        
    }
    
    
    
    internal func sendTextMessage(_ data: [Any], _ kind: String) {
        for component in data {
            if let str = component as? String {
                
                let messageUid = UUID().uuidString
                let date = Date()
                
                
                
                let msg = ConversationModel.init(
                    messageId: messageUid,
                    sender_id: currentUser!,
                    user: currentDoctor!,
                    text: str,
                    date: date,
                    uid: currentUser!,
                    consultation_id: "\((currentConsultation?.consultation_id!)!)",
                    status: AppSettings.NOT_SEND,
                    kind: kind
                )
                
                //                msg.saveEventually()
                print("Kirim")
                msg.saveEventually { (status, err) in
                    if err != nil {
                        print(err)
                        return
                    }
                    print("status")
                    
                }
                
                
                let message = MockMessage(
                    attributedText: NSAttributedString(string: msg.text ?? "", attributes: self.attributes)
                    ,
                    user: MockUser(senderId: msg.sender_id?.objectId ?? "",displayName: msg.sender_id?.username ?? "")
                    ,
                    messageId: msg.messageId ?? "",
                    date: msg.date ?? Date(),
                    status: msg.status ?? AppSettings.NOT_SEND,
                    type: msg.kind
                )
                
                insertMessage(message)
            } else if let img = component as? UIImage {
                //handle image
            }
        }
    }
    
    //    updatestausphr
    func sendimage(dataimage : UIImage ){
        let messageUid = UUID().uuidString
        let date = Date()
        
        let msg = ConversationModel.init(
            messageId: messageUid,
            sender_id: currentUser!,
            user: currentDoctor!,
            text: "Uploading",
            date: date,
            uid: currentUser!,
            consultation_id: "\((currentConsultation?.consultation_id!)!)",
            status: AppSettings.NOT_SEND,
            kind: "image"
        )
        msg.saveEventually { (status, err) in
            if err != nil {
                print(err)
                return
            }
            //===
            
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                self.apichat.sendimagechat(images: dataimage, token :token, consul: String(self.currentConsultation?.consultation_id ?? 0) ) { (status, msg, url) in
                    if status{
                        self.ubahdatagambar(msg_id: messageUid, Url: url!)
                    }
                }
            }
            
            
            
        }
        
        
    }
    
    func sendimage(data : String ){
        let messageUid = UUID().uuidString
        let date = Date()
        
        let msg = ConversationModel.init(
            messageId: messageUid,
            sender_id: currentUser!,
            user: currentDoctor!,
            text: data,
            date: date,
            uid: currentUser!,
            consultation_id: "\((currentConsultation?.consultation_id!)!)",
            status: AppSettings.NOT_SEND,
            kind: "image"
        )
        //                msg.saveEventually()
        print("Kirim")
        msg.saveEventually { (status, err) in
            if err != nil {
                print(err)
                return
            }
            print("status")
            print(status)
        }
        
        let message = MockMessage(
            attributedText: NSAttributedString(string: msg.text ?? "", attributes: self.attributes)
            ,
            user: MockUser(senderId: msg.sender_id?.objectId ?? "",displayName: msg.sender_id?.username ?? "")
            ,
            messageId: msg.messageId ?? "",
            date: msg.date ?? Date(),
            status: msg.status ?? AppSettings.SENT_STATUS,
            type: msg.kind
        )
        
        insertMessage(message)
    }
    
    
    
    func reloadMoreMessages() {
        
    }
    
    
    func buildMessageText(_ msg: ConversationModel) -> MockMessage {
        let message = MockMessage(
            attributedText: NSAttributedString(string: msg.text ?? "", attributes: self.attributes)
            ,
            user: MockUser(senderId: msg.sender_id?.objectId ?? "",displayName: msg.sender_id?.username ?? "")
            ,
            messageId: msg.messageId ?? "",
            date: msg.date ?? Date(),
            status: msg.status ?? AppSettings.SENT_STATUS,
            type: msg.kind
        )
        if (msg.sender_id?.objectId != self.currentUser?.objectId && msg.status != AppSettings.SEEN_STATUS) {
            updated.append(msg)
            //self.updateMessageStatus(message: msg)
        }
        return message
    }
    
    
    func buildMessageSystem(_ msg: ConversationModel) -> MockMessage {
        var _text = msg.text
        if (msg.kind == AppSettings.CATATAN_TYPE) {
            _text = "\(self.currentConsultation?.doctor?.full_name ?? "")\r\n \(LocalizationHelper.getInstance()?.catatan_system_msg ?? "")"
        }
        else if (msg.kind == AppSettings.SPA_TYPE) {
            _text = "\(self.currentConsultation?.doctor?.full_name ?? "")\r\n \(LocalizationHelper.getInstance()?.spa_system_msg ?? "")"
        }
        else if (msg.kind == AppSettings.RESEP_DOKTER_TYPE) {
            _text = "\(self.currentConsultation?.doctor?.full_name ?? "")\r\n \(LocalizationHelper.getInstance()?.resep_system_msg ?? "")"
        }
        let message = MockMessage(
            attributedText: NSAttributedString(string: _text ?? "", attributes: self.attributes)
            ,
            user: MockUser(senderId: msg.sender_id?.objectId ?? "",displayName: msg.sender_id?.username ?? "")
            ,
            messageId: "systemmsg \(msg.messageId ?? "")",
            date: msg.date ?? Date(),
            status: msg.status ?? AppSettings.SENT_STATUS,
            type: AppSettings.SYSTEM_MESSAGE_TYPE
        )
        
        return message
    }
    
    func initializeMessages() {
        self.messageList.removeAll()
        //self.messagesCollectionView.reloadData()
        //self.messagesCollectionView.scrollToBottom()
        updated = []
        
        self.conversationQuery.findObjectsInBackground(block: { (results, error) in
            if error == nil {
                if let messages = results as? [ConversationModel] {
                    print("findObjectsInBackground")
                    print(messages.count)
                    for msg in messages {
                        let index = self.messageList.firstIndex(where: {$0.messageId == msg.messageId})
                        
                        
                        if (index == nil && msg.kind == AppSettings.CATATAN_TYPE && self.catatanIdx > -1) {
                            //index = self.catatanIdx
                            self.removeMessage(at: self.catatanIdx - 1)
                            self.removeMessage(at: self.catatanIdx - 1)
                            self.tmpmessage.remove(at: self.catatanIdx - 1)
                            self.tmpmessage.remove(at: self.catatanIdx - 1)
                            self.updateindex()
                        }
                        if (index == nil && msg.kind == AppSettings.SPA_TYPE && self.spaIdx > -1) {
                            //index = self.spaIdx
                            self.removeMessage(at: self.spaIdx - 1)
                            self.removeMessage(at: self.spaIdx - 1)
                            self.tmpmessage.remove(at: self.spaIdx - 1)
                            self.tmpmessage.remove(at: self.spaIdx - 1)
                            self.updateindex()
                        }
                        if (index == nil && msg.kind == AppSettings.RESEP_DOKTER_TYPE && self.resepIdx > -1) {
                            //index = self.resepIdx
                            self.removeMessage(at: self.resepIdx - 1)
                            self.removeMessage(at: self.resepIdx - 1)
                            self.tmpmessage.remove(at: self.resepIdx - 1)
                            self.tmpmessage.remove(at: self.resepIdx - 1)
                            self.updateindex()
                        }
                        if (msg.kind == AppSettings.SESSION_ENDED_TYPE) {
                            
                            self.consultationEnded = true
                            self.messageInputBar.isHidden = true
                            self.titleView?.endChatButton.isHidden = true

                        }
                        if (index == nil) {
                            //APPEND
                            if (msg.kind == AppSettings.TEXT_TYPE || msg.kind == AppSettings.CATATAN_TYPE || msg.kind == AppSettings.SPA_TYPE || msg.kind == AppSettings.RESEP_DOKTER_TYPE || msg.kind == AppSettings.SESSION_ENDED_TYPE || msg.kind == AppSettings.PHR_REQ || ( msg.kind == AppSettings.IMAGE_TYPE && msg.text != "Uploading")) {
                                
                                if (msg.kind == AppSettings.CATATAN_TYPE || msg.kind == AppSettings.SPA_TYPE || msg.kind == AppSettings.RESEP_DOKTER_TYPE ) {
                                    print("resep")
                                    print(msg.text)
                                    let message_system = self.buildMessageSystem(msg)
                                    self.tmpmessage.append(msg)
                                    self.messageList.append(message_system)
                                    self.messagesCollectionView.insertSections([self.messageList.count - 1])
                                    if self.messageList.count >= 2 {
                                        self.messagesCollectionView.reloadSections([self.messageList.count - 2])
                                    }
                                }
                                self.tmpmessage.append(msg)
                                let message = self.buildMessageText(msg)
                                
                                self.messageList.append(message)
                                self.messagesCollectionView.insertSections([self.messageList.count - 1])
                                if self.messageList.count >= 2 {
                                    self.messagesCollectionView.reloadSections([self.messageList.count - 2])
                                }
                                
                                if (msg.kind == AppSettings.CATATAN_TYPE ) {
                                    self.catatanIdx = self.messageList.count - 1
                                }
                                
                                if (msg.kind == AppSettings.SPA_TYPE ) {
                                    self.spaIdx = self.messageList.count - 1
                                }
                                
                                if (msg.kind == AppSettings.RESEP_DOKTER_TYPE ) {
                                    self.resepIdx = self.messageList.count - 1
                                }
                            }
                            else if (msg.kind == AppSettings.IMAGE_TYPE) {
                                //handle image
                            }
                        }
                        else {
                            //UPDATE
                            if (msg.kind == AppSettings.TEXT_TYPE || msg.kind == AppSettings.CATATAN_TYPE || msg.kind == AppSettings.SPA_TYPE || msg.kind == AppSettings.RESEP_DOKTER_TYPE || msg.kind == AppSettings.SESSION_ENDED_TYPE||msg.kind == AppSettings.PHR_REQ || ( msg.kind == AppSettings.IMAGE_TYPE && msg.text != "Uploading")) {
                                let message = self.buildMessageText(msg)
                                print("resep")
                                print(msg.text)
                                if (msg.sender_id?.objectId != self.currentUser?.objectId && msg.status != AppSettings.SEEN_STATUS) {
                                    self.updated.append(msg)
                                    //self.updateMessageStatus(message: msg)
                                }
                                
                                self.messageList[index!] = message
                                self.messagesCollectionView.reloadSections([index!])
                            }
                            else if (msg.kind == AppSettings.IMAGE_TYPE) {
                                //handle image
                            }
                        }
                    }
                    
                    //reload table
                    //self.messagesCollectionView.reloadData()
                    if (self.refreshControl.isRefreshing) {
                        self.refreshControl.endRefreshing()
                    }
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        })
    }
    
    func updateSeenStatus() {
        let params = [
            "uidF" : currentDoctor?.objectId,
            "uid" : currentUser?.objectId,
            "consultation_id" : String(currentConsultation?.consultation_id ?? 0)
        ]
        PFCloud.callFunction(inBackground: "updateToReaded", withParameters: params)
    }
    
    func updateTyping(status: String?)
    {
        let params = [
            "uidF" : currentDoctor?.objectId,
            "uid" : currentUser?.objectId,
            "status" : status
        ]
        PFCloud.callFunction(inBackground: "updateTyping", withParameters: params)
    }
    
    func updatestausphr(status : String,message_id : String,consultation_id : String){
        
        
        let params = [
            "message_id" : message_id,
            "consultation_id" : consultation_id,
            "status" : status
        ]
        PFCloud.callFunction(inBackground: "updateConsultation", withParameters: params)
    }
    
    
    func removeSnapshotListener() {
        Client.shared.unsubscribe(self.conversationQuery)
        Client.shared.unsubscribe(self.typingQuery)
        Client.shared.unsubscribe(self.consultationQuery)
    }
    
    func initializeSnapshotListener() {
        
        self.subscription = Client.shared.subscribe(self.conversationQuery)
        subscribeconversation()
        subscribeUpdateEvent()
        
        self.typingSubscription = Client.shared.subscribe(self.typingQuery)
        subscribeTypingEvent()
        
        self.consultationSubscription = Client.shared.subscribe(self.consultationQuery)
        subscribeConsultationEvent()
        
      
        
    }
    
    func ubahdatagambar (msg_id : String,Url : String){
        var tmpconversationQuery: PFQuery<PFObject>!

         tmpconversationQuery = ConversationModel.query()
        tmpconversationQuery = tmpconversationQuery.whereKey("consultation_id", equalTo: String(currentConsultation?.consultation_id ?? 0)).whereKey("messageId", equalTo: msg_id)
        tmpconversationQuery.findObjectsInBackground(block: { (results, error) in
            
            if error == nil {
                print("ubah nemu")
                print(results?.count)
                if let messages = results as? [ConversationModel] {
                        for msg in messages {
                            msg.text = Url
                            msg.saveEventually()


                    }
                }
            }
        })
        
        
    }
    
    func subscribeconversation(){
        
        self.subscription.handle(Event.created) { (query, obj) in
            let msg = obj as! ConversationModel
            print("databaru")
            self.updated = []
            do {
                try msg.user?.fetchIfNeeded()
                try msg.sender_id?.fetchIfNeeded()
                try msg.uid?.fetchIfNeeded()
                
                let index = self.messageList.firstIndex(where: {$0.messageId == msg.messageId})
                
                if (index == nil && msg.kind == AppSettings.CATATAN_TYPE && self.catatanIdx > -1) {
                    //index = self.catatanIdx
                    DispatchQueue.main.async {
                        self.removeMessage(at: self.catatanIdx - 1)
                        self.removeMessage(at: self.catatanIdx - 1)
                        self.tmpmessage.remove(at: self.catatanIdx - 1)
                        self.tmpmessage.remove(at: self.catatanIdx - 1)
                        self.updateindex()
                    }
                }
                if (index == nil && msg.kind == AppSettings.SPA_TYPE && self.spaIdx > -1) {
                    //index = self.spaIdx
                    DispatchQueue.main.async {
                        self.removeMessage(at: self.spaIdx - 1)
                        self.removeMessage(at: self.spaIdx - 1)
                        self.tmpmessage.remove(at: self.spaIdx - 1)
                        self.tmpmessage.remove(at: self.spaIdx - 1)
                        self.updateindex()
                    }
                }
                if (index == nil && msg.kind == AppSettings.RESEP_DOKTER_TYPE && self.resepIdx > -1) {
                    //index = self.resepIdx
                    DispatchQueue.main.async {
                        self.removeMessage(at: self.resepIdx - 1)
                        self.removeMessage(at: self.resepIdx - 1)
                        self.tmpmessage.remove(at: self.resepIdx - 1)
                        self.tmpmessage.remove(at: self.resepIdx - 1)
                        self.updateindex()
                    }
                }
                
                if (msg.kind == AppSettings.SESSION_ENDED_TYPE) {
                    
                    
                    DispatchQueue.main.async {
                        
                        
                        self.consultationEnded = true
                        self.messageInputBar.isHidden = true
                    }
                }
                if (index == nil) {
                    
                    
                    if (msg.kind == AppSettings.TEXT_TYPE || msg.kind == AppSettings.CATATAN_TYPE || msg.kind == AppSettings.SPA_TYPE || msg.kind == AppSettings.RESEP_DOKTER_TYPE || msg.kind == AppSettings.SESSION_ENDED_TYPE || msg.kind == AppSettings.PHR_REQ  ||  ( msg.kind == AppSettings.IMAGE_TYPE && msg.text != "Uploading") ) {
                        
                        var message_system: MockMessage?
                        
                        
                        if (msg.kind == AppSettings.CATATAN_TYPE || msg.kind == AppSettings.SPA_TYPE || msg.kind == AppSettings.RESEP_DOKTER_TYPE)
                        {
                            print("resep")
                            print(msg.text)
                            message_system = self.buildMessageSystem(msg)
                            
                        }
                        
                        
                        
                        
                        let message = self.buildMessageText(msg)
                        
                        DispatchQueue.main.async {
                            if (message_system != nil) {
                                self.messageList.append(message_system!)
                                self.tmpmessage.append(msg)
                                self.messagesCollectionView.insertSections([self.messageList.count - 1])
                                if self.messageList.count >= 2 {
                                    self.messagesCollectionView.reloadSections([self.messageList.count - 2])
                                }
                            }
                            
                            self.messageList.append(message)
                            self.tmpmessage.append(msg)
                            self.messagesCollectionView.insertSections([self.messageList.count - 1])
                            if self.messageList.count >= 2 {
                                self.messagesCollectionView.reloadSections([self.messageList.count - 2])
                            }
                            
                            if (msg.kind == AppSettings.CATATAN_TYPE ) {
                                self.catatanIdx = self.messageList.count - 1
                            }
                            
                            if (msg.kind == AppSettings.SPA_TYPE ) {
                                self.spaIdx = self.messageList.count - 1
                            }
                            
                            if (msg.kind == AppSettings.RESEP_DOKTER_TYPE ) {
                                self.resepIdx = self.messageList.count - 1
                            }
                            
                            if (msg.sender_id?.objectId != self.currentUser?.objectId) {
                                self.updateSeenStatus()
                            }
                        }
                        
                    }
                    else if (msg.kind == AppSettings.IMAGE_TYPE) {
                    }
                }
                else {
                    
                    if (msg.kind == AppSettings.TEXT_TYPE || msg.kind == AppSettings.CATATAN_TYPE || msg.kind == AppSettings.SPA_TYPE || msg.kind == AppSettings.RESEP_DOKTER_TYPE || msg.kind == AppSettings.SESSION_ENDED_TYPE || msg.kind == AppSettings.PHR_REQ || ( msg.kind == AppSettings.IMAGE_TYPE && msg.text != "Uploading") ) {
                        
                        
                        let message = self.buildMessageText(msg)
                        
                        
                        if (msg.sender_id?.objectId != self.currentUser?.objectId && msg.status != AppSettings.SEEN_STATUS) {
                            self.updated.append(msg)
                        }
                        
                        DispatchQueue.main.async {
                            self.messageList[index!] = message
                            self.messagesCollectionView.reloadSections([index!])
                        }
                        
                        
                        
                    }
                    else if (msg.kind == AppSettings.IMAGE_TYPE) {
                    }
                }
            } catch _ {
                print("There was an error")
            }
        }
    }
    
    func subscribeConsultationEvent() {
        self.consultationSubscription.handle(Event.updated) { (query, obj) in
            print("data update")
            let consultation = obj as! ConsultationModel
            print("status updated! : \(consultation.status)")
            
            if (consultation.status == AppSettings.SESSION_ENDED) {
                UserDefaults.standard.removeObject(forKey: AppSettings.KEY_CURRENT_CONSULTATION)
                UserDefaults.standard.removeObject(forKey: AppSettings.ON_CHAT)
                
                DispatchQueue.main.async {
                    self.consultationEnded = true
                    self.messageInputBar.isHidden = true
                    self.titleView?.endChatButton.isHidden = true

                }
            }
        }
    }
    
    func subscribeTypingEvent() {
        
        self.typingSubscription.handle(Event.updated) { (query, obj) in
            
            let chat = obj as! ChatModel
            do {
                try chat.user?.fetchIfNeeded()
                if (chat.user?.objectId == self.currentDoctor?.objectId) {
                    if (chat.typing != nil && chat.typing != "") {
                        DispatchQueue.main.async {
                            self.setTypingIndicatorViewHidden(false)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.setTypingIndicatorViewHidden(true)
                        }
                    }
                }
            } catch _ {
                print("There was an error")
            }
        }
    }
    
    
    
    
    func subscribeUpdateEvent() {
        
        
        self.subscription.handle(Event.updated) { (query, obj) in
            print("update data")
            let msg = obj as! ConversationModel
            self.updated = []
            do {
                try msg.user?.fetchIfNeeded()
                try msg.sender_id?.fetchIfNeeded()
                try msg.uid?.fetchIfNeeded()
                
                let index = self.messageList.firstIndex(where: {$0.messageId == msg.messageId})
                
                if (msg.kind == AppSettings.SESSION_ENDED_TYPE) {
                    
                    
                    DispatchQueue.main.async {
                        self.consultationEnded = true
                        self.messageInputBar.isHidden = true
                    }
                }
                if (index != nil) {
                    //UPDATE
                    if (msg.kind == AppSettings.TEXT_TYPE || msg.kind == AppSettings.CATATAN_TYPE || msg.kind == AppSettings.SPA_TYPE || msg.kind == AppSettings.RESEP_DOKTER_TYPE || msg.kind == AppSettings.PHR_REQ  || msg.kind == AppSettings.SESSION_ENDED_TYPE || ( msg.kind == AppSettings.IMAGE_TYPE && msg.text != "Uploading")) {
                        let message = self.buildMessageText(msg)
                        
                        if (msg.sender_id?.objectId != self.currentUser?.objectId && msg.status != AppSettings.SEEN_STATUS) {
                            self.updated.append(msg)
                            //self.updateMessageStatus(message: msg)
                        }
                        
                        DispatchQueue.main.async {
                            self.messageList[index!] = message
                            self.messagesCollectionView.reloadSections([index!])
                        }
                    }
                    else if (msg.kind == AppSettings.IMAGE_TYPE) {
                        //handle image
                    }
                }else{
                    if ( msg.kind == AppSettings.IMAGE_TYPE && msg.text != "Uploading"){
                        var message_system: MockMessage?
                        let message = self.buildMessageText(msg)
                        
                        DispatchQueue.main.async {
                            if (message_system != nil) {
                                self.messageList.append(message_system!)
                                self.tmpmessage.append(msg)
                                self.messagesCollectionView.insertSections([self.messageList.count - 1])
                                if self.messageList.count >= 2 {
                                    self.messagesCollectionView.reloadSections([self.messageList.count - 2])
                                }
                            }
                            
                            self.messageList.append(message)
                            self.tmpmessage.append(msg)
                            self.messagesCollectionView.insertSections([self.messageList.count - 1])
                            if self.messageList.count >= 2 {
                                self.messagesCollectionView.reloadSections([self.messageList.count - 2])
                            }
                      
                        }
                    }
                 
                    
                }
            } catch _ {
                print("There was an error")
            }
        }
    }
    func updateindex(){
        for (i,index) in tmpmessage.enumerated(){
            if index.kind == AppSettings.RESEP_DOKTER_TYPE{
                resepIdx = i
            }
            if index.kind == AppSettings.SPA_TYPE{
                spaIdx = i
            }
            if index.kind == AppSettings.CATATAN_TYPE{
                catatanIdx = i
                
            }
        }
    }
    
}
