//
//  Date.swift
//  Pasien
//
//  Created by Idham on 09/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
extension Date{
     var daysInMonth:Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
}
