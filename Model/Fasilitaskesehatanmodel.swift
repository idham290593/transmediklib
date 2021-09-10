//
//  Fasilitaskesehatanmodel.swift
//  Pasien
//
//  Created by Idham on 26/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
class Fasilitaskesehatanmodel{
    var id,name,province_id,province,regency_id,regency,image,address:String
    var lat,long:Double
    var medical_form : Bool
    
    init(id:String,name:String,province_id:String,province:String,regency_id:String,regency:String,address:String,lat:Double,long:Double,image : String,medical_form : Bool) {
        self.id = id
        self.name = name
        self.province = province
        self.province_id = province_id
        self.regency_id = regency_id
        self.regency = regency
        self.address = address
        self.lat = lat
        self.long = long
        self.image = image
        self.medical_form  = medical_form
        
    }
}
