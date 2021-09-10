//
//  ModelHistories.swift
//  Pasien
//
//  Created by Idham on 27/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
class ModelHistories{
    
    
    var type_history,label,name,transaction_date,status : String
    var total,rating : Int
    var  detail_consultation : detailconsul?
    var detail_medicine : [resdetailobat]
    init(type_history: String,label: String,name: String,transaction_date: String,status : String,total : Int,detail_medicine : [resdetailobat], detail_consultation : detailconsul?,rating : Int) {
        self.type_history = type_history
        self.label = label
        self.name = name
        self.transaction_date = transaction_date
        self.status = status
        self.total = total
        self.detail_medicine = detail_medicine
        self.detail_consultation = detail_consultation
        self.rating = rating
    }
}

class detailconsul {
    var modelhistoryclinic : modelhistoryclinic
    var doctor :Detaildokter
    var patient :ModelProfile
    var consultation_id : String
    var doctor_note:doctor_note
    var spa : Bool
    var prescription : prescription
    init(
        doctor :Detaildokter,
        patient :ModelProfile,
        consultation_id:String,
         doctor_note:doctor_note,
         spa : Bool,
         prescription : prescription,
        modelhistoryclinic : modelhistoryclinic
    ) {
        self.doctor = doctor
        self.patient = patient
        self.consultation_id = consultation_id
        self.doctor_note = doctor_note
        self.spa = spa
        self.prescription = prescription
        self.modelhistoryclinic = modelhistoryclinic
    }
    
    
}

struct modelhistoryclinic {
    var address,image,name : String
}


class prescription {
    
    
    var id,consultation_id,prescription_number,order_status,administration_fee,discount_percent,discount,total,note,status,created_at,updated_at,expires :String
    
    init(id:String,consultation_id:String,prescription_number:String,order_status:String,administration_fee:String,discount_percent:String,discount:String,total:String,note:String,status:String,created_at:String,updated_at:String,expires :String) {
        self.id = id
        self.consultation_id = consultation_id
        self.prescription_number = prescription_number
        self.order_status = order_status
        self.administration_fee = administration_fee
        self.discount_percent = discount_percent
        self.discount = discount
        self.total = total
        self.note = note
        self.status = status
        self.created_at = created_at
        self.updated_at = updated_at
        self.expires = expires
    }
}
class doctor_note {
    var note,next_schedule : String
    init(note:String,next_schedule:String) {
        self.note = note
        self.next_schedule = next_schedule
    }
}

struct detailobattraking {
    var slug,name,unit,price,qty,prescription_id : String
}

struct ordertrackingtransaksimodel {
    
    
    var medicines: [detailobattraking]
    var order_date,order_status,consignee,phone_number,address,note,payment_name,payment_status,courier,invoice,total_order,shipping_fee,service_fee,total : String
    var voucher_amount : Int
    
  
}





struct keluhanorderobat {
    var desc,image_complain,reason_solved,order_status,order_date:String
    var images,complain_type_name : [String]
    var detail :[detailobattraking]
    var total,voucher_amount : String
    var namaapotek,alamatapotek,gambarapotek : String
    

}


