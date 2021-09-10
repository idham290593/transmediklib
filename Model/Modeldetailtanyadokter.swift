//
//  Modeldetailtanyadokter.swift
//  Pasien
//
//  Created by Idham on 05/10/20.
//  Copyright © 2020 idham. All rights reserved.
//

import Foundation
import UIKit
class Detailtanyadokter {
    var image,name,uuid_doctor,nama_dokter,spesialis,email,tarif_dokter,voucher,lama_pengalaman,nomor_str,rating,device_id,object_id,status_docter,description,alumnistring ,tempatstring:String
    var tempat_praktik:[Detailtanyadoktertepat_praktek]
    var alumni : [Detailtanyadokteralmuni]
  
    
    
    
    
    init(
        image :String,
        name:String,
        uuid_doctor :String ,
        nama_dokter:String,
        spesialis:String,
        email :String ,
        tarif_dokter :String ,
        voucher :String ,
        lama_pengalaman:String ,
        nomor_str:String ,
        rating :String,
        device_id :String ,
        object_id :String ,
        status_docter:String ,
        description :String,
        alumnistring:String,
        tempatstring:String,
        tempat_praktik : [Detailtanyadoktertepat_praktek],
        alumni:[Detailtanyadokteralmuni]
    ) {
        self.image  = image
        self.name = name
        self.uuid_doctor = uuid_doctor
        self.nama_dokter = nama_dokter
        self.spesialis = spesialis
        self.email = email
        self.tarif_dokter = tarif_dokter
        self.voucher  = voucher
        self.lama_pengalaman = lama_pengalaman
        self.nomor_str = nomor_str
        self.rating = rating
        self.alumnistring = alumnistring
        self.tempatstring = tempatstring
        self.device_id  = device_id
        self.object_id = object_id
        self.status_docter = status_docter
        self.description = description
        self.tempat_praktik = tempat_praktik
        self.alumni = alumni    }
}

class Detailtanyadokteralmuni{
    var id,dokters_id,education,graduation_year,create,updated_at : String
    
    init(id: String,dokters_id: String,education: String,graduation_year: String,create : String,updated_at:String) {
        self.id = id
        self.dokters_id = dokters_id
        self.education = education
        self.graduation_year = graduation_year
        self.create = create
        self.updated_at = updated_at
    }
}

class Detailtanyadoktertepat_praktek{
    var id,dokters_id,facility_name,province_id,province_name,regency_id,regency_name,create : String
    
    init(id: String,dokters_id: String,facility_name: String,province_id: String,province_name : String ,regency_id:String,regency_name:String,create : String) {
        self.id = id
        self.dokters_id = dokters_id
        self.facility_name = facility_name
        self.province_id = province_id
        self.regency_id = regency_id
        self.province_name = province_name
        self.regency_name = regency_name
        self.create = create
    }
}



class Detaildokter {
   var description,device_id,email,experience,full_name,gender,no_str,object_id,phone_number,profile_picture,province_id,province_name,rates,rating ,regency_id,regency_name,specialist,specialist_slug,start_experience,status,status_docter,uuid : String
    var facilities:[Detailtanyadoktertepat_praktek]
    var educations : [Detailtanyadokteralmuni]
    var edustring,facilitiesstring : String
    init(
       description: String,device_id: String,email: String,experience: String,full_name: String,gender: String,no_str: String,object_id: String,phone_number: String,
       profile_picture: String,province_id: String,province_name: String,rates: String,rating : String ,regency_id : String,regency_name: String,specialist: String,specialist_slug: String,start_experience: String,status: String,status_docter: String,uuid : String, facilities:[Detailtanyadoktertepat_praktek],educations : [Detailtanyadokteralmuni],edustring:String,facilitiesstring : String
    
    ) {
        
        self.description = description
        self.device_id = device_id
        self.email = email
        self.experience = experience
        self.full_name = full_name
        self.gender = gender
        self.no_str = no_str
        self.object_id = object_id
        self.phone_number = phone_number
        self.profile_picture = profile_picture
        self.province_id = province_id
        self.province_name = province_name
        self.rates = rates
        self.rating = rating
        self.regency_id = regency_id
        self.regency_name = regency_name
        self.specialist = specialist
        self.specialist_slug = specialist_slug
        self.start_experience = start_experience
        self.status = status
        self.status_docter = status_docter
        self.uuid = uuid
        self.facilities = facilities
        self.educations = educations
        self.edustring = edustring
        self.facilitiesstring  = facilitiesstring
 
   }
}



class Newdetailtanyadokter {
   var description,device_id,email,experience,full_name,gender,no_str,object_id,phone_number,profile_picture,province_id,province_name,rates,rating ,regency_id,regency_name,specialist,specialist_slug,start_experience,status,status_docter,uuid : String
    var color,statuscolor: UIColor
    
    init(
       description: String,device_id: String,email: String,experience: String,full_name: String,gender: String,no_str: String,object_id: String,phone_number: String,
        profile_picture: String,province_id: String,province_name: String,rates: String,rating : String ,regency_id : String,regency_name: String,specialist: String,specialist_slug: String,start_experience: String,status: String,status_docter: String,uuid : String, color : UIColor,statuscolor : UIColor
    
    ) {
        
        self.description = description
        self.device_id = device_id
        self.email = email
        self.experience = experience
        self.full_name = full_name
        self.gender = gender
        self.no_str = no_str
        self.object_id = object_id
        self.phone_number = phone_number
        self.profile_picture = profile_picture
        self.province_id = province_id
        self.province_name = province_name
        self.rates = rates
        self.rating = rating
        self.regency_id = regency_id
        self.regency_name = regency_name
        self.specialist = specialist
        self.specialist_slug = specialist_slug
        self.start_experience = start_experience
        self.status = status
        self.status_docter = status_docter
        self.uuid = uuid
        self.color = color
        self.statuscolor = statuscolor
 
   }
}


struct Detailtanyadokters {
    var data : [Newdetailtanyadokter]
    var first_page_url,nextpage,last_page_url,prev_page_url :String
    var lastpage,total :Int
   
    
}
//Newdetailtanyadokter
