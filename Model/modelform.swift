//
//  modelform.swift
//  Pasien
//
//  Created by Idham Kurniawan on 12/03/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//

import Foundation
struct listvalue {
    var id,label : String
    var check:Bool
}

struct listformmodel {
    var id,question,component,input_type : String
    var required,issingle: Bool
    var detail: [listvalue]?
    var jawaban : String
    
}
