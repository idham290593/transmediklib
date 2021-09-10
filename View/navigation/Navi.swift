//
//  Navi.swift
//  Pasien
//
//  Created by Idham Kurniawan on 16/03/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//

import UIKit

class Navi: UIView {

    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var back: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commit()
    }

    func commit(){
        let viewfromxib = Bundle.main.loadNibNamed("Navi", owner: self, options: nil)![0] as! UIView
        viewfromxib.frame = self.bounds
        addSubview(viewfromxib)
        
        
    }

}
