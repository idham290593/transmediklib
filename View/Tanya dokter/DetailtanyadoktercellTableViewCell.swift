//
//  DetailtanyadoktercellTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 08/07/21.
//

import UIKit
protocol DetailtanyadoktercellTableViewCellacc {
    func klikfoto(row :Int)
    func chat(row : Int)
}

class DetailtanyadoktercellTableViewCell: UITableViewCell {
    
    var delegate : DetailtanyadoktercellTableViewCellacc!
    @IBOutlet weak var backgroundview: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var quality: UILabel!
    @IBOutlet weak var oldwork: UILabel!
    @IBOutlet weak var chatbutton: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var specialist: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var star: UIImageView!
    @IBOutlet weak var iconoldwork: UIImageView!
    @IBOutlet weak var iconavailable: UIImageView!
    @IBOutlet weak var iconidr: UIImageView!
    
    
    var row:Int?
    var isdata = false
    var chatcolor : UIColor?
    var statuscolor : UIColor?
    
    @IBOutlet weak var status: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
     
//        star.image = UIImage(named: "tanyadokterstart", in: AppSettings.bundleframework, compatibleWith: nil)
//        iconidr.image = UIImage(named: "tanyadoktermikro", in: AppSettings.bundleframework, compatibleWith: nil)
//        iconavailable.image = UIImage(named: "tanyadokterclock", in: AppSettings.bundleframework, compatibleWith: nil)
//        iconidr.image = UIImage(named: "tanyadokterrp", in: AppSettings.bundleframework, compatibleWith: nil)
//        

        
        chatbutton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(chatacc)))
        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(photoklik)))
        
    }
    
    override func prepareForReuse() {
        if isdata{
            chatbutton.backgroundColor = UIColor.clear
            status.backgroundColor = UIColor.clear
        }
        
        
        if chatcolor != nil && statuscolor != nil {
            chatbutton.backgroundColor = chatcolor
            status.backgroundColor = statuscolor
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
//
//    func warna(status : UIColor,statuschat: UIColor){
//        self.chatbutton.backgroundColor = statuschat
//        self.status.backgroundColor = status
//    }
//
    
    
    @objc func photoklik(){
        if row != nil {
            delegate.klikfoto(row: row!)
            
        }
    }
    
    @objc func chatacc(){
        if row != nil {
            
            delegate.chat(row: row!)
        }
    }
}
