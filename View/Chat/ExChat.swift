//
//  ExChat.swift
//  Pasien
//
//  Created by Idham Kurniawan on 03/06/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//


import UIKit

class ExChat: UIView {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var umur: UILabel!
    @IBOutlet weak var bb: UILabel!
    @IBOutlet weak var tb: UILabel!
    @IBOutlet weak var nameclinic: UILabel!
    @IBOutlet weak var tinggiinfo: NSLayoutConstraint!
    @IBOutlet weak var viewinfo: UIView!
    @IBOutlet weak var nomorrm: UILabel!
    var isopen = true
    
    @IBOutlet weak var liatjawaban: UIButton!


    override init(frame: CGRect) {
        super.init(frame: frame)
        commit()
//        super.init

    }
   

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commit()
    }
    
    func commit(){
        
        
        let viewfromxib = Bundle.main.loadNibNamed("ExChat", owner: self, options: nil)![0] as! UIView
        viewfromxib.frame = self.bounds
        addSubview(viewfromxib)
        liatjawaban.layer.cornerRadius = 10
        
        
    }
    

    
}
