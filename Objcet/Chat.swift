//
//  Chat.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class Chat: NSObject {
    
    
    
    
    func sendimagechat(images:UIImage,token : String,consul : String ,complited: @escaping(Bool,String?,String?)->()){
        let url = "\(AppSettings.Url)chat/upload"

        print(url)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
//
        AF.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(images.jpegData(compressionQuality: 1)!, withName: "file", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(UIImageJPEGRepresentation(images, 1)!, withName: "file", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            
            multipartFormData.append(Data(consul.data(using: .utf8)!), withName: "consultation_id")

        }, to: url ,method: .post,headers:  headers).responseJSON { respon in
            print(respon)
            switch respon.result {
            case let .success(value):
                let json = JSON(value)
                if json["code"].stringValue == "200"{
                    complited(true,json["messages"].stringValue,json["data"].stringValue)
                    
                }else{
                    complited(false,json["messages"].stringValue,nil)
                    
                }
            case let .failure(error):
                complited(false,"error server",nil)
            }
            
            
        }
        
        
    }
    
    func confirmConsult(token: String, uuid_patient : String, uuid_doctor: String, email_patient : String, email_doctor: String, rates: Int,voucher_amount:String,voucher:String, pin: String,payment_id:String,payment_name: String,keluhan:String,completion: @escaping(ConsultationPostModel?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)consultation"
        
        print(url)
        
        AF.request(url, method: .post,
                   parameters: ["uuid_patient" : uuid_patient,
                                "email_patient" : email_patient,
                                "uuid_doctor" : uuid_doctor,
                                "email_doctor" : email_doctor,
                                "rates" : rates,
                                "complaint" : keluhan,
                                "payment_name" : payment_name,
                                "payment_id" : payment_id,
                                "pin" : pin,
                                "voucher" : voucher,
                                "voucher_amount": voucher_amount
                                
                   ],
                   encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    
                    if json["code"].stringValue == "200"{
                        let decoder = JSONDecoder()
                        do {
                            let result = try decoder.decode(ConsultationPostModel.self, from: json["data"].rawData())
                            completion(result)
                        } catch let error {
                            print(error)
                            completion(nil)
                        }
                    } else{
                        completion(nil)
                    }
                    
                    print(value)
                case let .failure(error):
                    print(error)
                    
                    completion(nil)
                }
                
            }
    }
    
    
    func checkkonsul(token: String,completion: @escaping(ConsultationPostModel?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)check-consultation-available"
        
        print(url)
        
        AF.request(url, method: .get,
                   encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    
                    if json["code"].stringValue == "200"{
                        let decoder = JSONDecoder()
                        do {
                            let result = try decoder.decode(ConsultationPostModel.self, from: json["data"].rawData())
                            completion(result)
                        } catch let error {
                            print(error)
                            completion(nil)
                        }
                    } else{
                        completion(nil)
                    }
                    
                    print(value)
                case let .failure(error):
                    print(error)
                    
                    completion(nil)
                }
                
            }
    }
    
    
    func confirmConsultclinicgratis(token: String, uuid_patient : String, uuid_doctor: String, email_patient : String, email_doctor: String, rates: Int,jawab : String,medical_facility_id:String,voucher_amount:String,voucher:String, pin: String,payment_id:String,payment_name: String,completion: @escaping(ConsultationPostModel?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)consultation"
        let param : Parameters = ["uuid_patient" : uuid_patient,
                                  "email_patient" : email_patient,
                                  "uuid_doctor" : uuid_doctor,
                                  "email_doctor" : email_doctor,
                                  "rates" : rates,
                                  "complaint" : "",
                                  "payment_name" : payment_name,
                                  "payment_id" : payment_id,
                                  "pin" : pin,
                                  "voucher" : voucher,
                                  "voucher_amount": voucher_amount,
                                  "medical_facility_id" : medical_facility_id,
                                  "answers" : jawab
                                  
                     ]
        print(url)
        print(param)
        
        AF.request(url, method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    
                    if json["code"].stringValue == "200"{
                        let decoder = JSONDecoder()
                        do {
                            let result = try decoder.decode(ConsultationPostModel.self, from: json["data"].rawData())
                            completion(result)
                        } catch let error {
                            print(error)
                            completion(nil)
                        }
                    } else{
                        completion(nil)
                    }
                    
                    print(value)
                case let .failure(error):
                    print(error)
                    
                    completion(nil)
                }
                
            }
    }
    
    
    func confirmConsultclinic(token: String, uuid_patient : String, uuid_doctor: String, email_patient : String, email_doctor: String, rates: Int,jawab : String,medical_facility_id:String,voucher_amount:String,voucher:String, pin: String,payment_id:String,payment_name: String,param : Parameters?,trans_merchant_id:String,completion: @escaping(ConsultationPostModel?,String?,String?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        var transmerchen  = "null"
        if trans_merchant_id != "" {
            transmerchen = trans_merchant_id
        }
        
     
        
        
        let url = "\(AppSettings.Url)consultation-clinic"
        var  params : Parameters = ["":""]
        if param != nil {
            params = [
                                     "uuid_patient" : uuid_patient,
                                     "email_patient" : email_patient,
                                     "uuid_doctor" : uuid_doctor,
                                     "email_doctor" : email_doctor,
                                     "rates" : String(rates),
                                     "complaint" : "",
                                     "payment_name" : payment_name,
                                     "payment_id" : payment_id,
                                     "pin" : pin,
                                     "voucher" : voucher,
                                     "voucher_amount": voucher_amount,
                                     "medical_facility_id" : medical_facility_id,
                                     "answers" : jawab,
                                     "doku" : param!,
                                     "trans_merchant_id" : transmerchen
                                     
                        ]

        }else{
            params = [
                                     "uuid_patient" : uuid_patient,
                                     "email_patient" : email_patient,
                                     "uuid_doctor" : uuid_doctor,
                                     "email_doctor" : email_doctor,
                                     "rates" : String(rates),
                                     "complaint" : "",
                                     "payment_name" : payment_name,
                                     "payment_id" : payment_id,
                                     "pin" : pin,
                                     "voucher" : voucher,
                                     "voucher_amount": voucher_amount,
                                     "medical_facility_id" : medical_facility_id,
                                     "answers" : jawab,
                                     "trans_merchant_id" : transmerchen
                                     
                        ]

        }
        

        print(url)
        print(params)
        print(headers)
        
        
        AF.request(url, method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    
                    if json["code"].stringValue == "200"{
                        let decoder = JSONDecoder()
                        do {
                            let url  = json["data"]["url"].stringValue
                            let merchant_id = json["data"]["trans_merchant_id"].stringValue
                            let result = try decoder.decode(ConsultationPostModel.self, from: json["data"].rawData())
                            print(url)
                            
                            completion(result,merchant_id,url)
                        } catch let error {
                            print(error)
                            completion(nil,nil,nil)
                        }
                    } else{
                        completion(nil,nil,nil)
                    }
                    
                    print(value)
                case let .failure(error):
                    print(error)
                    
                    completion(nil,nil,nil)
                }
                
            }
    }
    
    func statusConsult(token: String, status : String, consultation_id: Int, completion: @escaping(Bool?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)consultation/\(consultation_id)"
        
        print(url)
        print(consultation_id)
        print("status =>> " + status)
        
        AF.request(url, method: .put,
                   parameters: ["status" : status
                   ],
                   encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    
                    if json["code"].stringValue == "200"{
                        completion(true)
                    } else{
                        completion(false)
                    }
                    
                    print(value)
                case let .failure(error):
                    print(error)
                    
                    completion(false)
                }
                
            }
    }
    
}
