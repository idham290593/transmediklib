//
//  PHR.swift
//  Pasien
//
//  Created by Idham on 19/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

struct newlistmodelpmh {
    var data : [Modellistpmr]
    var first_page_url,next_page_url : String
}


class Modellistpmr  {
  
    var id,date,diagnosa,dokter:String
    init( id:String,date:String,diagnosa:String,dokter:String) {
        self.id = id
        self.date = date
        self.diagnosa = diagnosa
        self.dokter = dokter
        
    }
    
    
}
class pmrdokter {
    var doctor_name,specialist,number,image : String
    init(doctor_name : String,specialist: String,number: String,image : String) {
        self.doctor_name = doctor_name
        self.specialist = specialist
        self.number = number
        self.image = image
    }
}

class pmrconsultation {
 
    var symptoms,possible_diagnosis,advice :String
    init(symptoms:String,possible_diagnosis:String,advice :String) {
        self.symptoms = symptoms
        self.possible_diagnosis = possible_diagnosis
        self.advice = advice
    }
}
class pmrprescription {
    
    var medicine_name,rule,days_consume,note,qty :String
    init(medicine_name:String,rule : String,days_consume:String,note:String,qty :String) {
        self.medicine_name = medicine_name
        self.days_consume = days_consume
        self.note = note
        self.qty = qty
        self.rule = rule
    }
    
}

class detailpmr  {
    var prescription : [pmrprescription]
    var doctor:pmrdokter
    var consultation : pmrconsultation
    var expires : String
    var file : [String]
    
    init(prescription : [pmrprescription],dokter :pmrdokter,consultation:pmrconsultation,expires: String,file : [String]) {
        self.prescription = prescription
        self.doctor = dokter
        self.consultation = consultation
        self.expires = expires
        self.file = file
    }
    
 
}
