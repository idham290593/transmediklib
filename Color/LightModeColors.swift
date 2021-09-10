//
//  LightModeColors.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit


class LightModeColors : DefaultColors {
    
    override init() {
        super.init()
        backgroundColor  = .white
        //alertBackgroundColor = #colorLiteral(red: 0.124224127, green: 0.134500177, blue: 0.149428725, alpha: 1)
        alertBackgroundColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textColor  = .black
        secondaryTextColor  = .darkGray
        textFieldBackgroundColor  = .white
        secondaryBackgorundColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        buttonBackgroundColor  = .systemBlue
        buttonInactiveColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        buttonActiveColor = .systemBlue
        buttonTextColor  = .white
        clickLabelTextColor  = .systemBlue
        backButtonColor  = .systemBlue
        textFieldTintColor  = .systemBlue
        tabBarTintColor  = .systemBlue
        chatTextColor  = .black
        chatTextColor2 = .black
        chatBackgroundColor  = UIColor(hexString: "#ACEAEB")
        chatBorderColor  = UIColor(hexString: "#ACEAEB")
        chatBackgroundColor2  = UIColor(hexString: "#EAF0F4")
        chatBorderColorFailed = UIColor(hexString: "#FF0000")
        chatBorderColorSent = UIColor(hexString: "#F0AD4E")
        chatBorderColorDelivered = UIColor(hexString: "#5CB85C")
        chatBorderColorRead = UIColor(hexString: "#0275D8")
        chatBorderColor2 = UIColor(hexString: "#EAF0F4")
        messageBarBackgroundColor  = UIColor(red: 0.318, green: 0.765, blue: 0.769, alpha: 1)
        buttonInactiveTintColor = .darkGray
        tabBarUnselectedTabColor = .darkGray
        placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        chatSystemTextColor = .gray
        badgeColor  = .systemBlue
        badgeTextColor  = .white
    }
}
