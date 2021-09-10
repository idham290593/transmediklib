//
//  TypingBubble+Extensions.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

extension TypingBubble {
    
    open override var backgroundColor: UIColor? {
        set {
            //[contentBubble, cornerBubble, tinyBubble].forEach { $0.backgroundColor = newValue }
            [contentBubble, cornerBubble, tinyBubble].forEach { $0.backgroundColor = AppColor.shared.instance(traitCollection).chatBackgroundColor2 }
        }
        get {
            return contentBubble.backgroundColor
        }
    }
}
