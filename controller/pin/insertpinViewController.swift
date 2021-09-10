//
//  insertpinViewController.swift
//  Pasien
//
//  Created by Idham Kurniawan on 10/12/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import UIKit
import SVPinView

protocol insertpinViewControllerdelegate {
    func lanjutpesanan(pin : String)
}

class insertpinViewController: UIViewController, openchatfromdoku {
   
    
   
    

    
    
    @IBOutlet weak var send: UIView!
    @IBOutlet weak var pin: SVPinView!
    @IBOutlet weak var lupapin: UILabel!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet var views: UIView!
    
    var delegate : insertpinViewControllerdelegate!
   
    var pintext = ""
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
//        pin.style = .box
        self.view.layoutIfNeeded()
        pin.didFinishCallback = {  pin in
            self.pintext = pin
            
        }
        headerlabel.textColor = Colors.headerlabel
        send.backgroundColor = Colors.basicvalue
        send.layer.cornerRadius = 10
        
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        send.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sending)))
        views.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    func keluar() {
        
    }
    
    func close() {
        
    }
    
    
    @objc func sending(){
        view.endEditing(true)

        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                print(self.pintext)
                Transmedik.checkpin(token: token, pin: self.pintext) { (status, msg) in
                    if msg == "Unauthenticated."{
                        let vc = UIStoryboard(name: "Notification", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "loadingsuccessViewController") as? loadingsuccessViewController
                        UserDefaults.standard.set(true, forKey: "logout")
                        vc?.status =  "gagal login"
                        vc?.delegate = self
                        self.present(vc!, animated: false, completion: nil)
                    }
                    
                    if status{
                        self.dismiss(animated: true, completion: nil)
                        self.delegate.lanjutpesanan( pin : self.pintext)
                    }else{
                        Toast.show(message: msg, controller: self)
                    }
                }
            }
        
    }
    
 
    
   
    


}
