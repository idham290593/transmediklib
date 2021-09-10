//
//  passingontabbar.swift
//  Pasien
//
//  Created by Idham Kurniawan on 25/11/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
class Tabbarpassing {
    var sharedInstance: Tabbarpassing {
          struct Static {
               static let instance = Tabbarpassing()
          }
          return Static.instance
     }
     var tabindex : Int = 0
}
