//
//  Notifserverdown.swift
//  Pasien
//
//  Created by Idham Kurniawan on 05/04/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//

import Foundation
import UIKit
class Notifserverdown: UIView {
    
    
    @IBOutlet weak var views: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commit()
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commit()
    }

        func commit(){
        
        let viewfromxib = Bundle.main.loadNibNamed("Notifserverdown", owner: self, options: nil)![0] as! UIView
    

        viewfromxib.frame = self.bounds
        views.layer.cornerRadius = 15
        
        addSubview(viewfromxib)
        
    }

}
