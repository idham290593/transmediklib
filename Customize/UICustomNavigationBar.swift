//
//  UICustomNavigationBar.swift
//  Pasien
//
//  Created by Adam M Riyadi on 15/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class UICustomNavigationBar: UINavigationBar {
    
    @IBInspectable var customHeight : CGFloat = AppSettings.NAVIGATIONBAR_HEIGHT
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: customHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 4
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.layer.shadowOpacity = 1

        for subview in self.subviews {
            var stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("UIBarBackground") {
                subview.frame = CGRect(x: 0, y: -20, width: self.frame.width, height: customHeight + 20)
                subview.sizeToFit()
            }
            
            stringFromClass = NSStringFromClass(subview.classForCoder)
            
            if stringFromClass.contains("UINavigationBarContentView") {
                let centerY = (customHeight - subview.frame.height) / 2.0
                subview.frame = CGRect(x: 0, y: centerY, width: self.frame.width, height: subview.frame.height)
                subview.sizeToFit()
            }
        }
    }
}
