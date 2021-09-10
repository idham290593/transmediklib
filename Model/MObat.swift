//
//  MObat.swift
//  Pasien
//
//  Created by Idham on 08/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

struct Obats {
    var data : [newmodelobat]
    var first_page_url,nextpage,last_page_url,prev_page_url :String
    var lastpage,total :Int
   
    
}


class  ModelObat {
    var id,name,image : String
    init(id:String , name: String,image : String) {
        self.id = id
        self.name = name
        self.image = image
    }
}

class Modeldetailcategoriesobat {
    var id,name,medicine_classification_id,medicine_category_id,unit,unit_small,bbpom_reg,status,image : String
    
    var  medicine_type,netto,max_prices,min_prices,beli: Int
    init(id: String,
         name: String,
         medicine_classification_id : String,
         medicine_category_id : String,
         unit : String,
         unit_small : String,
         netto : Int,
         bbpom_reg : String,
         min_prices : Int,
         max_prices : Int,
         status : String ,
         medicine_type : Int,
         beli:Int,
         image:String) {
        
        self.id = id
        self.name = name
        self.medicine_type = medicine_type
        self.netto = netto
        self.max_prices = max_prices
        self.min_prices = min_prices
        self.medicine_classification_id  = medicine_classification_id
        self.medicine_category_id = medicine_category_id
        self.unit = unit
        self.image = image
        self.unit_small = unit_small
        self.bbpom_reg = bbpom_reg
        self.status = status
        self.beli = beli
        
    }
    
}


class newmodelobat{
    
    var bbpom_reg,category_name,category_slug,classification_name,classification_slug,image,unit_small,unit,slug,packaging,name,medicine_type,qty_unit_small :String
    var status :Bool
    var netto,max_prices,min_prices : Int
    var description:[hashs]
    
    init(bbpom_reg :String,category_name :String,category_slug :String,classification_name :String,classification_slug :String,image :String,unit_small :String,unit :String,slug :String,packaging :String,name :String,medicine_type :String,qty_unit_small :String,status :Bool,netto: Int,max_prices: Int,min_prices : Int,description:[hashs]) {
        self.bbpom_reg = bbpom_reg
        self.category_name = category_name
        self.category_slug = category_slug
        self.classification_name = classification_name
        self.classification_slug = classification_slug
        self.image = image
        self.unit_small = unit_small
        self.unit = unit
        self.slug = slug
        self.packaging = packaging
        self.name = name
        self.medicine_type = medicine_type
        self.qty_unit_small = qty_unit_small
        self.status = status
        self.netto = netto
        self.max_prices = max_prices
        self.min_prices = min_prices
        self.description = description
    }
}
class hashs{
    var key,value : String
    init(key:String,value:String) {
        self.key = key
        self.value = value
    }
}

class descriptionobat{
    var attention,composition,frequency,general_indication,how_to_use :String
    
    init(attention :String,composition :String,frequency :String,general_indication :String,how_to_use :String) {
        self.attention = attention
        self.composition = composition
        self.frequency = frequency
        self.general_indication = general_indication
        self.how_to_use = how_to_use
    }
}


class reqpriceobat{
    var medicine,prescription_id,code:String
    var qty : Int
    init(medicine:String,qty:Int,prescription_id:String,code:String) {
        self.medicine = medicine
        self.qty = qty
        self.prescription_id = prescription_id
        self.code = code
    }
}

class respriceobat {
    var detail : [resdetailobat]
    var id,pharmacy_name,medicine_available,distances:String
    var destination : alamatdelivery
    var phone_number,email,fullname :String
    
    init(id:String,pharmacy_name:String,medicine_available:String,distances:String,detail : [resdetailobat],destination : alamatdelivery,phone_number:String,email:String,fullname:String) {
        self.detail = detail
        self.id = id
        self.pharmacy_name = pharmacy_name
        self.medicine_available = medicine_available
        self.distances = distances
        self.destination = destination
        self.phone_number = phone_number
        self.email = email
        self.fullname = fullname
        
    }
}

struct detailriwayatobat {
    var name,slug,unit,prescription_id : String
    var price,qty: Int
   
}
struct riwayatdetailorder {
    var order_id : Int
    var medicines: [detailriwayatobat]

}

class resdetailobat {
    var slug,name,unit,prescription_id:String
    var available,status:Bool
    var price,stock,qty,min_prices,max_prices,order_id : Int
    init(slug:String,name:String,unit:String,price:Int,stock:Int,qty:Int,available:Bool,min_prices:Int,max_prices:Int,order_id : Int,prescription_id:String,status:Bool)
    {
        self.slug = slug
        self.name = name
        self.unit = unit
        self.available = available
        self.price = price
        self.stock = stock
        self.qty = qty
        self.min_prices = min_prices
        self.max_prices = max_prices
        self.order_id = order_id
        self.prescription_id = prescription_id
        self.status = status
        
        
    }
}
