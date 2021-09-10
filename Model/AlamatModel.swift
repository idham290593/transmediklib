//
//  Alamat.swift
//  Pasien
//
//  Created by Idham on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

struct alamatdelivery {
    var address:String
    var long,lat : Double
}

class AlamatModel {
    var  address,address_type,id, map_lat,map_lng,note,patient_id:String
    init(address:String,address_type:String,id:String, map_lat:String,map_lng:String,note:String,patient_id:String) {
        self.id = id
        self.address = address
        self.address_type = address_type
        self.map_lat = map_lat
        self.map_lng = map_lng
        self.note = note
        self.patient_id = patient_id
    }
}


