//
//  DarkModeColors.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class DarkModeColors : DefaultColors {
    
    override init() {
        super.init()
        backgroundColor  = UIColor(hexString: "#1b1d26")
        //alertBackgroundColor = #colorLiteral(red: 0.124224127, green: 0.134500177, blue: 0.149428725, alpha: 1)
        alertBackgroundColor  = #colorLiteral(red: 0.06213699205, green: 0.06692051073, blue: 0.0752768583, alpha: 1)
        textColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        secondaryTextColor  = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        textFieldBackgroundColor  = #colorLiteral(red: 0.1679400036, green: 0.1818323118, blue: 0.2020143849, alpha: 1)
        secondaryBackgorundColor  = #colorLiteral(red: 0.3739808855, green: 0.3814605033, blue: 0.3814605033, alpha: 1)
        buttonBackgroundColor  = #colorLiteral(red: 0.06213699205, green: 0.06692051073, blue: 0.0752768583, alpha: 1)
        buttonInactiveColor  = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        /*buttonActiveColor = #colorLiteral(red: 0.8472741425, green: 0.5494065011, blue: 0.1409574963, alpha: 1)
        buttonTextColor  = #colorLiteral(red: 0.8472741425, green: 0.5494065011, blue: 0.1409574963, alpha: 1)
        clickLabelTextColor  = #colorLiteral(red: 0.8472741425, green: 0.5494065011, blue: 0.1409574963, alpha: 1)
        backButtonColor  = #colorLiteral(red: 0.8472741425, green: 0.5494065011, blue: 0.1409574963, alpha: 1)
        textFieldTintColor  = #colorLiteral(red: 0.8472741425, green: 0.5494065011, blue: 0.1409574963, alpha: 1)
        tabBarTintColor  = #colorLiteral(red: 0.8472741425, green: 0.5494065011, blue: 0.1409574963, alpha: 1)*/
        buttonActiveColor  = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        buttonTextColor  = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        clickLabelTextColor  = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        backButtonColor  = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        textFieldTintColor  = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        tabBarTintColor  = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        chatTextColor  = .white
        chatTextColor2 = .white
        chatBackgroundColor  = UIColor(hexString: "#424242")
        chatBorderColor  = UIColor(hexString: "#424242")
        chatBackgroundColor2  = UIColor(hexString: "#424242")
        chatBorderColorFailed = UIColor(hexString: "#FF0000")
        chatBorderColorSent = UIColor(hexString: "#F0AD4E")
        chatBorderColorDelivered = UIColor(hexString: "#5CB85C")
        chatBorderColorRead = UIColor(hexString: "#0275D8")
        chatBorderColor2 = UIColor(hexString: "#c4c4c4")
        messageBarBackgroundColor  = #colorLiteral(red: 0.193905689, green: 0.2088332138, blue: 0.2349101654, alpha: 1)
        buttonInactiveTintColor = #colorLiteral(red: 0.5659740086, green: 0.5659740086, blue: 0.5659740086, alpha: 1)
        tabBarUnselectedTabColor = .white
        placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        chatSystemTextColor = .lightGray
        badgeColor  = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        badgeTextColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
