//
//  Resepobatmod.swift
//  transmedik
//
//  Created by Idham Kurniawan on 18/08/21.
//


import Foundation

struct ResepObatMod : Codable {
    var recipes : [recipes]
    var expires : String
    
}

struct recipes : Codable {
    
    var prescription_id : Int
    var slug : String
    var medicines_name : String
    var rule : String
    var qty : Int
    
}
