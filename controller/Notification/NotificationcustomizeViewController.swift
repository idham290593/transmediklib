//
//  NotificationcustomizeViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 16/08/21.
//

import UIKit
protocol NotificationcustomizeViewControllerdelegate  {
    func next(foraction :String )
}

class NotificationcustomizeViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var blur: UIVisualEffectView!
    
    @IBOutlet weak var butcancel: UIView!
    @IBOutlet weak var butapp: UIView!
    @IBOutlet weak var apptext: UILabel!
    var nexttext = ""
    var imagetext = ""
    var desctext = ""
    var headertext = ""
    var foraction = ""
    var delegate :NotificationcustomizeViewControllerdelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        image.image = UIImage(named: imagetext)
        header.text = headertext
        desc.text = desctext
        apptext.text = nexttext
        views.layer.cornerRadius = 15
        butapp.layer.cornerRadius = 8
        butcancel.layer.cornerRadius = 8
        butcancel.layer.borderWidth = 1
        butcancel.layer.borderColor = UIColor.init(rgb: 0xc4c4c4).cgColor
        
        blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        butcancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        
        butapp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextacc)))
        
    }
    
    @objc func kembali(){
        dismiss(animated: false, completion: nil)
    }
    
    @objc func nextacc(){
        dismiss(animated: false, completion: nil)
        delegate.next(foraction: foraction)
    }

   
}
