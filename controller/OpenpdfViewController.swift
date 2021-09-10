//
//  OpenpdfViewController.swift
//  Pasien
//
//  Created by Idham on 04/11/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import UIKit
import PDFKit
protocol OpenpdfViewControllerdelegate  {
    func close(_ msg : String, status : Bool)
}
protocol openchatfromdoku {
    func close()
}


class OpenpdfViewController: UIViewController, UIWebViewDelegate, openchatfromdoku {
    
    
   
    @IBOutlet weak var refreshButton: UIButton!
    var cekoder = Orderobject()
    var merchant_id : String?
    var pin : String?
    var status :Bool?
    var payment = paymentobject()
    var delegate : OpenpdfViewControllerdelegate?
    var urlstring = ""
    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var back: UIImageView!
    var headers = "Daftar Personal Health Record"
    @IBOutlet weak var web: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if headers == "Pembayaran" {
            refreshButton.isHidden = false
        }else{
            refreshButton.isHidden = true

        }
        headerlabel.text = headers
        headerlabel.textColor = Colors.headerlabel
          let url : NSURL! = NSURL(string: urlstring)
        web.delegate = self
        web.loadRequest(NSURLRequest(url: url as URL) as URLRequest)
        
        
        
        
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))

    }
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func refresh(_ sender: Any) {
      if  let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
        web.reload()
        cekoder.checkPayment(token: token, id: merchant_id!) { status, msg in
            if status{
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    }
    
    
    

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        print("shouldStartLoadWith")
        print(request.url?.scheme)
        print(request.url)
        

        if request.url != nil && "\(request.url!)" == "https://api-dev.transmedika.co.id/redirect-form"{
                if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                    self.payment.checkpayment(token: token, self.merchant_id!) { (status) in
                        self.status = status
                        let vc = UIStoryboard(name: "Notification", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "loadingsuccessViewController") as? loadingsuccessViewController
                        vc?.texts = status ? "Transaksi berhasil" : "Transaksi gagal"
                        vc?.status =  status ? "berhasil" : "gagal"
                        vc?.delegate = self
                        self.present(vc!, animated: false, completion: nil)
                        
                        
                    }

                }
                
            
        }
        
        return true
    }
  
    func close() {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        self.delegate?.close(self.pin ?? "", status: status!)
    }
   
    
}
