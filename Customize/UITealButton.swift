//
//  UITealButton.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class UITealButton: UIButton {
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.backgroundColor = UIColor.systemTeal
        self.tintColor = UIColor.white
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
}
