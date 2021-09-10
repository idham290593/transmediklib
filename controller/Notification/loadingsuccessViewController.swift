//
//  loadingsuccessViewController.swift
//  Pasien
//
//  Created by Idham Kurniawan on 16/12/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import UIKit


class loadingsuccessViewController: UIViewController {

    @IBOutlet weak var closes: UIVisualEffectView!
    var status = "berhasil"
    @IBOutlet weak var views: UIView!
    var texts = ""
    var delegate : openchatfromdoku?
    @IBOutlet weak var pesan: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pesan.text = texts
        if status == "berhasil" {
            icon.image = UIImage(named: "Loading sukses input data", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
        }else if status == "gagal"{
            icon.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)

        }else if status == "gagal login"{
//
            icon.image = UIImage(named: "Tanda Seru-1", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
            pesan.text = "Sesi akun anda telah berakhir dikarenakan akun telah digunakan atau karena batas waktu sesi. Silahkan login kembali untuk melanjutkan"
        }else{
            icon.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
        }
        views.layer.cornerRadius = 15
        closes.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        
    }
    
    @objc func kembali(){
        delegate?.close()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.kembali()
        }
    }
   
  

}
