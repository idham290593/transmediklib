//
//  historypembelianViewControllerdelegatetochild.swift
//  transmedik
//
//  Created by Idham Kurniawan on 28/07/21.
//

import UIKit
import CoreLocation
//import ALLoadingView
import DropDown
//import GoogleSignIn


//import SkeletonView
protocol historypembelianViewControllerdelegatetochild {
    func sendding( uuid :String , selected : Int)
    func lokasi(long: Double? , lat : Double?,alamat : String)
    func connectionfailed()
}

class historypembelianViewController: MYUIViewController,CLLocationManagerDelegate,childhistoryViewControllertomasterdelegate {
 
    
    
    
  

    @IBOutlet weak var back: UIView!
    @IBOutlet weak var tinggi: NSLayoutConstraint!
    
    @IBOutlet weak var viewuser: UIView!

    
    @IBOutlet weak var navi: UIView!
    var delegate : historypembelianViewControllerdelegatetochild!
    
    var select = 0
    var getdatahistory = true
    @IBOutlet weak var user: UIButton!
    var listname:[String] = []
    var rowuser = 0{
        didSet{
            if mdata.count > 0{
                self.delegate.sendding(uuid: mdata[rowuser - 1].uuid, selected: select)

            }
        }
    }
    var isconnection =  true
    let locationManager = CLLocationManager()
    var token = ""
    var long:Double?
    var lat:Double?
    var alamat = ""{
        didSet{
            delegate.lokasi(long: long ?? 0.0 , lat : lat ?? 0.0 ,alamat : alamat)
        }
    }
    var data : [ModelHistories] = []
    var obat = Obat()
    var loading = false
    var mdata :[ModelProfile] = []
    var profile = Profile()
    
    let userDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.userDropDown,
        ]
    }()
    var success = false{
        didSet{
            set()
        }
    }
    var loadingint = 0{
        didSet{
            set()
        }
    }
    
    
    func set(){
        if success && loadingint == 2 {
            setuser()
            print("total mdata")
            print("\(mdata.count)")
            if mdata.count > 0{
                rowuser = 1
                self.user.setTitle(mdata[rowuser - 1].full_name, for: .normal)
                
                self.delegate.sendding(uuid: mdata[rowuser - 1].uuid, selected: select)
            }
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.backgroundmaster

        self.view.layoutIfNeeded()
        shadownavigation.shadownav(view: navi)

        isconnection = CheckInternet.Connection()
        viewuser.layer.cornerRadius = user.frame.height / 2
        viewuser.layer.shadowColor = UIColor.black.cgColor
        viewuser.layer.shadowOffset = CGSize.zero
        viewuser.layer.shadowRadius = 2
        viewuser.layer.shadowOpacity = 0.2
      
       
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        self.tabBarController?.tabBar.isHidden = true
        koneksi()
        
      
        
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "koneksi" {
            var dvc = segue.destination as! childhistoryViewController
            dvc.selected = select
            self.view.layoutIfNeeded()
            self.delegate = dvc
            dvc.delegate = self
        }
    }
    
    
    func koneksi(){
        if CheckInternet.Connection(){
            mdata.removeAll()
            listname.removeAll()
            success = false
            loadingint = 0
                if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                    
                    self.profile.getprofile(token: token) { (data,msg) in
                        if msg.contains("Unauthenticated"){
                            UserDefaults.standard.set(true, forKey: "Unauthenticated")
                            self.login()
                            
                        }
                        print("complited profile")
                        if data != nil {
                            print("my name = >\(data!.full_name)")
                            self.listname.insert(data!.full_name, at: 0)
                            self.mdata.insert(data!, at: 0)
                            self.success = true
                        }else{
                            self.success = false
                            
                        }
                        self.loadingint += 1
                    }
                    
                    self.profile.getkeluarga(token: token) { (keluarga,status,msg) in
                        if msg.contains("Unauthenticated"){
                            UserDefaults.standard.set(true, forKey: "Unauthenticated")
                            self.login()
                        }
//                        self.loadingint += 1
                        print("complited keluarga")
                        print("status ==>> \(status)")
                        if status{
                            if keluarga != nil {
                                for tempkeluarga in keluarga!{
                                    self.listname.append(tempkeluarga.full_name)
                                    
                                    self.mdata.append(tempkeluarga)
                                }
                                self.success = true
                                
                            }else{
                                self.success = true

                            }
                        }else{
                            self.success = false

                        }
                        self.loadingint += 1
                      
                    }
                    
                    
                }
            
            
        }else{
            delegate.connectionfailed()
        }
        
    }
    
    
    func login(){
//        self.tabBarController?.selectedIndex = 0
//        self.db.requestobat { (obat) in
//            if obat != nil {
//                self.db.deletobatall(data: obat!) { ( _ ) in
//
//                }
//            }
//        }
//        self.db.request { (users) in
//            if users != nil {
//                self.db.deleteuser(data: users!) { ( _ ) in
//                }
//            }
//        }
//
//        let vc = UIStoryboard(name: "Sign", bundle: nil).instantiateViewController(withIdentifier: "SigninViewController") as? SigninViewController
//
//
////        GIDSignIn.sharedInstance()?.signOut()
//        self.present(vc!, animated: false, completion: nil)
    }
    
    func setuser(){
        userDropDown.anchorView = user
        userDropDown.bottomOffset = CGPoint(x: 0, y: user.bounds.height)
        userDropDown.dataSource = listname
        userDropDown.selectionAction = { [weak self] (index, item) in
            print("index")
            print(index)
            self?.rowuser = index + 1
            self?.user.setTitle(item, for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        if UserDefaults.standard.bool(forKey: "ubahuser") || (CheckInternet.Connection() && isconnection != CheckInternet.Connection()){
            isconnection = CheckInternet.Connection()

            mdata.removeAll()
            listname.removeAll()
            koneksi()
            UserDefaults.standard.removeObject(forKey: "ubahuser")
        }
        
       
        
    
    }
    
    
    @IBAction func showuser(_ sender: Any) {
        if !getdatahistory{
            userDropDown.show()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        print("update^^")
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        let loc = CLLocation(latitude: lat!, longitude: long!)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loc) { (locstring, err) in
            if let _ = err {
                return
            }
            let pm = locstring! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = locstring![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                self.alamat = addressString
                
                //                print(addressString)
            }
            
            
        }
        
        locationManager.stopUpdatingLocation()
        
    }
    
    
    func open() {
//        UIView.animate(withDuration : 0.5){
//
//            self.tinggi.constant = CGFloat(110)
//            self.navi.isHidden.toggle()
//            self.view.layoutIfNeeded()
//
//
//
//        }
    }
    
    func close() {
//        UIView.animate(withDuration : 0.5){
//            self.tinggi.constant = CGFloat(0)
//            self.navi.isHidden.toggle()
//            self.view.layoutIfNeeded()
//        }
    }
    
    func getdata(status: Bool) {
        getdatahistory = status
    }
    
}





