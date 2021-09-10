//
//  UIPrimaryButton.swift
//  Pasien
//
//  Created by Adam M Riyadi on 18/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class UIPrimaryButton: UIButton {
    
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
//        self.backgroundColor = UIColor(hexString: "#51C3C4")
        self.backgroundColor = Colors.bluecolor
        self.tintColor = UIColor.white
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 16)
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
