//
//  ModelProfile.swift
//  Pasien
//
//  Created by Idham on 09/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
class ModelProfile  {
  
    
    var uuid,full_name,email,phone_number,gender,status,nik,no_kk,dob,height,weight,blood,relationship,allergy,created_at,updated_at,image : String
    init(uuid:String,full_name:String,email:String,phone_number:String,gender:String,status : String,nik: String,no_kk: String,dob: String,height: String,weight: String,blood: String,relationship : String,allergy:String,created_at:String,updated_at : String,image:String) {
        
        self.uuid = uuid
        self.full_name = full_name
        self.email = email
        self.phone_number = phone_number
        self.gender = gender
        self.status = status
        self.nik = nik
        self.no_kk = no_kk
        self.dob = dob
        self.height = height
        self.weight = weight
        self.blood = blood
        self.relationship = relationship
        self.allergy = allergy
        self.created_at = created_at
        self.updated_at = updated_at
        self.image = image
        
    }
    
    
}

class relation{
    var name,slug :String
    init(name:String,slug:String) {
        self.name = name
        self.slug = slug
    }
}
