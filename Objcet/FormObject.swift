//
//  FormObject.swift
//  transmedik
//
//  Created by Idham Kurniawan on 08/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

struct answers : Codable {
    var answer,id,question: String
}

class FormObject: NSObject {
    
    
    func getformjawaban(token: String,id : String,completion: @escaping([answers]?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)medical-form-patients/\(id)"
        
        
        AF.request(url, method: .get,
                   encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    
                    if json["code"].stringValue == "200"{
                       
                        let datajson:String = "\(json["data"]["answers"].rawString()!)"
                        let data = datajson.data(using: .utf8)!
                        do {
                            let found = try JSONDecoder().decode([answers].self, from: data)
                            
                            completion(found)
                        } catch {
                            print("error=============")
                        }
                    } else{
                        completion(nil)
                    }
                    
                   
                case let .failure(error):
                   
                    
                    completion(nil)
                }
                
            }
    }
    
    func getform(token: String,id:String , spesialist : String, completion: @escaping([listformmodel],String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param : Parameters = [
            "medical_facility_id" : id,
            "specialist_id" : spesialist
        ]
        
        let url = "\(AppSettings.Url)medical-facility-form"
        
        var values : [listformmodel] = []
        print(url)
        print(param)
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("gethistorybalance")
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["messages"].stringValue == "Unauthenticated."{
                        return  completion(values,json["messages"].stringValue)
                    }
                    if json["data"].count == 0{
                        return  completion(values,"")
                    }
                    json["data"].array?.forEach({ (data) in
                        if data["input_type"].stringValue == "checkbox" || data["input_type"].stringValue == "radio"{
                            
                            var detail : [listvalue] = []
                            
                            data["detail"].array?.forEach({ (detailtmp) in
                                
                                detail.append(listvalue(id: detailtmp["id"].stringValue, label:  detailtmp["label"].stringValue, check: false))
                                
                                if detail.count == data["detail"].count{
                                    
                                    values.append(listformmodel(id: data["id"].stringValue, question: data["question_text"].stringValue, component: data["component_type"].stringValue, input_type: data["input_type"].stringValue, required: data["required"].intValue == 1 ? true : false, issingle: data["is_single"].intValue == 1 ? true : false, detail: detail, jawaban: ""))
   
                                    if values.count == json["data"].count {
                                        completion(values,"")
                                    }
                                    
                                }
                            })
                            
                        }else{
                            values.append(listformmodel(id: data["id"].stringValue, question: data["question_text"].stringValue, component: data["component_type"].stringValue, input_type: data["input_type"].stringValue, required: data["required"].intValue == 1 ? true : false, issingle: data["is_single"].intValue == 1 ? true : false, detail: nil, jawaban: ""))
                            
                            if values.count == json["data"].count {
                                completion(values,"")
                            }
                            
                        }
                    })
                    
                    
                    print(value)
                case let .failure(error):
                    print(error)
                    
                    completion(values,"Terjadi masalah pada server")
                    
                }
                
            }
    }
}
