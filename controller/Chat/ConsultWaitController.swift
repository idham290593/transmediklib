
import Foundation
import UIKit
//import ALLoadingView
import CDAlertView
import Parse
import ParseLiveQuery


class ConsultWaitViewController: MYUIViewController {
    var profile: ModelProfile!
    var doctor: Detaildokter!
    var chatAPICall = Chat()
    var token: String = ""
    var uuid_patient: String = ""
    var uuid_doctor: String = ""
    var email_patient: String = ""
    var email_doctor: String = ""
    var rates: Int = 0
    var currentConsultation: ConsultationPostModel?
    var counter: Int = AppSettings.WAIT_COUNTER
    var pause: Bool = false
    var _timer: Timer?
    var query: PFQuery<PFObject>!
    var subscription: Subscription<PFObject>!
    var pfuser : PFUser?
    var pfdoctor : PFUser?
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let waitImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.white
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "consult-wait", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lbl1: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        view.text = LocalizationHelper.getInstance().please_wait
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()
    
    private let lbl2: UILabel = {
        let view = UILabel()
        view.text = ""
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.numberOfLines = 2
        return view
    }()
    
    private let btnCancel: UITealButton = {
        let view = UITealButton(type: .system)
        view.setTitle(LocalizationHelper.getInstance().consultation_cancel, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        print("masuk sini ceng")
        setupViews()
        setupActions()
        setupTimer()
        setupParse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupParse() {
        
        print("currentConsultationId : \(self.currentConsultation!.consultation_id!)")
        self.query = ConsultationModel.query()
        self.query = self.query.whereKey("consultation_id", equalTo: self.currentConsultation!.consultation_id!)
        getdata()
        initializeParseListener()
    }
    
    func setupTimer() {
        _timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func setupActions() {
        btnCancel.addTarget(self, action: #selector(btnCancelDidTap(_:)), for: .touchUpInside)
    }
    
    func setupViews() {
        
        contentView.addSubview(waitImage)
        waitImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        waitImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(lbl1)
        lbl1.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        lbl1.topAnchor.constraint(equalTo: waitImage.bottomAnchor, constant: 20).isActive = true
        lbl1.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(lbl2)
        lbl2.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        lbl2.topAnchor.constraint(equalTo: lbl1.bottomAnchor, constant: 5).isActive = true
        lbl2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(btnCancel)
        btnCancel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.60).isActive = true
        btnCancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnCancel.topAnchor.constraint(equalTo: lbl2.bottomAnchor, constant: 10).isActive = true
        btnCancel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        view.addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        contentView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        view.layoutIfNeeded()
        
    }
    
    func getdata(){
        
        self.query.findObjectsInBackground(block: { (results, error) in
            if error == nil {

                if let chat = results as? [ConsultationModel] {
                    self.pfdoctor = chat[0].doctor
                    self.pfuser = chat[0].patient
                }
            }
        })
    }
    
    
    
    
    
    func initializeParseListener() {
        self.subscription = Client.shared.subscribe(self.query)
        self.subscription.handle(Event.updated) { (query, obj) in
            let consultation = obj as! ConsultationModel
            print("status updated! : \(consultation.status)")
            if (consultation.status == AppSettings.ON_CHAT) {
                print("on chat")
                Client.shared.unsubscribe(self.query)
                
                DispatchQueue.main.async {
                    let vc = DetailChatViewController()
                    UserDefaults.standard.set(true, forKey: AppSettings.ON_CHAT)

                    vc.uuid_patient = (self.currentConsultation?.patient?.uuid)! 
                    vc.uuid_doctor = (self.currentConsultation?.doctor?.uuid)!
                    vc.email_patient = (self.currentConsultation?.patient?.email)!
                    vc.email_doctor = (self.currentConsultation?.doctor?.email)!
                    vc.currentConsultation = self.currentConsultation
                    vc.currentDoctor =  self.pfdoctor
                    vc.currentUser = self.pfuser
                    
                    
                    let nav = UINavigationController(navigationBarClass: UICustomNavigationBar.self, toolbarClass: nil)
                    nav.modalPresentationStyle = .fullScreen
                    let parent = self.presentingViewController!
                    nav.pushViewController(vc, animated: false)
                    self.dismiss(animated: false, completion: nil)
                    parent.present(nav, animated: true, completion: nil)
                    
//                    weak var pvc = self.presentingViewController
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

//                    self.dismiss(animated: false) {
//                            nav.pushViewController(vc, animated: false)
//                            pvc?.present(nav, animated: true, completion: nil)
//
//                    }
//                    }
                    
                }
            }
            else if (consultation.status == AppSettings.FINISHED || consultation.status == AppSettings.REJECTED_BY_DOCTOR) {
                
                Client.shared.unsubscribe(self.query)
                
                DispatchQueue.main.async {
                    Toast.show(message: LocalizationHelper.getInstance().consultation_no_response, controller: self.presentingViewController ?? self)
                    self._timer?.invalidate()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            if (!pause) {
                if counter < 10 {
                    lbl2.text = "\(LocalizationHelper.getInstance().consultation_wait) 00:0\(counter) \(LocalizationHelper.getInstance().second)"
                }
                else {
                    lbl2.text = "\(LocalizationHelper.getInstance().consultation_wait) 00:\(counter) \(LocalizationHelper.getInstance().second)"
                }
                counter -= 1
            }
        }
        else {
            if (!pause) {
                Client.shared.unsubscribe(self.query)
                
                Toast.show(message: LocalizationHelper.getInstance().consultation_no_response, controller: self.presentingViewController ?? self)
                _timer?.invalidate()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc
    func btnCancelDidTap(_ sender:UIButton!)
    {
        pause = true

        let alert = CDAlertView(title: LocalizationHelper.getInstance().consultation_cancel, message: LocalizationHelper.getInstance().consultation_cancel_confirmation, type: .warning)

        let yesAction = CDAlertViewAction(title: LocalizationHelper.getInstance().yes) { (CDAlertViewAction) -> Bool in
            
//            if ALLoadingView.manager.isPresented {
//                ALLoadingView.manager.hideLoadingView()
//            }
//
//            ALLoadingView.manager.blurredBackground = true
//            ALLoadingView.manager.showLoadingView(ofType: .basic)
            
                if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                    
                    self.token = token
                    
                    self.chatAPICall.statusConsult(
                        token: token,
                        status: AppSettings.CANCEL_BY_PATIENT,
                        consultation_id: self.currentConsultation!.consultation_id!
                    ) { (result) in
                        
//                        ALLoadingView.manager.hideLoadingView()
                        
                        if result!  {
                            
                            Client.shared.unsubscribe(self.query)
                            
                            Toast.show(message: LocalizationHelper.getInstance().consultation_cancelled, controller: self.presentingViewController ?? self)
                            self._timer?.invalidate()
                            self.dismiss(animated: true, completion: nil)
                        }
                        else {
                            Toast.show(message: LocalizationHelper.getInstance().consultation_cancelled_failed, controller: self)
                        }
                    }
                }
            
            self.pause = false
            return true
        }
        let noAction = CDAlertViewAction(title: LocalizationHelper.getInstance().no) { (CDAlertViewAction) -> Bool in
            self.pause = false
            return true
        }
        
        alert.add(action: noAction)
        alert.add(action: yesAction)
        alert.show()
    }
}
