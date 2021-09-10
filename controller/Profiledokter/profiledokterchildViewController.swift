//
//  profiledokterchildViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//

import UIKit
protocol profiledokterchildViewControllerdelegate {
    func scrolldown()
    func scrollup()
    func chat()
    func love()
}

class profiledokterchildViewController: UIViewController,UIScrollViewDelegate {
    //view
    
    @IBOutlet weak var viewspesialis: UIStackView!
    @IBOutlet weak var viewrating: UIView!
    @IBOutlet weak var viewprice: UIView!
    @IBOutlet weak var viewstr: UIView!
    @IBOutlet weak var viewalumni: UIView!
    @IBOutlet weak var viewpraktik: UIView!
    @IBOutlet weak var viewend: UIView!
    
    var views :CGFloat?
    var delegate:profiledokterchildViewControllerdelegate!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var spesialis: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var lamakerja: UILabel!
    @IBOutlet weak var harga: UILabel!
    @IBOutlet weak var nostr: UILabel!
    @IBOutlet weak var vocer: UILabel!
    @IBOutlet weak var alumni: UILabel!
    @IBOutlet weak var praktik: UILabel!
    @IBOutlet weak var chat: UIView!
    @IBOutlet weak var coretan: UIView!
    @IBOutlet weak var tinggi: NSLayoutConstraint!
    private var lastContentOffset: CGFloat = 0
    @IBOutlet weak var cstatus: UIView!
    @IBOutlet weak var viewstatus: UIView!
    @IBOutlet weak var status: UILabel!
    
    var ontop = true
    var data : Detaildokter!{
        didSet{
            name.text = data.full_name
            spesialis.text = data.specialist
            rating.text = data.rating
            lamakerja.text = data.experience
            harga.text = "Rp.\(data.rates)"
            nostr.text = data.no_str
            alumni.text = data.edustring
            praktik.text = data.facilitiesstring
            status.text = data.description
            if data.status_docter == "Online"{
                viewstatus.layer.borderColor = UIColor.init(rgb: 0x48DF01).cgColor
                cstatus.backgroundColor = UIColor.init(rgb: 0x48DF01)
                chat.backgroundColor  = Colors.basicvalue
                
            }else{
                viewstatus.layer.borderColor = UIColor.init(rgb: 0xE75656).cgColor
                cstatus.backgroundColor = UIColor.init(rgb: 0xE75656)
                chat.backgroundColor  = UIColor.init(rgb: 0x959393)
            }
            
            let temptinggi = CGFloat(150) + name.frame.height + CGFloat(5) + viewspesialis.frame.height + CGFloat(20) + viewrating.frame.height + viewprice.frame.height + viewstr.frame.height +  viewalumni.frame.height  +  alumni.frame.height +  viewpraktik.frame.height +  praktik.frame.height +  viewend.frame.height
            
            tinggi.constant = views! > temptinggi ? views! : temptinggi
            self.view.layoutIfNeeded()
            
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.delegate = self
        vocer.isHidden = true
        coretan.isHidden = true
        //        db.request { (user) in
        //            if user != nil {
        //                self.profil.getdokter(token: user![0].token!, id: self.uuid) { (data) in
        //                    self.data = data
        //                }
        //            }
        //        }
        
        viewstatus.layer.borderWidth = 1
        viewstatus.layer.cornerRadius = 8
        cstatus.layer.cornerRadius = cstatus.frame.height / 2
        chat.layer.cornerRadius = chat.frame.height / 2
        chat.backgroundColor = Colors.basicvalue
        chat.backgroundColor = Colors.basiclabel
        chat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chatacc)))
       
        
    }
    
    @objc func chatacc(){
        if data.status_docter == "Online"{
            delegate.chat()
        }
       
    }
    
    @objc func loveacc(){
        delegate.love()
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll = > \(scrollView.contentOffset.y)")
        
        
        if scrollView.contentOffset.y <= 0.0{
            delegate.scrollup()
            ontop = true
            
        }
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            delegate.scrolldown()
            print("kebawah")
            if ontop{
                scroll.isScrollEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.scroll.isScrollEnabled = true
                    self.ontop = false
                    
                }
            }
            
        }
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
}

extension profiledokterchildViewController : profiledoktermasterViewControllerdelegate{
    func kirimdata(data:Detaildokter) {
        self.data = data
    }
    
    
    
    
}
