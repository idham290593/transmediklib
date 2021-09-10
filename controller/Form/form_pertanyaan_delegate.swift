//
//  form_pertanyaan_delegate.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//


import Foundation




struct valuesonform {
    var id,question,jawaban : String
    var required : Bool
     
}

protocol form_pertanyaan_delegate {
    func set_textfield_value_to_master(row:Int , value : String)
    func set_radio_value_to_master(row:Int , value : String,list : Int? , status : Bool , datavalue :[listvalue])
    func set_checkbox_value_to_master(row:Int , value : String,datavalue :[listvalue])

    func set_checkbox_value_to_master(row:Int , value : String,list : Int , status : Bool)
    func setdate(row:Int , value : String)
    func send()
    func refresh(row : Int)
    func endkyeboard()
}

