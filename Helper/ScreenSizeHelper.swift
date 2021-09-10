//
//  ScreenSizeHelper.swift
//  Pasien
//
//  Created by Adam M Riyadi on 21/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit

class ScreenSizeHelper {
    
    static func width() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func height() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
