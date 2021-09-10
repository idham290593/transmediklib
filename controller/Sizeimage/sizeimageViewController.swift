//
//  sizeimageViewController.swift
//  Pasien
//
//  Created by Idham on 05/11/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import UIKit
import Kingfisher

class sizeimageViewController: UIViewController {
    
    
    var gambar = ""
       
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var scroll: UIScrollView!
       @IBOutlet weak var images: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.gambar  != "-" && self.gambar  != "" && self.gambar != "https://s3-us-west-2.amazonaws.com/geomapid-assets/astronot.png"{
            let url = URL(string: gambar)
            images.kf.setImage(with: url)
        }else{
            self.images.image = UIImage(named : "empetyphoto", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
        }
        
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 6.0
        
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismis)))
    }
    
    
    @objc func dismis() {
        dismiss(animated: false, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return images
    }
}
