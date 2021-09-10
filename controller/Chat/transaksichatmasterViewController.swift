//
//  transaksichatmasterViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//

import UIKit
import Alamofire


protocol transaksichatmasterViewControllerdelegate {
    func kirimdata(mdata :[ModelProfile],detaildokter:Detaildokter)
    func kirimdatavalues(data : [listformmodel] )
    func close()
}
class transaksichatmasterViewController: UIViewController,edit_and_add_phrViewControllerdelegate {

    
    @IBOutlet weak var back: UIView!
    
    @IBOutlet weak var headertxt: UILabel!
    var isform = false

    @IBOutlet weak var viewconstraint: UIView!
    @IBOutlet weak var viewtop: UIView!
    @IBOutlet weak var tinggi: NSLayoutConstraint!
    var delegate :transaksichatmasterViewControllerdelegate!
    @IBOutlet weak var photo: UIImageView!
    var facilityid : String?
    var list : [listformmodel] = []
//    var valueform : [valuesonform] = []
    var header = ""
    var dokter = Doctors()
    var id : String?
    var uuid = ""
    var detaildokter:Detaildokter!
    var profile = Profile()
    var mdata :[ModelProfile] = []
    var loading = 0{
        didSet{
            if success && loading == 3 {
                if mdata.count > 0 {
                    delegate.kirimdata(mdata: mdata, detaildokter: detaildokter)
                    let url = URL(string: detaildokter.profile_picture)
                    photo.kf.setImage(with: url)
                }
                
            }else if (!success && loading == 3){

                Toast.show(message: "Terjadi masalah pada server. coba beberapa saat lagi", controller: self)
            }
        }
    }
    var success = false
    
    func kirimdata(){
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewconstraint.layer.cornerRadius = 15
        self.view.layoutIfNeeded()
        self.viewtop.backgroundColor = .clear
        print("isform = > \(isform)" )

        tinggi.constant = self.view.frame.height - photo.frame.height -  CGFloat(80)
        koneksi()
        headertxt.text = "Konsultasi " + header
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
    }
    
    
    @objc func kembali(){
        delegate.close()
        print("masuk")
        dismiss(animated: true, completion: nil)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            var dvc = segue.destination as! transaksichatchildViewController
            self.view.layoutIfNeeded()
            dvc.views = self.view.frame.height
            dvc.facilityid = facilityid
            dvc.list = list
            dvc.isform = isform

//            dvc.valueform = valueform
            dvc.contex = self
            self.delegate = dvc
            dvc.delegate = self
        }
    }
    
    func koneksi(){
       
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
            
                
                self.profile.getprofile(token: token) { (data,msg) in
                    if msg.contains("Unauthenticated"){
                        UserDefaults.standard.set(true, forKey: "logout")
                        self.dismiss(animated: false, completion: nil)
                        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                    }
                    if data != nil {
                        print("my name = >\(data!.full_name)")
                        self.mdata.insert(data!, at: 0)
                        self.success = true
                    }else{
                        self.success = false
                        
                    }
                    self.loading += 1
                }
                
                self.profile.getkeluarga(token: token) { (keluarga,status,msg) in
                    if msg.contains("Unauthenticated"){
                        UserDefaults.standard.set(true, forKey: "Unauthenticated")
                        self.dismiss(animated: false, completion: nil)
                        self.presentingViewController?.dismiss(animated: false, completion: nil)
                    }
                    if status{
                        if keluarga != nil {
                            for tempkeluarga in keluarga!{
                                self.mdata.append(tempkeluarga)
                            }
                            self.success = true
                            
                        }else{
                            self.success = true
                            
                        }
                    }else{
                        self.success = false

                    }
                    self.loading += 1
                
                }
                
                self.dokter.getdokter(token:token, id: self.uuid) { (data) in
                   
                    
                    if data != nil {
                        self.detaildokter = data!
                        self.success = true
                        
                    }else{
                        self.success = false
                        
                    }
                    self.loading += 1
                }
            }
        
        
    }
    
    func kirim(){

        
    }
    
    
    
}
extension transaksichatmasterViewController : formsViewControllerdelegate,transaksichatchildViewControllerdelegate{
    func loading(load: Bool) {
        if load{
            self.loading(self)
        }else{
            self.closeloading(self)
        }
    }
    
    func kirim(list: [listformmodel]) {
        self.list = list
        delegate.kirimdatavalues(data: self.list)
    }
    
    

    
    func form() {
        let vc = UIStoryboard(name: "Form", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "newformsViewController") as? newformsViewController
        vc?.list = list
        vc?.delegates = self
        vc?.spesialis = id ?? ""
        vc?.klinik = facilityid ?? ""
        
        present(vc!, animated: true, completion: nil)
    }
    
    func ubah(data: ModelProfile, row: Int) {
        mdata[row] = data
        delegate.kirimdata(mdata: mdata, detaildokter: detaildokter)

    }
    
    func transaksi(data: ModelProfile, note: String) {
        
    }
    
    func edit(data: ModelProfile , row: Int) {
  
        let vc = UIStoryboard(name: "Edituser", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "edit_and_add_phrViewController") as? edit_and_add_phrViewController
        vc?.delegate = self
        
        vc?.uuid = mdata[row].uuid
        vc?.row = row
        vc?.typetambah = false
        
        vc?.datauser = mdata[row]
        present(vc!, animated: true, completion: nil)
        vc?.header.text = header

        
    }
    
   
    
    func scrolldown() {
        print("kebawah delegate")
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration : 0.5){
            self.viewconstraint.layer.cornerRadius = 0
            self.viewtop.backgroundColor = .white
            self.tinggi.constant = self.view.frame.height
                - self.viewtop.frame.height
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollup() {
        print("keatas delegate")
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration : 0.5){
            self.tinggi.constant = self.view.frame.height - self.photo.frame.height - CGFloat(80)
            self.viewtop.backgroundColor = .clear
            
            self.viewconstraint.layer.cornerRadius = 15
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    func ubahtinggi(tinggi: Int, berat: Int, row: Int) {
        mdata[row].height = String(tinggi)
        mdata[row].weight = String(berat)
        delegate.kirimdata(mdata: mdata, detaildokter: detaildokter)
    }
    
    
    
    
}

