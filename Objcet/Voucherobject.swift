//
//  Voucherobject.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class Voucherobject: NSObject {
    
    
    
    func getvoucher(token:String,code :String , type:Int,complited: @escaping(Bool,String,ModelVoucer?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        let param: Parameters = [
            "transaction_type" : type ,
            "voucher_code": code ,
            
        ]
        
        let url = "\(AppSettings.Url)voucher-exist"
        print(url)
        
        var tmp :[ModelHistories] = []
        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200" && json["messages"].stringValue != "Kode voucher tidak tersedia."{
                        let temp = ModelVoucer(code: json["data"]["code"].stringValue, name: json["data"]["name"].stringValue, slug: json["data"]["slug"].stringValue, type: json["data"]["type"].stringValue, nominal: json["data"]["nominal"].intValue, quota: json["data"]["quota"].intValue, status: json["data"]["status"].stringValue, transaksitype: json["data"]["transaksitype"].stringValue, spesialist: json["data"]["spesialist"].stringValue, spesialist_name: json["data"]["spesialist_name"].stringValue, image: json["data"]["image"].stringValue)
                        complited(true,"",temp)
                    }else{
                        complited(false,json["messages"].stringValue,nil)
                        
                    }
                case let .failure(error):
                    complited(false,"fatalerror",nil)
                    
                }
                
                
        }
        
    }
}
