//
//  shadownavigation.swift
//  Pasien
//
//  Created by Idham Kurniawan on 26/03/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//

import Foundation
import UIKit
class shadownavigation {
    
    static func shadownav(view : UIView){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)

    }
}
