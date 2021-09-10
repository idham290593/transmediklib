//
//  sale.swift
//  Pasien
//
//  Created by Idham on 02/10/20.
//  Copyright © 2020 idham. All rights reserved.
//

import Foundation
class Sale  {
    var product,image:String
    init(product :String , image :String) {
        self.product = product
        self.image = image
    }
}

class Arraysale {
    var sale : [Sale]
    var header : String
    init(header : String ,sale: [Sale]) {
        self.sale = sale
        self.header = header
    }
}
