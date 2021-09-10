//
//  Mresepobat.swift
//  Pasien
//
//  Created by Idham on 12/11/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

struct Resepdigital : Codable{
    var doctor: Dokter?
    var recipes : [Resepobats]?
    var patient : Pasien?
    var expires,prescription_date,prescription_number,partner_app :String?
}

struct responresep : Codable {
    var  code : Int?
    var success: Bool?
    var messages : String?
    var data : Resepdigital?
}


struct  Pasien : Codable {
    var patient_name,age,image: String
    
}

struct  Dokter  : Codable {
    var doctor_name,specialist,number,image: String?
    
}

struct Resepobats  : Codable {
    var medicines_name,slug,rule,period,unit : String?
    var qty,prescription_id : Int?
    var status : Bool?
}


struct Resepobat  : Codable {
    var medicines_name,medicine_code_partner,slug,rule,period,unit,prescription_id : String?
    var qty : Int?
    var status : Bool?
}
