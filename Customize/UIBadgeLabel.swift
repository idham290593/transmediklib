//
//  UIBadgeLabel.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class UIBadgeLabel: UILabel {
    var badgeColor: UIColor = .red

    convenience init(badge: String?, color: UIColor = .red) {
        self.init()
        badgeColor = color
        text = badge
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
        textColor = .white
        backgroundColor = .clear
        textAlignment = .center
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(badgeColor.cgColor)
        context!.fillEllipse(in: rect)
        super.draw(rect)
    }

    override var text: String? {
        didSet {
            guard let text = self.text else {
                isHidden = true
                return
            }
            if text.isEmpty {
                isHidden = true
                return
            }
            if let count = Int(text), count == 0 {
                isHidden = true
                return
            }
            isHidden = false
        }
    }

    let margin: CGFloat = 3

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        //swift 4.2
//        let rect = rect.inset(by: insets)
        let rect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: rect)
    }
}
