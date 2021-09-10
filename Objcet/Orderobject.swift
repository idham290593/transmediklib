//
//  Orderobject.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/08/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import UIKit

struct namesender {
    var email,firstName,lastName,phone : String
 
}

class Orderobject: NSObject {
    
    
    
    func complain(images:UIImage,token:String, id:String ,note: String , keluhan:[keluhanobat] ,complited: @escaping(Bool,String)->()){
        let url = "\(AppSettings.Url)order-complain"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        var datakeluhan = ""
        for index in keluhan{
            if index.check{
                if datakeluhan.count == 0{
                    datakeluhan = "\"\(index.keluhan)\""
                }else{
                    datakeluhan = "\(datakeluhan),\"\(index.keluhan)\""
                }
            }
          
        }
        
        let datakirim = "{\"order_id\": \"\(id)\", \"complain_type\" : [\(datakeluhan)],\"description\": \"\(note)\"}"

print(datakirim)

    
        AF.upload(multipartFormData: { (multipartFormData) in

//            multipartFormData.append(images.jpegData(compressionQuality: 1)!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(UIImageJPEGRepresentation(images, 1)!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(Data(datakirim.data(using: .utf8)!), withName: "data")


        }, to: url ,method: .post, headers: headers).responseJSON { respon in
            print(respon)
            switch respon.result {
            case let .success(value):
                let json = JSON(value)
                if json["code"].stringValue == "200"{
                    complited(true,"success")

                }else{
                    complited(false,json["messages"].stringValue)

                }
            case let .failure(error):
                complited(false,"error server")
            }


        }
        
        
    }
    
    
    
    
    func orderv1(images:[UIImage]?,token:String,pin : String,PaymentId: String , PaymentName: String , data:modelreqorder,complited: @escaping(String)->()){
        let url = "\(AppSettings.Url)orders"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        var temp :[Parameters] = []
        var stt = ""
        for index in data.detail {
            let tmpss =  "{\"name\":\"\(index.name)\",\"price\":\(index.price),\"slug\":\"\(index.slug)\",\"unit\":\"\(index.unit)\",\"qty\":\(index.qty),\"prescription_id\":null}"
            if stt == "" {

                stt = tmpss
            }else{
                stt = "\(stt),\(tmpss)"
            }
            temp.append([
                "name":index.name,
                "price":index.price,
                "slug":index.slug,
                "unit":index.unit,
                "qty":index.qty,
                "prescription_id":nil
            ])

        }
        print("[\(stt)]")
        let param = "{\"map_lat\":\"\(data.lat)\",\"map_lng\":\"\(data.long)\",\"address\":\"\(data.address)\",\"id\" : \(data.id),\"note\":\"\(data.note)\",\"total\":\(data.total),\"voucher\":null,\"voucher_amount\": \(data.voucher_amount),\"medicines\":[\(stt)],\"pin\" : \"\(pin)\",\"payment_id\": \(PaymentId),\"payment_name\" : \"\(PaymentName)\"}"

        print(param)

    
        AF.upload(multipartFormData: { (multipartFormData) in
            if images != nil && images!.count > 0{
                for i in 0..<images!.count{
//                    multipartFormData.append(images![i].jpegData(compressionQuality: 1)!, withName: "images[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    multipartFormData.append(UIImageJPEGRepresentation(images![i], 1)!, withName: "images[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
            }
            multipartFormData.append(Data(param.data(using: .utf8)!), withName: "data")


        }, to: url ,method: .post, headers: headers).responseJSON { respon in
            print(respon)
            switch respon.result {
            case let .success(value):
                let json = JSON(value)
                if json["code"].stringValue == "200"{
                    complited("success")
                    
                }else{
                    complited(json["messages"].stringValue)
                    
                }
            case let .failure(error):
                complited("error server")
            }
            
            
        }
        
        
    }
    
    func order(token:String,pin : String,PaymentId: String , PaymentName: String , data:modelreqorder,complited: @escaping(String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        var temp :[Parameters] = []
        
        for index in data.detail {
            temp.append([
                "name":index.name,
                "price":index.price,
                "slug":index.slug,
                "unit":index.unit,
                "qty":index.qty,
                "prescription_id":""
            ])
        }
        let param :Parameters = [
            "map_lat":"\(data.lat)",
            "map_lng":"\(data.long)",
            "address" : data.address,
            "id" : data.id,
            "note": data.note,
            "total":data.total,
            "voucher":data.vocer,
            "voucher_amount": data.voucher_amount,
            "medicines":temp,
            "pin" : pin,
            "PaymentId": PaymentId,
            "PaymentName" : PaymentName
            
        ]
        let url = "\(AppSettings.Url)orders"
        print(url)
        print(param)
        
        
        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        complited("success")
                        
                    }else{
                        complited(json["messages"].stringValue)
                        
                    }
                case let .failure(error):
                    complited("error server")
                }
                
                
            }
        
    }
    
    
    
    func neworderv1(images:[UIImage]?,token:String,pin : String,PaymentId: String , PaymentName: String , data:modelreqorder , pembayaran : String,valuepembayaran : String,complited: @escaping(String)->()){
        let url = "\(AppSettings.Url)orders"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        var packages = ""
        for index in data.detail {
            let tmpss =  "{\"name\":\"\(index.name)\",\"price\":\(index.price),\"slug\":\"\(index.slug)\",\"unit\":\"\(index.unit)\",\"qty\":\(index.qty),\"prescription_id\":null,\"dimensions\": null}"
            if packages == "" {

                packages = tmpss
            }else{
                packages = "\(packages),\(tmpss)"
            }
            

        }
        
        let origin =  "{\"address\": \"\(data.address)\",\"coordinates\": {\"latitude\": \"\(data.lat)\",\"longitude\": \"\(data.long)\" }}"
        let destination =  "{\"address\": \"\(data.address)\",\"coordinates\": {\"latitude\": \"\(data.lat)\",\"longitude\": \"\(data.long)\" }}"
        let recipient = "{\"email\": \"firdaus@dev.netkromsolution.com\",\"firstName\": \"Firdausam\",\"lastName\": \"-\",\"phone\": \"089123456789\",\"smsEnabled\": true}"
        
       let param = ""


    
        AF.upload(multipartFormData: { (multipartFormData) in
            if images != nil && images!.count > 0{
                for i in 0..<images!.count{
                    //swift 4.2
//                    multipartFormData.append(images![i].jpegData(compressionQuality: 1)!, withName: "images[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    multipartFormData.append(UIImageJPEGRepresentation(images![i], 1)!, withName: "images[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
            }
            multipartFormData.append(Data(param.data(using: .utf8)!), withName: "data")
            multipartFormData.append(Data(valuepembayaran.data(using: .utf8)!), withName: pembayaran)



        }, to: url ,method: .post, headers: headers).responseJSON { respon in
            print(respon)
            switch respon.result {
            case let .success(value):
                let json = JSON(value)
                if json["code"].stringValue == "200"{
                    complited("success")
                    
                }else{
                    complited(json["messages"].stringValue)
                    
                }
            case let .failure(error):
                complited("error server")
            }
            
            
        }
        
        
    }
    
    func checkPayment(token:String ,id : String,complited: @escaping(Bool,String?)->()){
        let url = "\(AppSettings.Url)payment/check-status"
        let param : Parameters = ["trans_merchant_id":id]

        print(url)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        print("parammmmm =>>>>>> \(param)" )

        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
            print(respon)
            switch respon.result {
            case let .success(value):
                let json = JSON(value)
                if json["messages"].stringValue == "Unauthenticated."{
                    complited(false,json["messages"].stringValue)
                }

                if json["code"].stringValue == "200"{
                    if json["data"].boolValue {
                        complited(true,nil)
                    }else{
                        complited(false,nil)
                    }

                }else{
                    complited(false,json["messages"].stringValue )

                }
            case let .failure(error):
                complited(false,"error server")
            }
            
            
        }
        
        
    }
    
    func neworder(token:String,param : String ,complited: @escaping(String,String?,String?)->()){
        let url = "\(AppSettings.Url)orders"

        print(url)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        

        AF.upload(multipartFormData: { (multipartFormData) in
           
            multipartFormData.append(Data(param.data(using: .utf8)!), withName: "data")



        }, to: url ,method: .post, headers: headers).responseJSON { respon in
            print(respon)
            switch respon.result {
            case let .success(value):
                let json = JSON(value)
                if json["messages"].stringValue == "Unauthenticated."{
                    complited(json["messages"].stringValue,nil,nil)
                }
                
                if json["code"].stringValue == "200"{
                    complited("success",json["data"]["trans_merchant_id"].stringValue,json["data"]["url"].stringValue)
                    
                }else{
                    complited(json["messages"].stringValue,nil,nil)
                    
                }
            case let .failure(error):
                complited("error server",nil,nil)
            }
            
            
        }
        
        
    }
    
    
}
