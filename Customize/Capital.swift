//
//  Capital.swift
//  Pasien
//
//  Created by Idham on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
