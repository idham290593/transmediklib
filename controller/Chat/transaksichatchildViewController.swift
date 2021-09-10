//
//  transaksichatchildViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//


import UIKit
import DropDown
import Kingfisher
import Alamofire


protocol transaksichatchildViewControllerdelegate {
    func scrolldown()
    func scrollup()
    func transaksi(data:ModelProfile , note:String)
    func edit(data:ModelProfile, row : Int)
    func form()
    func loading(load : Bool)
    //    func load()
}

class transaksichatchildViewController: UIViewController,UIScrollViewDelegate, OpenpdfViewControllerdelegate {
    
    
    @IBOutlet weak var loadview: UIView!
    
    
    //view
    @IBOutlet weak var viewprofile: UIView!
    @IBOutlet weak var viewnote: UIView!
    @IBOutlet weak var viewpembayaran: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    var api = Voucherobject()
    
    //material
    var views:CGFloat?
    @IBOutlet weak var umur: UILabel!
    @IBOutlet weak var namedokter: UILabel!
    @IBOutlet weak var spesialis: UILabel!
    @IBOutlet weak var selectname: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var bb: UILabel!
    @IBOutlet weak var tb: UILabel!
    @IBOutlet weak var edut: UIView!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var kodepromo: UITextField!
    @IBOutlet weak var biaya: UILabel!
    @IBOutlet weak var totaldiskon: UILabel!
    @IBOutlet weak var totalpembayaran: UILabel!
    @IBOutlet weak var send: UIView!
    @IBOutlet weak var viewkodepromo: UIView!
    @IBOutlet weak var tinggitexts: NSLayoutConstraint!
    var payment = paymentobject()
    var consultationPostModel: ConsultationPostModel?
    var ontop = true
    var isform = false
    var statussend = true{
        didSet{
            if statussend{
                send.backgroundColor = Colors.bluecolor
            }else{
                send.backgroundColor  = UIColor.init(rgb: 0x959393)
            }
        }
    }
    @IBOutlet weak var viewform: UIView!
    @IBOutlet weak var radioform: UIImageView!
    @IBOutlet weak var ketpromo: UILabel!
    @IBOutlet weak var tinggiviewindexpromo: NSLayoutConstraint!
    
    @IBOutlet weak var viewMasterForm: UIView!
    let chooseDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseDropDown,
            
        ]
    }()
    
    @IBOutlet weak var viewindexpromo: UIView!
    
    var mymoney : Mbalance?{
        didSet{
            if mymoney != nil {
                self.saldo.text = setmoney(harga: mymoney?.accountbalance ?? 0)
                    
                    if gettotal() == 0 {
                        viewmasterpembayaranvirtual.isHidden = true
                        opennotesaldo(open: false)
                        viewindexpromo.isHidden = true
                        tinggiviewindexpromo.constant = 0
                        
                        self.view.layoutIfNeeded()
                        return
                        
                    }
                
                
                    if mymoney?.accountbalance ?? 0 >= gettotal(){
                        opennotesaldo(open: false)
                        
                    }else{
                        opennotesaldo(open: true)
                    }
            }
        }
    }
    var contex : UIViewController?
    @IBOutlet weak var ketdiskons: UILabel!
    var selected = 0{
        didSet{
            if mdata[selected].image != "" {
                let url = URL(string:  mdata[selected].image)
                photo.kf.setImage(with: url)
            }
            bb.text = mdata[selected].weight
            tb.text = mdata[selected].height
            umur.text = "\(age.calculateAge(dob: mdata[selected].dob, format: "yyyy-MM-dd").year) Tahun"
            
        }
    }
    var currentConsultationId: Int = 0
    var age = Count()
    var mdata :[ModelProfile] = []{
        didSet{
            for tmpuser in mdata{
                listname.append(tmpuser.full_name)
                if listname.count == listname.count{
                    setupDropDowns()
                }
            }
            
        }
    }
    var listname : [String] = []
    var detaildokter:Detaildokter?{
        didSet{
            if detaildokter != nil {
                namedokter.text = detaildokter!.full_name
                spesialis.text = detaildokter!.specialist
                biaya.text = setmoney(harga: Int(detaildokter!.rates)!)
            }
            
            
        }
    }
    private var lastContentOffset: CGFloat = 0
    var delegate : transaksichatchildViewControllerdelegate!
    
    //pembayran
    
    @IBOutlet weak var checkmoneyvirtual: UIImageView!
    @IBOutlet weak var saldo: UILabel!
    
    
    @IBOutlet weak var viewchecked: UIView!
    @IBOutlet weak var backgroundvirtual: UIView!
    
    //pebayaran
    @IBOutlet weak var namapembayaran: UILabel!
    
    @IBOutlet weak var tinggipembayaran: NSLayoutConstraint!
    @IBOutlet weak var viewpembayaranvirtual: UIView!
    @IBOutlet weak var viewmasterpembayaranvirtual: UIView!
    @IBOutlet weak var checkpembayaranvirtual: UIImageView!
    
    @IBOutlet weak var noteisisaldo: UIView!
    @IBOutlet weak var tingginoteisisaldo: NSLayoutConstraint!
    
    
    
    
    var Mvoucher : ModelVoucer?{
        didSet{
            if Mvoucher != nil {
                let _symbol = Mvoucher!.type == "2" ? "%" : ""
                ketdiskons.text = "Potongan " + String(Mvoucher!.nominal) + _symbol
                  
                ketpromo.text = "kode promo berhasil dipakai, Anda menghemat " + setmoney(harga: getdiskon().0)
            }else{
                ketdiskons.text = "Potongan "
                ketpromo.text = ""
            }
            self.totaldiskon.text = setmoney(harga: getdiskon().0)
            totalpembayaran.text = setmoney(harga: gettotal())
            
            self.view.layoutIfNeeded()
        }
    }
    var totalpembayaranstring = ""
    var chatacc = Chat()
    var facilityid : String?
    var list : [listformmodel] = []
    var merchant_id :String?
    var getmoney = balanceobject()
    var nextstep = false
    var saldoint : Int?
    var pembayaran : detailpayment?{
        didSet{
            if pembayaran != nil{
                viewpembayaranvirtual.isHidden = false
                tinggipembayaran.constant = CGFloat(50)
                namapembayaran.text = pembayaran!.payment_name
                self.view.layoutIfNeeded()
            }
        }
    }
    var namepayment = ""
    var paymentid = ""
    var bayarvitrual = true{
        didSet{
            if bayarvitrual{
                checkmoneyvirtual.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                checkpembayaranvirtual.image = UIImage(named: "uncheck basic", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                
            }else{
                checkmoneyvirtual.image = UIImage(named: "uncheck basic", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                checkpembayaranvirtual.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                
            }
            
            if pembayaran != nil {
                if !bayarvitrual{
                    opennotesaldo(open: false)
                }else{
                    if mymoney?.accountbalance ?? 0 >= gettotal(){
                        opennotesaldo(open: false)
                        
                    }else{
                        opennotesaldo(open: true)
                    }
                    
                }
            }else{
                opennotesaldo(open: false)
            }
            
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.delegate = self
        note.delegate = self
        note.text = "Apa yang anda rasakan"
        layout()
        ketdiskons.text = "Potongan "
        print("isform2 = > \(isform)" )
        if !isform{
            viewnote.isHidden.toggle()
            self.view.layoutIfNeeded()
            send.backgroundColor = Colors.bluecolor
        }
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectsending()
    }
    
    func gettotal()->Int{
        var _tmp = 0
        
        if detaildokter != nil {
            _tmp += Int(detaildokter!.rates)!
            
        }
        if Mvoucher != nil {
            _tmp -= getdiskon().0
        }
        
        return _tmp
    }
    
    func getdiskon()->(Int,String){
        var _tmp = 0
        if Mvoucher != nil {
            _tmp = Mvoucher!.nominal
            if Mvoucher?.type == "2"{
                _tmp = (Mvoucher!.nominal * Int(self.detaildokter!.rates)!) / 100
            }
            
            return (_tmp,Mvoucher!.code)
        }
        return (_tmp,"")
    }
    
    func selectsending(){
        if list.count > 0{
            for index in list{
                if index.required && index.jawaban == ""{
                    
                    statussend = false
                    radioform.image = UIImage(named: "Radio Button", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                    
                    return
                }
                
            }
            statussend = true
            radioform.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
            
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if note.text! == "Apa yang anda rasakan?"{
            note.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if note.text ?? "" == "" {
            note.text =  "Apa yang anda rasakan?"
        }
        return true
    }
    
    @IBAction func change(_ sender: Any) {
        let vc = UIStoryboard(name: "Categoryobat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "includevoucherobatViewController") as? includevoucherobatViewController
        vc?.code = kodepromo.text ?? ""
        vc?.delegate = self
        present(vc!, animated: false, completion: nil)
        
    }
    
    func opennotesaldo(open : Bool){
        noteisisaldo.isHidden = !open
        tingginoteisisaldo.constant = open ? CGFloat(45) : CGFloat(0)
    }
    
    
    @objc func editprofile(){
        delegate.edit(data: mdata[selected] , row: selected)
    }
    
    @objc func startconsult(){
        if !statussend{
            return Toast.show(message: "Anda belum melengkapi form", controller: self)
        }
        
        if bayarvitrual{
            if mymoney?.accountbalance ?? 0 >= gettotal() {

                let vc = UIStoryboard(name: "pinandpassword", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "insertpinViewController") as? insertpinViewController
                vc?.delegate = self
                self.present(vc!, animated: true, completion: nil)
                         
            }else{
                Toast.show(message: "Maaf saldo anda tidak mencukupi.", controller: self)
            }
        }else{
            delegate.loading(load: true)
            chataction(pin : "")
            //                doku()
        }
    }
    
    @objc func form(){
        delegate.form()
    }
    
    @IBAction func show(_ sender: Any) {
        chooseDropDown.show()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll = > \(scrollView.contentOffset.y)")
        
        if scrollView.contentOffset.y <= 0.0{
            delegate.scrollup()
            ontop = true
        }
        if self.lastContentOffset  <= 0.0{
            if (self.lastContentOffset < scrollView.contentOffset.y) {
                scrollView.contentOffset.y = 10
                print("handap")
            }
        }else{
            if (self.lastContentOffset < scrollView.contentOffset.y) {
                delegate.scrolldown()
                if ontop{
                    scroll.isScrollEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.scroll.isScrollEnabled = true
                        self.ontop = false
                        
                    }
                }
                
                
            }
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    
}

extension transaksichatchildViewController : insertpinViewControllerdelegate,pembayaranrincianobatViewControllerdelegate{
    func kode(data: String) {
        kodepromo.text = data
        if data != "" {
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                self.api.getvoucher(token: token, code: data, type: 2) { (status, msg, datatmp) in
                    if status{
                        self.Mvoucher = datatmp
                    }else{
                        self.Mvoucher = nil
                        Toast.show(message: msg, controller: self)
                    }
                }
            }

        }else{
            self.Mvoucher = nil
        }
        
    }
    
    func lanjutpesanan(pin: String) {
        
        delegate.loading(load: true)
        chataction(pin : pin)
        
    }
    
    func close(_ msg: String, status: Bool) {
        
       
        if status{
            self.delegate.loading(load: false)

                if let email =  UserDefaults.standard.string(forKey: AppSettings.email) {
                    
                    let vc  = ConsultWaitViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .flipHorizontal
                    //vc.data = self.data
                    vc.uuid_patient = UserDefaults.standard.string(forKey: AppSettings.uuid)!
                    vc.uuid_doctor = self.detaildokter!.uuid
                    vc.email_patient = email
                    vc.email_doctor = self.detaildokter!.email
                    vc.rates = Int(self.detaildokter!.rates)!
                    vc.currentConsultation = self.consultationPostModel
                    
                    
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(self.consultationPostModel) {
                        UserDefaults.standard.set(encoded, forKey: AppSettings.KEY_CURRENT_CONSULTATION)
                    }
                    
                    //
                    weak var pvc = self.presentingViewController
                    
                    self.dismiss(animated: false) {
                        pvc?.present(vc, animated: true, completion: nil)
                        
                    }
                }
            
        }
    }
    
    
    func chataction(pin : String){
            if UserDefaults.standard.bool(forKey: AppSettings.pin){
                
                let email = UserDefaults.standard.string(forKey: AppSettings.email)
                let nama = UserDefaults.standard.string(forKey: AppSettings.name)
                let dokter = self.detaildokter!.full_name
                let harga = Int(self.detaildokter!.rates)!
                let total = self.gettotal()
                let tlp = UserDefaults.standard.string(forKey: AppSettings.phone)
                
                var stringform = ""
                if self.list.count == 1{
                    
                    stringform = "[{\"answer\":\"\(self.list[0].jawaban)\",\"id\":\"\(self.list[0].id)\",\"question\":\"\(self.list[0].question)\"}]"
                }else{
                    for i in 0..<self.list.count{
                        if stringform == "" {
                            stringform = "[{\"answer\":\"\(self.list[i].jawaban)\",\"id\":\"\(self.list[i].id)\",\"question\":\"\(self.list[i].question)\"}"
                        }else{
                            if i == self.list.count - 1{
                                stringform = stringform + ",{\"answer\":\"\(self.list[i].jawaban)\",\"id\":\"\(self.list[i].id)\",\"question\":\"\(self.list[i].question)\"}]"
                            }else{
                                stringform = stringform + ",{\"answer\":\"\(self.list[i].jawaban)\",\"id\":\"\(self.list[i].id)\",\"question\":\"\(self.list[i].question)\"}"
                            }
                            
                        }
                    }
                    
                }
                
                
                
                
                
                
                if pin == "" {
                    print("not pin")
                    print(email)
                    let param : Parameters = [
                        "CHAINMERCHANT":"NA",
                        "CURRENCY":"360",
                        "PURCHASECURRENCY":360,
                        "AMOUNT":"\(harga).00",
                        "PURCHASEAMOUNT":"\(total).00",
                        "EMAIL": email,
                        "NAME": nama,
                        "BASKET": "\(dokter),\(harga).00,1,\(total).00",
                        "MOBILEPHONE": tlp
                        
                        
                    ]
                    
                    self.chatacc.confirmConsultclinic(token: UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik)!, uuid_patient: UserDefaults.standard.string(forKey: AppSettings.uuid)!, uuid_doctor:  self.detaildokter!.uuid, email_patient: UserDefaults.standard.string(forKey: AppSettings.email)!, email_doctor: self.detaildokter!.email, rates: Int(self.detaildokter!.rates)!, jawab: stringform, medical_facility_id: self.facilityid!, voucher_amount: "\(self.getdiskon().0)", voucher: self.getdiskon().1, pin: pin, payment_id: self.pembayaran!.payment_id, payment_name: self.pembayaran!.payment_name, param: param, trans_merchant_id: "") { (data,merchant_id,url) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                        self.delegate.loading(load: false)
                        
                        if data != nil {
                            
                            self.currentConsultationId = data!.consultation_id!
                            self.consultationPostModel = data!
                            print("ini print")
                            print(url)
                            if url == nil {
                                print("kosong")
                                let vc  = ConsultWaitViewController()
                                vc.modalPresentationStyle = .fullScreen
                                vc.modalTransitionStyle = .flipHorizontal
                                vc.uuid_patient = UserDefaults.standard.string(forKey: AppSettings.uuid)!
                                vc.uuid_doctor = self.detaildokter!.uuid
                                vc.email_patient = UserDefaults.standard.string(forKey: AppSettings.email)!
                                vc.email_doctor = self.detaildokter!.email
                                vc.rates = Int(self.detaildokter!.rates)!
                                vc.currentConsultation = data!
                                
                                
                                let encoder = JSONEncoder()
                                if let encoded = try? encoder.encode(data!) {
                                    UserDefaults.standard.set(encoded, forKey: AppSettings.KEY_CURRENT_CONSULTATION)
                                }
                                
                                //
                                weak var pvc = self.presentingViewController
                                
                                self.dismiss(animated: false) {
                                    pvc?.present(vc, animated: true, completion: nil)
                                    
                                }
                            }else{
                                print("ayaan")
                                let vc = UIStoryboard(name: "PMR", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "OpenpdfViewController") as? OpenpdfViewController
                                vc?.headers = "DOKU pembayaran"
                                vc?.delegate = self
                                vc?.urlstring = url!
                                vc?.merchant_id = merchant_id!
                                self.present(vc!, animated: true, completion: nil)
                            }
                            
                        }
                        else {
                            Toast.show(message: "Gagal memulai sesi konsultasi", controller: self)
                        }
                        }
                        
                    }
                }else{
                    print("jol bayar cash")
                    self.chatacc.confirmConsultclinic(token: UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik)!, uuid_patient: UserDefaults.standard.string(forKey: AppSettings.uuid)!, uuid_doctor:  self.detaildokter!.uuid, email_patient: UserDefaults.standard.string(forKey: AppSettings.email)!, email_doctor: self.detaildokter!.email, rates: Int(self.detaildokter!.rates)!, jawab: stringform, medical_facility_id: self.facilityid!, voucher_amount: "\(self.getdiskon().0)", voucher: self.getdiskon().1, pin: pin, payment_id: "2", payment_name: "Escrow", param: nil, trans_merchant_id: "") { (data,merchant_id,url) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                        self.delegate.loading(load: false)
                        
                        if data != nil {
                            
                            self.currentConsultationId = data!.consultation_id!
                           
                            let vc  = ConsultWaitViewController()
                            vc.modalPresentationStyle = .fullScreen
                            vc.modalTransitionStyle = .flipHorizontal
                            //vc.data = self.data
                            vc.uuid_patient = UserDefaults.standard.string(forKey: AppSettings.uuid)!
                            vc.uuid_doctor = self.detaildokter!.uuid
                            vc.email_patient = UserDefaults.standard.string(forKey: AppSettings.email)!
                            vc.email_doctor = self.detaildokter!.email
                            vc.rates = Int(self.detaildokter!.rates)!
                            vc.currentConsultation = data!
                            
                            
                            let encoder = JSONEncoder()
                            if let encoded = try? encoder.encode(data!) {
                                UserDefaults.standard.set(encoded, forKey: AppSettings.KEY_CURRENT_CONSULTATION)
                            }
                            
                            //
                            weak var pvc = self.presentingViewController
                            
                            
                            self.dismiss(animated: false) {
                                pvc?.present(vc, animated: true, completion: nil)
                                
                            }
                            
                        }
                        else {
                            Toast.show(message: "Gagal memulai sesi konsultasi", controller: self)
                        }
                        
                    }
                }
                }
                
                
            }
        
    }
    
//    func doku(){
//        //        delegate.loading(load: true)
//        db.request { (user) in
//            if user != nil {
//                let email = user![0].email!.replacingOccurrences(of: "@", with: "%40")
//                let nama = user![0].fullname!.replacingOccurrences(of: " ", with: "%20")
//                let dokter = self.detaildokter!.full_name.replacingOccurrences(of: " ", with: "%20")
//                let harga = Int(self.detaildokter!.rates)!
//                let total = self.gettotal()
//                let tlp = user![0].phone ?? ""
//
//                let param = "CHAINMERCHANT=NA&CURRENCY=360&PURCHASECURRENCY=360&AMOUNT=\(harga).00&PURCHASEAMOUNT=\(total).00&EMAIL=\(email)&NAME=\(nama.replacingOccurrences(of: " ", with: "%20"))&BASKET=\(dokter)%2C\(harga).00%2C1%2C\(total).00&MOBILEPHONE=\(tlp)"
//
//
//
//                self.payment.dokupayment(token:  user![0].token!, param) { (status, id, url) in
//                    //                    self.delegate.loading(load: false)
//                    if status{
//                        self.merchant_id = id
//                        let vc = UIStoryboard(name: "PMR", bundle: nil).instantiateViewController(withIdentifier: "OpenpdfViewController") as? OpenpdfViewController
//                        vc?.headers = "DOKU pembayaran"
//                        vc?.delegate = self
//                        vc?.urlstring = url
//                        vc?.merchant_id = id
//                        vc?.pin = ""
//                        self.present(vc!, animated: true, completion: nil)
//                    }else{
//
//                    }
//                }
//            }
//        }
//
//    }
    
    func setupDropDowns() {
        setupChooseDropDown()
        
    }
    
    
    
    
    func setupChooseDropDown() {
        chooseDropDown.anchorView = selectname
        
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: selectname.bounds.height)
        
        
        chooseDropDown.dataSource = listname
        
        chooseDropDown.selectionAction = { [weak self] (index, item) in
            self?.selected = index
            self?.selectname.setTitle(item, for: .normal)
        }
    }
}

extension transaksichatchildViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if note.text == "" {
            note.text = "Apa yang anda rasakan"
            note.textColor = .darkGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate.scrolldown()
        if note.text == "Apa yang anda rasakan" {
            note.text = ""
            note.textColor = .black
        }
    }
}



extension transaksichatchildViewController : transaksichatmasterViewControllerdelegate{
    func kirimdatavalues(data: [listformmodel]) {
        self.list = data
        selectsending()
        
        
    }
    
    
    func close() {
        
    }
    
    func kirimdata(mdata :[ModelProfile],detaildokter:Detaildokter) {
        self.mdata = mdata
        loadview.isHidden = true
        self.detaildokter = detaildokter
        if mdata[selected].image != "" {
            let url = URL(string:  mdata[selected].image)
            photo.kf.setImage(with: url)
        }
        
        bb.text = mdata[selected].weight
        tb.text = mdata[selected].height
        umur.text = "\(age.calculateAge(dob: mdata[selected].dob, format: "yyyy-MM-dd").year) Tahun"
        self.selectname.setTitle(mdata[selected].full_name, for: .normal)
        //        layout()
        getbalance()
        totaldiskon.text = setmoney(harga: getdiskon().0)
        totalpembayaran.text = setmoney(harga: gettotal())
        
        print("seendd")
        print(setmoney(harga: getdiskon().0))
        
        print(setmoney(harga: gettotal()))
    }
    
    
    
}

//pembayaran
extension transaksichatchildViewController : metoderpembayaranViewControllerdelegate {
    
    
    func send(data: detailpayment) {
        self.pembayaran = data
        bayarvitrual = false
        
    }
    
    
    func layout(){
        
        photo.layer.cornerRadius = 10
        //        totaldiskon.isHidden = true
        //        totalpembayaran.isHidden = true
        //        totalpembayaran.layer.cornerRadius = 10
        //        totalpembayaran.layer.borderWidth = 1
        viewprofile.layer.cornerRadius = 10
        note.textColor = .darkGray
        viewnote.layer.cornerRadius = 10
        viewnote.layer.borderWidth = 1
        viewnote.layer.borderColor = Colors.basiccolor.cgColor
        edut.layer.cornerRadius = edut.frame.height / 2
        viewkodepromo.layer.cornerRadius = 5
        send.layer.cornerRadius = send.frame.height / 2
        totalpembayaran.layer.borderColor = UIColor.lightGray.cgColor
        
        viewchecked.layer.cornerRadius = 10
        backgroundvirtual.layer.cornerRadius = 10
        backgroundvirtual.layer.borderColor = UIColor.init(rgb: 0xEFEFEF).cgColor
        viewchecked.layer.borderColor = UIColor.init(rgb: 0xEFEFEF).cgColor
        backgroundvirtual.layer.borderWidth = 1
        viewchecked.layer.borderWidth = 1
        edut.backgroundColor = Colors.bluecolor
        send.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startconsult)))
        viewform.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(form)))
        edut.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editprofile)))
        if facilityid != nil{
            tinggitexts.constant = CGFloat(50)
        }else{
            viewform.isHidden = true
        }
        self.view.backgroundColor = Colors.backgroundmaster
        
        viewmasterpembayaranvirtual.layer.cornerRadius = 10
        viewpembayaranvirtual.isHidden = true
        tinggipembayaran.constant = CGFloat(0)
        self.view.layoutIfNeeded()
        
        checkmoneyvirtual.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pilihvirual)))
        
        
        viewmasterpembayaranvirtual.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectpembayaran)))
        checkpembayaranvirtual.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pilihwalet)))
    }
    
    
    func getbalance(){
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                self.getmoney.confirmConsult(token: token) { [self] (msg, data, status) in
                    if status{
                        self.mymoney = data
                        
                        
                        
                    }
                    
                }
            }
        
        
    }
    @objc func selectpembayaran(){
        let vc = UIStoryboard(name: "Pembayaran", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "metoderpembayaranViewController") as? metoderpembayaranViewController
        vc?.delegate = self
        present(vc!, animated: false, completion: nil)
    }
    
    @objc func pilihvirual(){
        bayarvitrual = true
    }
    
    
    @objc func pembayaranacc(){
        
        selectpembayaran()
    }
    
    @objc func pilihwalet(){
        if pembayaran == nil {
            selectpembayaran()
        }else{
            bayarvitrual = false
        }
        
    }
}
