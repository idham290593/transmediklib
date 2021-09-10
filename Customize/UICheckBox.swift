//
//  UICheckBox.swift
//  Pasien
//
//  Created by Adam M Riyadi on 14/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class UICheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checkbox-outline", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!.resizeWithWidth(width: 20)! as UIImage
    let uncheckedImage = UIImage(named: "checkbox-blank-outline", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!.resizeWithWidth(width: 20)! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
