//
//  profiledoktermasterViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//


import UIKit
import Kingfisher

protocol profiledoktermasterViewControllerdelegate {
    func kirimdata(data:Detaildokter)
}

class profiledoktermasterViewController: UIViewController {
    @IBOutlet weak var viewconstraint: UIView!
    
    @IBOutlet weak var headertxt: UILabel!
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var viewtop: UIView!
    @IBOutlet weak var tinggi: NSLayoutConstraint!
    var delegate :profiledoktermasterViewControllerdelegate!
    @IBOutlet weak var photo: UIImageView!
    var data : Detaildokter!
    var profil = Doctors()
    var isform = false

    var uuid = ""
    var facilityid : String?
    var list : [listformmodel] = []
//    var valueform : [valuesonform] = []
    var header = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewconstraint.layer.cornerRadius = 15
        self.view.layoutIfNeeded()
        tinggi.constant = self.view.frame.height - photo.frame.height -  CGFloat(80)
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
               
            self.profil.getdokter(token: token, id: self.uuid) { (data) in
                    if data != nil {
                        self.data = data
                    }
                    
                    let url = URL(string: self.data.profile_picture)
                    self.photo.kf.setImage(with: url)
                    self.delegate.kirimdata(data: self.data)
                }
            }
        
        self.viewtop.backgroundColor = .clear
        headertxt.text = "Konsultasi " + header
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            var dvc = segue.destination as! profiledokterchildViewController
            self.view.layoutIfNeeded()
            dvc.views = self.view.frame.height
            self.delegate = dvc
            dvc.delegate = self
        }
    }
    
}

extension profiledoktermasterViewController : profiledokterchildViewControllerdelegate,transaksichatmasterViewControllerdelegate{
    func kirimdatavalues(data: [listformmodel]) {
        self.list = data
    }
    
    
    
   
    func close() {
        print("masuk close")
        dismiss(animated: false, completion: nil)
        dismiss(animated: false, completion: nil)

    }
    func scrollenable(){
        
    }
    
    func kirimdata(mdata: [ModelProfile], detaildokter: Detaildokter) {
        
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
//
    }
    
    func chat() {
        let vc = UIStoryboard(name: "Chat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "transaksichatmasterViewController") as? transaksichatmasterViewController
        vc?.list = list
        vc?.header = header
//        vc?.valueform = valueform
        vc?.isform = isform

        vc?.facilityid = facilityid
        vc?.uuid = uuid
        vc?.delegate = self
        present(vc!, animated: true, completion: nil)
    }
    
    func love() {
        
    }
    
    
}
