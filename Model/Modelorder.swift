//
//  Modelorder.swift
//  Pasien
//
//  Created by Idham on 23/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
class modelreqorder {
    var address,id,note,vocer,voucher_amount:String
    var lat,long : Double
    var total,subtotal : Int
    var detail : [modelreqdetailorder]
    init(address:String,id:String,lat:Double,long:Double,note:String,total:Int,vocer:String,voucher_amount:String,detail : [modelreqdetailorder],subtotal:Int) {
        self.address = address
        self.id = id
        self.lat = lat
        self.long = long
        self.note = note
        self.total = total
        self.vocer = vocer
        self.detail = detail
        self.voucher_amount = voucher_amount
        self.subtotal = subtotal
    }
}

class modelreqdetailorder {
    var name,price,qty,slug,unit : String
    init(name: String,price: String,qty: String,slug: String,unit : String) {
        self.name = name
        self.price = price
        self.qty = qty
        self.slug = slug
        self.unit = unit
    }
    
}
