//
//  Getprice.swift
//  transmedik
//
//  Created by Idham Kurniawan on 24/08/21.
//

import Foundation


struct MedicinesPrice : Codable {
    var medicine_code_partner,slug,name,unit,price,stock : String?
    var status,available : Bool?
    var max_prices,min_prices,qty : Int?
}

struct CouriersPrice : Codable {
    var id,type,subType,name,image,price : String?
}

struct DataPrice : Codable {
    var pharmacy_name,map_lat,map_lng,address,pharmacy_custNumber,pharmacy_shiptoNumber,balance,email,phone_number,fullname : String?
    var id : Int?
    var medicines: [MedicinesPrice]?
    var couriers : [CouriersPrice]?
}

struct GetPriceObat : Codable {
    var code : Int
    var messages : String?
    var data : DataPrice?
   
}
