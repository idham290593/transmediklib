//
//  ModelVoucer.swift
//  Pasien
//
//  Created by Idham on 03/11/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

class ModelVoucer{
    var code,name,slug,type,status,transaksitype,spesialist,spesialist_name,image : String
    var nominal,quota:Int
    
    init(code: String,name: String,slug: String,type: String,nominal: Int,quota: Int,status: String,transaksitype: String,spesialist: String,spesialist_name: String,image : String) {
        self.code = code
        self.name = name
        self.slug = slug
        self.type = type
        self.nominal = nominal
        self.quota = quota
        self.status = status
        self.transaksitype = transaksitype
        self.spesialist = spesialist
        self.spesialist_name = spesialist_name
        self.image = image
    }
    
}
