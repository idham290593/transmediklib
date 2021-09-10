//
//  DetailChatViewController.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import MessageKit
import InputBarAccessoryView
import Parse
import ParseLiveQuery
import SwiftyJSON
import CDAlertView
//import ALLoadingView
import AVFoundation

class DetailChatViewController: MessagesViewController, MessagesDataSource {
    /// The `BasicAudioController` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.ontroller {
    
    var uuid_patient: String = ""
    var uuid_doctor: String = ""
    var email_patient: String = ""
    var email_doctor: String = ""
    var currentConsultation: ConsultationPostModel?
   
    let outgoingAvatarOverlap: CGFloat = 0
 
    var messageList: [MockMessage] = []
    
    let refreshControl = UIRefreshControl()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    var layout : MessagesCollectionViewFlowLayout?
    var currentUser : PFUser?
    var currentDoctor: PFUser?
    var  age = Count()
    var attributes : [NSAttributedString.Key: Any] = [:]
    
    var defaultFontSize = 15
    var idConversation: String = ""
    
    var isTyping: Bool = false
    
    var mediaType: String = "image"
    var videoUrl: URL?
    var videoThumbnail: UIImage?
    var selectedIndexPath: IndexPath?
    var apichat = Chat()
    var conversationQuery: PFQuery<PFObject>!
    var typingQuery: PFQuery<PFObject>!
    var consultationQuery: PFQuery<PFObject>!
    var subscription: Subscription<PFObject>!
    var typingSubscription: Subscription<PFObject>!
    var consultationSubscription: Subscription<PFObject>!
    var titleView: ChatTitleView?
    var updated: [ConversationModel] = []
    var tmpmessage : [ConversationModel] = []

    var catatanIdx = -1
    var resepIdx = -1
    var spaIdx = -1
    var phrIdx = -1
    
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    var resepDokterDelegate: ResepDokterViewControllerDelegate?
    var resepViewController: ResepDokterViewController?
    var consultationEnded: Bool = false {
        didSet{
            guard consultationEnded != oldValue else {
                return
            }
//            resepViewController?.consultationEnded = consultationEnded
        }
    }
    
    open lazy var attachmentManager: AttachmentManager = { [unowned self] in
        let manager = AttachmentManager()
        manager.delegate = self
        return manager
    }()
    
    
    var tb = ""
    var bb = ""
    var datetext = ""
    var namaclinic = ""
    var umur = ""
    var nomorrm = ""
    
    
    
    var timertx = Timer()
    var timereconnect = 10
    var isconnection = true{
        didSet{
            if isconnection{
                print("mantap")
//                appDelegate.setupParse()
//                initializeMessages()
            }else{
                let vc = UIStoryboard(name: "Chat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "notifViewController") as? notifViewController
                self.present(vc!, animated: false, completion: nil)
            }
           
            
          
        }
    }
    var timechecking = 5
    

    
    override func viewDidLoad() {
        
        
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: CustomMessagesFlowLayout())
        messagesCollectionView.register(CustomCell.self)
        messagesCollectionView.register(OneMediaOnlyMessageCell.self)
        messagesCollectionView.register(TwoMediaOnlyMessageCell.self)
        messagesCollectionView.register(ThreeMediaOnlyMessageCell.self)
        messagesCollectionView.register(FourMediaOnlyMessageCell.self)
        messagesCollectionView.register(TextWithOneMediaMessageCell.self)
        messagesCollectionView.register(TextWithTwoMediaMessageCell.self)
        messagesCollectionView.register(TextWithThreeMediaMessageCell.self)
        messagesCollectionView.register(TextWithFourMediaMessageCell.self)
        messagesCollectionView.register(UrlMessageCell.self)
        messagesCollectionView.register(CatatanMessageCell.self)
        messagesCollectionView.register(ResepDokterMessageCell.self)
        messagesCollectionView.register(PHRMessageCell.self)
        messagesCollectionView.register(Imageloadmessagecell.self)


        super.viewDidLoad()
        
        resepDokterDelegate = self
        
        self.view.backgroundColor = AppColor.shared.instance(traitCollection).backgroundColor
 
        
        
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView))
        
        doubleTapGesture.numberOfTapsRequired = 2  // add double tap
        self.messagesCollectionView.addGestureRecognizer(doubleTapGesture)
        
        
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressCollectionView))
        self.messagesCollectionView.addGestureRecognizer(longPressGesture)
        
     
        
        self.conversationQuery = ConversationModel.query()
       

        if currentUser != nil {
            print("data not null")

        }else{
            print("data null")
        }
        //error disini
        self.conversationQuery = self.conversationQuery.whereKey("uid", equalTo: currentUser!).whereKey("user", equalTo: currentDoctor!)
         //error disini\\\
            .whereKey("consultation_id", equalTo: String(currentConsultation?.consultation_id ?? 0))
        //.order(byAscending: "date")
        
        
        self.typingQuery = ChatModel.query()
        self.typingQuery = self.typingQuery.whereKey("uid", equalTo: currentUser!)
        self.consultationQuery = ConsultationModel.query()
        self.consultationQuery = self.consultationQuery.whereKey("consultation_id", equalTo: currentConsultation!.consultation_id!)
        
      
        
        
        
        
        
        
        
        attributes = [
            .font: UIFont.systemFont(ofSize: CGFloat(defaultFontSize)),
            .foregroundColor: UIColor.black
        ]
        
        setupNavigationBar()
        configureMessageCollectionView()
        configureMessageInputBar()
        setupObservers()
        updateColors()
        loadFirstMessages()
//        layouttools()
        onchat()
        timertx.invalidate()
        timertx = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
       
    }
    
    @objc func timerAction() {
        timechecking -= 1
        if timechecking == 0{
            if  CheckInternet.Connection() != isconnection {
                
                isconnection = CheckInternet.Connection()
                if isconnection{
                    dismiss(animated: false, completion: nil)
                }
            }
            timechecking = 5
            timertx.invalidate()
            self.timertx = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
        }
    
    
    func setupNavigationBar() {
        navigationController?.navigationBar.sizeToFit()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy"
        let today = dateFormatter.string(from: Date())
        
        let bounds = navigationController!.navigationBar.bounds
        titleView = ChatTitleView(frame: CGRect.init(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: AppSettings.NAVIGATIONBAR_HEIGHT))
        
        titleView?.backButton.addTarget(self, action: #selector(btnBackDidTap), for: .touchUpInside)
        
        titleView?.endChatButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(detail)))
        titleView?.endChatButton.isUserInteractionEnabled = true
        titleView?.videoCallButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoCallDidtap)))
        
        titleView?.profileName.text = currentConsultation?.doctor?.full_name
        
        if (currentConsultation?.doctor?.profile_picture != nil) {
            titleView?.profileImageView.kf.setImage(with: URL(string: (currentConsultation?.doctor?.profile_picture)!))
        }
        else {
            titleView?.profileImageView.image = UIImage(named: "doctor-default", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
        }
        
        let titleBarItem = UIBarButtonItem(customView: titleView!)
        
        
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsWhenVerticallyCompact = true
        navigationItem.leftBarButtonItem = titleBarItem
    }
    
    
    @objc
    func detail (){
        let vc =  UIStoryboard(name: "Chat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "extensionchatdetailViewController") as? extensionchatdetailViewController
//        vc?.consultationEnded = self.consultationEnded
        vc?.currentConsultation = self.currentConsultation
        vc?.delegate = self
        vc?.date = datetext
        vc?.rm = self.nomorrm
        vc?.bb = self.bb
        vc?.age = self.umur
        vc?.tb = self.tb
        
        vc?.faskes = self.namaclinic
        present(vc!, animated: true, completion: nil)
    }
    
 

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            messagesCollectionView.contentInset = UIEdgeInsets( top: y, left: 0, bottom: 60, right: 0)
        }
    }
    
    @objc func didLongPressCollectionView(gesture: UILongPressGestureRecognizer) {
        let pointInCollectionView = gesture.location(in: self.messagesCollectionView)
        
        if let indexPath = self.messagesCollectionView.indexPathForItem(at: pointInCollectionView)  {
            if let message = self.messageForItem(at: indexPath, in: messagesCollectionView) as? MockMessage {
                self.selectedIndexPath = indexPath
                
                print("didLongPressCollectionView")
            }
        }
    }
 
    
    @objc func singleDoubleTapCollectionView(gesture: UITapGestureRecognizer) {
        if gesture.state != .ended {
            return
        }
        let pointInCollectionView = gesture.location(in: self.messagesCollectionView)
        
        if let indexPath = self.messagesCollectionView.indexPathForItem(at: pointInCollectionView)  {
            if let message = self.messageForItem(at: indexPath, in: messagesCollectionView) as? MockMessage {
                
                print("didDoubleTapCollectionView")
                //self.willReplyMessage(at: indexPath)
            }
        }
    }
    
    
    @objc func didDoubleTapCollectionView(gesture: UITapGestureRecognizer) {
        if gesture.state != .ended {
            return
        }
        let pointInCollectionView = gesture.location(in: self.messagesCollectionView)
        
        if let indexPath = self.messagesCollectionView.indexPathForItem(at: pointInCollectionView)  {
            if let message = self.messageForItem(at: indexPath, in: messagesCollectionView) as? MockMessage {
                
                print("didDoubleTapCollectionView")
                //self.willReplyMessage(at: indexPath)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("detail did appear")
        registerNotificationsObservers()
        self.additionalSafeAreaInsets.top = AppSettings.NAVIGATIONBAR_HEIGHT - 44
        
       
    }
    
    
//    func layouttools(){
//        shareinfopatient = ExChat()
//        self.view.addSubview(shareinfopatient)
//        self.view.layoutIfNeeded()
//        shareinfopatient.widthAnchor.constraint(equalToConstant: self.view.frame.width
//        ).isActive = true
//        
////        navigationController
////                (navigationController?.navigationBar.topAnchor)!
//        shareinfopatient.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        shareinfopatient.topAnchor.constraint(equalTo: messagesCollectionView.topAnchor, constant: 0).isActive = true
//        
////        shareinfopatient.topAnchor.constraint(equalTo:  navigationController != nil ? navigationController!.navigationBar.topAnchor : messagesCollectionView.topAnchor , constant: 0).isActive = true
//        
//        
//
//        shareinfopatient.translatesAutoresizingMaskIntoConstraints = false
//
//        shareinfopatient.layer.masksToBounds = false
//        shareinfopatient.layer.shadowOffset = CGSize(width: 0, height: 3)
//        shareinfopatient.layer.shadowRadius = 2
//        shareinfopatient.layer.shadowOpacity = 0.5
//        
//        
//        
////        shareinfopatient.date.text = String(self.date.dropFirst(4))
////        shareinfopatient.nomorrm.text = self.rm
////        shareinfopatient.bb.text = self.bb
////        shareinfopatient.umur.text = self.age
////        shareinfopatient.tb.text = self.tb
////
////        shareinfopatient.nameclinic.text = self.faskes
//        shareinfopatient.liatjawaban.isUserInteractionEnabled = true
//        shareinfopatient.liatjawaban.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getjawaban)))
//        onchat()
//        
//    
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeSnapshotListener()
    }
    
    @objc func getjawaban(){
        let vc =  UIStoryboard(name: "Form", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "FormjawabViewController") as? FormjawabViewController
        vc?.id = String(currentConsultation?.consultation_id ?? 0)
        present(vc!, animated: true, completion: nil)

    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeSnapshotListener()
        unregisterAllNotificationsObservers()
        
        print("unsubscribe")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioController.stopAnyOngoingPlaying()
    }
    
    func loadFirstMessages() {
        DispatchQueue.main.async {
            self.initializeMessages()
            self.updateSeenStatus()
            print("loadFirstMessage")
        }
    }
    
    @objc
    func loadMoreMessages() {
        DispatchQueue.main.async {
            self.reloadMoreMessages()
        }
    }
    
    @objc
    func btnBackDidTap()
    {
        if (!self.consultationEnded) {
            let alert = CDAlertView(title: LocalizationHelper.getInstance().keluar_conversations, message: LocalizationHelper.getInstance().akhiri_conversations, type: .warning)
            
            let yesAction = CDAlertViewAction(title: LocalizationHelper.getInstance().yes) { (CDAlertViewAction) -> Bool in
                
                if (!self.consultationEnded) {
                   
                    if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                            self.sendTextMessage([AppSettings.SESSION_ENDED_MESSAGE], AppSettings.SESSION_ENDED_TYPE)
                            let chatAPICall = Chat()
                            chatAPICall.statusConsult(
                                token: token,
                                status: AppSettings.SESSION_ENDED,
                                consultation_id: self.currentConsultation!.consultation_id!
                            ) { (result) in
                                //ALLoadingView.manager.hideLoadingView()
                                self.consultationEnded = true
                                self.messageInputBar.isHidden = true
                                self.navigationController?.dismiss(animated: true, completion: nil)
                            }
                        
                    }
                }
                
                return true
            }
            let noAction = CDAlertViewAction(title: LocalizationHelper.getInstance().no) { (CDAlertViewAction) -> Bool in
                return true
            }
            
            alert.add(action: noAction)
            alert.add(action: yesAction)
            alert.show()
        }else{
            self.navigationController?.dismiss(animated: true, completion: nil)

        }
    }
    
    @objc
    func videoCallDidtap()
    {
        if (AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized &&
                AVCaptureDevice.authorizationStatus(for: .audio) == AVAuthorizationStatus.authorized) {
            startVideoCall()
        }
        else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    AVCaptureDevice.requestAccess(for: AVMediaType.audio) { response in
                        if response {
                            self.startVideoCall()
                        } else {

                        }
                    }
                } else {

                }
            }
        }
    }
    
    func startVideoCall() {
//        DispatchQueue.main.async {
//            let vc = VideoCallViewController()
//            vc.modalPresentationStyle = .overFullScreen
//            vc.currentUser = self.currentUser
//            vc.currentDoctor = self.currentDoctor
//            vc.currentConsultation = self.currentConsultation
//            
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    @objc
    func endChatDidTap()
    {
        if (!self.consultationEnded) {
            let alert = CDAlertView(title: LocalizationHelper.getInstance().keluar_conversations, message: LocalizationHelper.getInstance().akhiri_conversations, type: .warning)
            
            let yesAction = CDAlertViewAction(title: LocalizationHelper.getInstance().yes) { (CDAlertViewAction) -> Bool in
                
                if (!self.consultationEnded) {
//                    if ALLoadingView.manager.isPresented {
//                        ALLoadingView.manager.hideLoadingView()
//                    }
                    
                    //ALLoadingView.manager.blurredBackground = true
                    //ALLoadingView.manager.showLoadingView(ofType: .basic)
                    if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                        self.sendTextMessage([AppSettings.SESSION_ENDED_MESSAGE], AppSettings.SESSION_ENDED_TYPE)
                        let chatAPICall = Chat()
                        chatAPICall.statusConsult(
                            token: token,
                            status: AppSettings.SESSION_ENDED,
                            consultation_id: self.currentConsultation!.consultation_id!
                        ) { (result) in
                            //ALLoadingView.manager.hideLoadingView()
                            self.consultationEnded = true
                            self.messageInputBar.isHidden = true
                        }

                    }
                    
                   
                }
                return true
            }
            let noAction = CDAlertViewAction(title: LocalizationHelper.getInstance().no) { (CDAlertViewAction) -> Bool in
                return true
            }
            
            alert.add(action: noAction)
            alert.add(action: yesAction)
            alert.show()
        }
    }
    
    func updateColors() {
        attributes = [
            .font: UIFont.systemFont(ofSize: CGFloat(defaultFontSize)),
            .foregroundColor: AppColor.shared.instance(traitCollection).chatTextColor
        ]
        
        self.messagesCollectionView.reloadData()
        messageInputBar.backgroundColor = AppColor.shared.instance(traitCollection).backgroundColor
        layout?.collectionView?.backgroundColor = AppColor.shared.instance(traitCollection).backgroundColor
        
        messageInputBar.inputTextView.tintColor = AppColor.shared.instance(traitCollection).textFieldTintColor
        messageInputBar.inputTextView.layer.borderColor = AppColor.shared.instance(traitCollection).messageBarBackgroundColor.cgColor
        messageInputBar.inputTextView.placeholderTextColor = AppColor.shared.instance(traitCollection).placeholderTextColor
        messageInputBar.inputTextView.backgroundColor = AppColor.shared.instance(traitCollection).textFieldBackgroundColor
        messageInputBar.backgroundView.backgroundColor = AppColor.shared.instance(traitCollection).messageBarBackgroundColor
        messageInputBar.sendButton.imageView?.backgroundColor = AppColor.shared.instance(traitCollection).messageBarBackgroundColor
        messageInputBar.sendButton.tintColor = AppColor.shared.instance(traitCollection).buttonTextColor
        messageInputBar.sendButton
            .onEnabled { item in
                item.tintColor = AppColor.shared.instance(self.traitCollection).buttonTextColor
            }.onDisabled { item in
                item.tintColor = AppColor.shared.instance(self.traitCollection).buttonTextColor
            }.onSelected { item in
                item.tintColor = AppColor.shared.instance(self.traitCollection).buttonTextColor
            }.onDeselected { item in
                item.tintColor = AppColor.shared.instance(self.traitCollection).buttonTextColor
            }
        messageInputBar.topStackView.backgroundColor = AppColor.shared.instance(traitCollection).messageBarBackgroundColor
        
        attachmentManager.attachmentView.backgroundColor = AppColor.shared.instance(traitCollection).messageBarBackgroundColor
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        //if isTimeLabelVisible(at: indexPath) {
        return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: AppColor.shared.instance(traitCollection).chatSystemTextColor])
        //}
        //return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        /*let name = message.sender.displayName
         return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])*/
        /*if !isPreviousMessageSameSender(at: indexPath) {
         let name = message.sender.displayName
         return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
         }*/
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        /*let dateString = formatter.string(from: message.sentDate)
         return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])*/
        
        /*if !isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message) {
         return NSAttributedString(string: "Delivered", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
         }*/
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        //return false
        return super.canPerformAction(action, withSender: sender)
    }
    
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.detailChatCollectionView(collectionView, cellForItemAt: indexPath)
    }
    
    deinit {
        
     
     //swift 4.2
//        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
}



extension DetailChatViewController {
    private func setupObservers() {
        //swift 4.2
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(inputTextViewDidChange),
//                                               name: UITextView.textDidChangeNotification, object: messageInputBar.inputTextView)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(inputTextViewDidBeginEditing),
//                                               name: UITextView.textDidBeginEditingNotification, object: messageInputBar.inputTextView)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(inputTextViewDidEndEditing),
//                                               name: UITextView.textDidEndEditingNotification, object: messageInputBar.inputTextView)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(inputTextViewDidChange),
                                               name: Notification.Name.UITextViewTextDidChange, object: messageInputBar.inputTextView)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(inputTextViewDidBeginEditing),
                                               name: Notification.Name.UITextViewTextDidBeginEditing, object: messageInputBar.inputTextView)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(inputTextViewDidEndEditing),
                                               name:Notification.Name.UITextViewTextDidEndEditing, object: messageInputBar.inputTextView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(note:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(note:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShown(note: Notification) {
        let userInfo = note.userInfo
        //swift 4.2
//        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboardScreenEndFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect

        
        /*let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
         scrollView.contentInset = contentInset
         scrollView.scrollIndicatorInsets = contentInset
         scrollView.scrollRectToVisible(textField.frame, animated: true)*/
    }
    
    @objc func keyboardWillHide(note: Notification) {
        /*let contentInset = UIEdgeInsets.zero
         scrollView.contentInset = contentInset
         scrollView.scrollIndicatorInsets = contentInset*/
    }
    
    @objc func inputTextViewDidBeginEditing()  {
        //messageInputBar.leftStackView.isHidden = false
        //messageInputBar.middleContentViewPadding.left = 7
        
        if messageInputBar.leftStackView.isHidden {
            self.messageInputBar.middleContentViewPadding.left += 37
            UIView.animate(withDuration: 0.3, animations: {
                self.messageInputBar.leftStackView.isHidden = false
                self.messageInputBar.leftStackView.alpha = 1
                self.messageInputBar.layoutIfNeeded()
            }, completion: nil)
            print("did begin editing")
        }
    }
    
    @objc func inputTextViewDidEndEditing()  {
        //messageInputBar.leftStackView.isHidden = true
        //messageInputBar.middleContentViewPadding.left = -25
        
        if !messageInputBar.leftStackView.isHidden {
            self.messageInputBar.middleContentViewPadding.left -= 37
            UIView.animate(withDuration: 0.3, animations: {
                self.messageInputBar.leftStackView.isHidden = true
                self.messageInputBar.leftStackView.alpha = 0
                self.messageInputBar.layoutIfNeeded()
            }, completion: nil)
            print("did end editing")
            
            self.updateTyping(status: nil)
        }
    }
    
    @objc func inputTextViewDidChange() {
        self.updateTyping(status: LocalizationHelper.getInstance()?.typing)
    }
}


//Notifications Observers
extension DetailChatViewController {
    
    
    func registerNotificationsObservers() {
        
     
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
        
        //swift 4.2
//        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func unregisterAllNotificationsObservers() {
        
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
        
        //swift 4.2
//        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
//
//        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func willEnterForeground() {
        print("detail enter foreground")
        //checkcall
        let userInfo:[String: String] =
            ["sceneEnterForeground": "1"]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: AppSettings.didReceiveCallInBackground),
            object: nil,
            userInfo: userInfo
        )
        //checkcall
    }
    
    @objc func willResignActive() {
        print("detail willresignactive")
        
        isTyping = false
    }
    
    @objc func orientationDidChange() {
        //setupNavigationBar()
        //messagesCollectionView.reloadData()
        messagesCollectionView.reloadItems(at: messagesCollectionView.indexPathsForVisibleItems)
    }
    
    
    func onchat(){
        
        
    
        self.consultationQuery.findObjectsInBackground(block: { (results, error) in
            if let err = error{
                print(err)
            }
            if error == nil {
               
                if let note = results as? [ConsultationModel] {
                 
                    
                    let datapatient = note[0].detail_patient ?? ""
                    let user = datapatient.toJSON() as? [String:AnyObject]
                    let jsons = JSON(user)
                    let decoder = JSONDecoder()
                    
                    do {
                        let result = try decoder.decode(ConsultationUserModel.self, from: jsons.rawData())
                        
                       
                        let vc = DetailChatViewController()
                        if jsons["ref"]["medical_record_number"].stringValue == ""{
//                            self.shareinfopatient.nomorrm.text = "-"
                            self.nomorrm = "-"
                        }else{
                            self.nomorrm = jsons["ref"]["medical_record_number"].stringValue
//                            self.shareinfopatient.nomorrm.text = jsons["ref"]["medical_record_number"].stringValue
                        }
                      
                        self.tb = jsons["ref"]["body_height"].stringValue
                        self.bb = jsons["ref"]["body_weight"].stringValue
                        
//                        self.shareinfopatient.tb.text = jsons["ref"]["body_height"].stringValue
//                        self.shareinfopatient.bb.text = jsons["ref"]["body_weight"].stringValue
                        let not = "\(note[0].createdAt!)"
//                        self.shareinfopatient.date.text = String(not[0...10])
                        print("not")
                        print(not)
                        print(String(not[0...10]))
                        self.datetext = String(not[0...10])
                        let tgllahir = jsons["ref"]["dob"].stringValue
                        let dataclinic = note[0].medical_facility ?? ""
                        let clinic = dataclinic.toJSON() as? [String:AnyObject]
                        let jsonsclinic = JSON(clinic)
                        print("lahir nya " + tgllahir)
                        
                        self.namaclinic = jsonsclinic["name"].stringValue
//                        self.shareinfopatient.nameclinic.text = jsonsclinic["name"].stringValue
                        let date = Date()
//                        self.shareinfopatient.umur.text =  "\(self.age.calculateAge(dob: tgllahir, format: "yyyy-MM-dd").year) Tahun"
                        self.umur = "\(self.age.calculateAge(dob: tgllahir, format: "yyyy-MM-dd").year) Tahun"
                        
                     
                    } catch let error {
                        print(error)
                    }
                    
                    
                  
                   
                  
                }
            }
        })
       
    }
}


extension DetailChatViewController: ResepDokterViewControllerDelegate,extensionchatdetailViewControllerdelegate {
    func endchat() {
        
        if (!self.consultationEnded) {
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                self.sendTextMessage([AppSettings.SESSION_ENDED_MESSAGE], AppSettings.SESSION_ENDED_TYPE)
                let chatAPICall = Chat()
                chatAPICall.statusConsult(
                    token: token,
                    status: AppSettings.SESSION_ENDED,
                    consultation_id: self.currentConsultation!.consultation_id!
                ) { (result) in
                    //ALLoadingView.manager.hideLoadingView()
                    self.consultationEnded = true
                    self.messageInputBar.isHidden = true
                }
            }
           
            
        }
    }
    
    func resepDokterClosed() {
        print("delegate called")
        self.resepViewController = nil
    }
    
    
    
}
