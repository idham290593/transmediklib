//
//  extensionchatdetailViewController.swift
//  Pasien
//
//  Created by Idham Kurniawan on 13/07/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//
protocol extensionchatdetailViewControllerdelegate  {
    func endchat()
    
}


import UIKit
import CDAlertView

class extensionchatdetailViewController: UIViewController {
    
    @IBOutlet weak var vcbutt: UIView!
    @IBOutlet weak var akhirichat: UIView!
    @IBOutlet weak var txtrm: UILabel!
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var txtdate: UILabel!
    @IBOutlet weak var txttb: UILabel!
    @IBOutlet weak var txtbb: UILabel!
    @IBOutlet weak var txtumur: UILabel!
    @IBOutlet weak var back: UIImageView!
    
    @IBOutlet weak var txtclinic: UILabel!
    
    @IBOutlet weak var lihatjawaban: UIButton!
    var date = ""
    var rm = ""
    var bb = ""
    var age = ""
    var tb = ""
    var isform : Bool?
    var faskes = ""
    var consultationEnded: Bool = false
    var currentConsultation: ConsultationPostModel?
    var delegate : extensionchatdetailViewControllerdelegate!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vcbutt.layer.cornerRadius = 10
        akhirichat.layer.cornerRadius = 10
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        header.text = "Informasi Pasien"
        txtdate.text = date
        txtrm.text = self.rm
        txtbb.text = self.bb + "Kg"
        txtumur.text = self.age
        txttb.text = self.tb + "Cm"
        lihatjawaban.layer.cornerRadius = 6
        txtclinic.text = self.faskes
        vcbutt.isHidden = true
        lihatjawaban.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(jawaban)))
        vcbutt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(vcall)))
        akhirichat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endchat)))
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func jawaban(){
        let vc =  UIStoryboard(name: "Form", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "FormjawabViewController") as? FormjawabViewController
        vc?.id = String(currentConsultation?.consultation_id ?? 0)
        present(vc!, animated: true, completion: nil)
    }
    
    @objc func vcall(){
        
    }
    
    @objc func endchat(){
        if (!self.consultationEnded) {
            let alert = CDAlertView(title: LocalizationHelper.getInstance().keluar_conversations, message: LocalizationHelper.getInstance().akhiri_conversations, type: .warning)
            
            let yesAction = CDAlertViewAction(title: LocalizationHelper.getInstance().yes) { (CDAlertViewAction) -> Bool in
                self.dismiss(animated: true, completion: nil)
                self.delegate.endchat()
                
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


}
