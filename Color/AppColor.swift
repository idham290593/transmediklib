//
//  AppColor.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class AppColor  {
    static let shared = AppColor()
    
    var defaultColors : DefaultColors?
    var lightModeColors : LightModeColors?
    var darkModeColors : DarkModeColors?
    
    private init(){}
    
    func instance(_ traitCollection : UITraitCollection) -> DefaultColors {
        return self.reload(traitCollection)
    }
    
    func reload(_ traitCollection : UITraitCollection) -> DefaultColors {
        /*if #available(iOS 12.0, *) {
         if (traitCollection.userInterfaceStyle == .dark) {
         if (self.darkModeColors == nil) {
         self.darkModeColors = DarkModeColors()
         }
         self.defaultColors = self.darkModeColors
         }
         else {
         if (self.lightModeColors == nil) {
         self.lightModeColors = LightModeColors()
         }
         self.defaultColors = self.lightModeColors
         }
         }
         else {
         if (self.defaultColors == nil) {
         self.defaultColors = DefaultColors()
         }
         }*/
        
        if (self.lightModeColors == nil) {
            self.lightModeColors = LightModeColors()
        }
        self.defaultColors = self.lightModeColors
        return self.defaultColors!
    }
}
