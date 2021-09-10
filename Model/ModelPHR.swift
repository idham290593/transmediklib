//
//  ModelPHR.swift
//  Pasien
//
//  Created by Idham on 17/11/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
struct ModelPHR {
    var allergy : [allergy]
    var hematology : hematology?
    var immunization : [immunization]
    
}


struct allergy {
    var frequency,id,name,reaction :String
}

struct hematology {
    var created_at,updated_at :String
    var diastolic,heart_rate,systolic : Int
}


struct immunization {
    var immunization_name,injection_date,next_schedule,provider,tipe,immunization_type_id,id,created_at,updated_at:String
}

struct immunizations{
    var id,name:String
}
