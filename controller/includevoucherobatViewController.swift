//
//  includevoucherobatViewController.swift
//  Pasien
//
//  Created by Idham on 03/11/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

protocol pembayaranrincianobatViewControllerdelegate {
    func kode(data : String)
}


import UIKit
class includevoucherobatViewController: UIViewController {
    
    
    @IBOutlet weak var viewtext: UIView!
    
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var kode: UITextField!
    @IBOutlet weak var sendbut: UIView!
    
    
    var code = ""
    var delegate : pembayaranrincianobatViewControllerdelegate!
    
    @IBOutlet weak var sc: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sc.bounces = false
        self.view.layoutIfNeeded()
        kode.text = code
        sendbut.backgroundColor = Colors.basicvalue
        viewtext.layer.borderColor = Colors.basicvalue.cgColor
        viewtext.layer.borderWidth = 1
        viewtext.layer.cornerRadius = 8
        sendbut.layer.cornerRadius = sendbut.frame.height / 2
        kode.becomeFirstResponder()
        sendbut.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kirim)))
        blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        
    }
    
    
    @objc func kirim(){
        delegate.kode(data: kode.text ?? "")
        dismiss(animated: false, completion: nil)
    }
    
    @objc func close(){
        dismiss(animated: false, completion: nil)
    }
    
}
