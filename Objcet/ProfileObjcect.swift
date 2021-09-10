//
//  ProfileObjcect.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class Profile: NSObject {
    
    
    
    func checkpass(pass : String ,token:String,complited: @escaping(String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param: Parameters = [
            "password": pass,
        ]
        
        
        print(headers)
        
        let url = "\(AppSettings.Url)auth/check-password"
       
        
        
        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(param)
                print(url)
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        if json["data"].intValue == 1{
                            complited("success")
                        }else{
                            complited("wrong")
                        }
                        
                        
                    }else{
                        complited(json["messages"].stringValue)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited("error")
                }
                
                
            }
        
    }
    
    func forgotpass(pass : String,phone:String ,complited: @escaping(Bool,String,String)->()){
      
        let param : Parameters = ["password" : pass,
                                  "password_confirmation" : pass,
                                  "phone_number": phone]
        print(param)
        
        let url = "\(AppSettings.Url)forgot-password-by-phone"
        print(url)
        
        
        AF.request(url, method: .post , parameters: param, encoding: JSONEncoding.default)
            .responseJSON { respon in
                print("respon profile")
                
               
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["message"].stringValue == "Unauthenticated."{
                        return  complited(false,json["messages"].stringValue,"")
                    }
                    
                    if json["code"].stringValue == "200"{
                        if let headers = respon.response?.allHeaderFields as? [String: String]{
                              let header = headers["Set-Cookie"]
                            complited(true,json["data"].stringValue,header!)

                           }
                        
                    }else{
                        complited(false,json["messages"].stringValue,"")
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(false,"Server error","")
                }
                
                
            }
        
    }
    
    
    func setpassword(token:String,pass : String,uuid:String ,complited: @escaping(Bool,String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        let param : Parameters = ["password" : pass,
                                  "password_confirmation" : pass,
                                  "uuid": uuid]
        print(param)
        
        let url = "\(AppSettings.Url)profile/reset-password-by-phone"
        print(url)
        
        print(headers)
        
        AF.request(url, method: .put, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("respon profile")
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["message"].stringValue == "Unauthenticated."{
                        return  complited(false,json["message"].stringValue )
                    }
                    
                    if json["code"].stringValue == "200"{
                        
                        complited(true,"")
                        
                    }else{
                        complited(false,json["message"].stringValue )
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(false,"Terjadi kesalahan pada jaringan")
                }
                
                
            }
        
    }
    
    func getprofile(token:String,complited: @escaping(ModelProfile?,String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)profile"
        print(url)
        print(headers)
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("respon profile")
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["message"].stringValue == "Unauthenticated."{
                        return  complited(nil,json["message"].stringValue)
                    }
                    
                    if json["code"].stringValue == "200"{
                        print(json["data"])
                        
                        
                        
                        let datatmp = ModelProfile(uuid: json["data"]["uuid"].stringValue, full_name: json["data"]["full_name"].stringValue, email: json["data"]["email"].stringValue, phone_number: json["data"]["phone_number"].stringValue, gender: json["data"]["gender"].stringValue, status: json["data"]["status"].stringValue, nik: json["data"]["ref"]["nik"].stringValue, no_kk: json["data"]["ref"]["no_kk"].stringValue, dob: json["data"]["ref"]["dob"].stringValue, height: json["data"]["ref"]["body_height"].stringValue, weight: json["data"]["ref"]["body_weight"].stringValue, blood: json["data"]["ref"]["blood_type"].stringValue, relationship: json["data"]["ref"]["relationship"].stringValue, allergy: json["data"]["ref"]["allergy"].stringValue, created_at: json["data"]["created_at"].stringValue, updated_at: json["data"]["updated_at"].stringValue, image: json["data"]["profile_picture"].stringValue)
                        print("=>   \(datatmp.phone_number)")
                        complited(datatmp,"")
                        
                    }else{
                        complited(nil,json["message"].stringValue)
                        
                    }
                case let .failure(error):
                    complited(nil,"Terjadi masalah pada jaringan")
                }
                
                
            }
        
    }
    
    func updatefamily(data: ModelProfile,token:String,complited: @escaping(String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param: Parameters = [
            "uuid": data.uuid,
            "nik": data.nik ,
            "no_kk": data.no_kk,
            "dob": data.dob,
            "email" : data.email,
            "gender":data.gender,
            "body_height":  data.height,
            "body_weight": data.weight,
            "blood_type": data.blood,
            "allergy": data.allergy,
            "phone_number":data.phone_number,
            "relationship": data.relationship,
            "full_name": data.full_name
            
            
        ]
        
        print(param)
        
        let url = "\(AppSettings.Url)family/\(data.uuid)"
        
        
        AF.request(url, method: .put,parameters: param, encoding: JSONEncoding.default, headers: headers)
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
                    print(value)
                case let .failure(error):
                    complited("error")
                }
                
                
            }
        
        
    }
    
    
    func updatenumbertlp(pass: String,tlp : String ,token:String,complited: @escaping(String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param: Parameters = [
            "password": pass,
            "phone_number": tlp
        ]
        
        
        
        let url = "\(AppSettings.Url)profile/phone-number"
        
        
        AF.request(url, method: .put,parameters: param, encoding: JSONEncoding.default, headers: headers)
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
                    print(value)
                case let .failure(error):
                    complited("error")
                }
                
                
            }
        
    }
    
    
    func passwordforemail(number: String ,token:String,complited: @escaping(String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param: Parameters = [
            "email" : number
        ]
        
        
        
        let url = "\(AppSettings.Url)profile/reset-password-by-email"
        
        
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
                    print(value)
                case let .failure(error):
                    complited("error")
                }
                
                
            }
        
    }
    
    func passwordforphone(number: String ,token:String,complited: @escaping(String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param: Parameters = [
            "phone_number" : number
        ]
        
        
        
        let url = "\(AppSettings.Url)profile/reset-password-by-phone"
        
        
        AF.request(url, method: .put,parameters: param, encoding: JSONEncoding.default, headers: headers)
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
                    print(value)
                case let .failure(error):
                    complited("error")
                }
                
                
            }
        
    }
    
    func updatepass(old: String,new : String ,conf:String ,token:String,phone:String ,complited: @escaping(String,Bool)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param: Parameters = [
            "old_password" : old,
               "password" : new,
               "password_confirmation" : conf,
            "phone_number": phone
        ]
        
        
        
        let url = "\(AppSettings.Url)profile/password"
        
        
        AF.request(url, method: .put,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        complited(json["data"].stringValue,true)
                        
                    }else{
                        complited(json["messages"].stringValue,false)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited("error",false)
                }
                
                
            }
        
    }
    
    func updatepin(pin: String,token:String,complited: @escaping(String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param: Parameters = [
          
            "pin": pin
        ]
        
        
        
        let url = "\(AppSettings.Url)auth/pin"
       
        
        
        AF.request(url, method: .put,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(param)
                print(url)
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        complited("success")
                        
                    }else{
                        complited(json["messages"].stringValue)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited("error")
                }
                
                
            }
        
    }
    
    func updateemailuser(pass: String,email : String ,token:String,complited: @escaping(String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param: Parameters = [
            "password": pass,
            "email": email
        ]
        
        
        
        let url = "\(AppSettings.Url)profile/email"
        
        
        AF.request(url, method: .put,parameters: param, encoding: JSONEncoding.default, headers: headers)
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
                    print(value)
                case let .failure(error):
                    complited("error")
                }
                
                
            }
        
    }
    
    
    func updateprofile(data: ModelProfile,token:String,complited: @escaping(String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param: Parameters = [
            "uuid": data.uuid,
            "nik": data.nik ,
            "no_kk": data.no_kk,
            "email" : data.email,
            "dob": data.dob,
            "gender":data.gender,
            "body_height":  data.height,
            "body_weight": data.weight,
            "blood_type": data.blood,
            "allergy": data.allergy,
            "relationship": data.relationship,
            "full_name": data.full_name
        ]
        
        
        
        let url = "\(AppSettings.Url)profile"
        
        
        AF.request(url, method: .put,parameters: param, encoding: JSONEncoding.default, headers: headers)
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
                    print(value)
                case let .failure(error):
                    complited("error")
                }
                
                
            }
        
    }
    
    
    
    func getrelationships(token :String ,complited: @escaping([relation]?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)relationships"
        print(url)
        var datas : [relation] = []
        
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        json["data"].array?.forEach({ (data) in
                            datas.append(relation(name:data["name"].stringValue,slug:data["slug"].stringValue))
                        })
                        complited(datas)
                        
                    }else{
                        complited(nil)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(nil)
                }
                
                
            }
        
    }
    
    
    func getkeluarga(token: String,complited: @escaping([ModelProfile]?,Bool,String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)family"
        var data :[ModelProfile] = []
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("Family")
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["message"].stringValue == "Unauthenticated."{
                        return  complited(nil,false, json["message"].stringValue )
                    }
                    
                    if json["code"].stringValue == "200"{
                        if json["data"].count == 0 {
                            return complited(nil,true,"")
                        }
                        json["data"].array?.forEach({ (keluarga) in
                            
                            data.append(ModelProfile(uuid: keluarga["uuid"].stringValue, full_name: keluarga["full_name"].stringValue, email: keluarga["email"].stringValue, phone_number: keluarga["phone_number"].stringValue, gender: keluarga["gender"].stringValue, status: keluarga["status"].stringValue, nik: keluarga["ref"]["nik"].stringValue, no_kk: keluarga["ref"]["no_kk"].stringValue, dob: keluarga["ref"]["dob"].stringValue, height: keluarga["ref"]["body_height"].stringValue, weight: keluarga["ref"]["body_weight"].stringValue, blood: keluarga["ref"]["blood_type"].stringValue, relationship: keluarga["ref"]["relationship"].stringValue, allergy: keluarga["ref"]["allergy"].stringValue, created_at: keluarga["created_at"].stringValue, updated_at: keluarga["updated_at"].stringValue, image: keluarga["profile_picture"].stringValue))
                        })
                        complited(data,true,"")
                        
                    }else{
                        complited(nil,false, json["message"].stringValue )
                        
                    }
                case let .failure(error):
                    complited(nil,false,"Terjadi kesalahan pada jaringan")
                }
                
                
            }
        
    }
    
    func gantigambar(images:UIImage,token:String,id : String,complited: @escaping(ModelProfile?,String)->()){
        let url = "\(AppSettings.Url)profile/photo"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
  
        AF.upload(multipartFormData: { (multipartFormData) in
         
//            multipartFormData.append(images.jpegData(compressionQuality: 1)!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(UIImageJPEGRepresentation(images, 1)!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            
            
            multipartFormData.append(Data(id.data(using: .utf8)!), withName: "uuid")


        }, to: url ,method: .post, headers: headers).responseJSON { respon in
            print(respon)
            switch respon.result {
            case let .success(value):
                let json = JSON(value)
                if json["code"].stringValue == "200"{
                    
                    let datatmp = ModelProfile(uuid: json["data"]["uuid"].stringValue, full_name: json["data"]["full_name"].stringValue, email: json["data"]["email"].stringValue, phone_number: json["data"]["phone_number"].stringValue, gender: json["data"]["gender"].stringValue, status: json["data"]["status"].stringValue, nik: json["data"]["ref"]["nik"].stringValue, no_kk: json["data"]["ref"]["no_kk"].stringValue, dob: json["data"]["ref"]["dob"].stringValue, height: json["data"]["ref"]["body_height"].stringValue, weight: json["data"]["ref"]["body_weight"].stringValue, blood: json["data"]["ref"]["blood_type"].stringValue, relationship: json["data"]["ref"]["relationship"].stringValue, allergy: json["data"]["ref"]["allergy"].stringValue, created_at: json["data"]["created_at"].stringValue, updated_at: json["data"]["updated_at"].stringValue, image: json["data"]["profile_picture"].stringValue)
                    complited(datatmp,"")

                    
                }else{
                    complited(nil,json["messages"].stringValue)
                    
                }
            case let .failure(error):
                complited(nil,"Server error")
            }
            
            
        }
        
        
    }
    
    
    func tambahkeluarga( data: ModelProfile,token:String,complited: @escaping(String,ModelProfile?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param: Parameters = [
            "email" : data.email ,
            "nik": data.nik ,
            "no_kk": data.no_kk,
            "dob": data.dob,
            "phone_number" : data.phone_number ,
            "gender":data.gender,
            "body_height":  data.height,
            "body_weight": data.weight,
            "blood_type": data.blood,
            "allergy": data.allergy,
            "relationship": data.relationship,
            "full_name": data.full_name
        ]
        
        
        
        let url = "\(AppSettings.Url)family"
        
        
        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        let keluarga = json["data"]
                        complited("success",ModelProfile(uuid: keluarga["uuid"].stringValue, full_name: keluarga["full_name"].stringValue, email: keluarga["email"].stringValue, phone_number: keluarga["phone_number"].stringValue, gender: keluarga["gender"].stringValue, status: keluarga["status"].stringValue, nik: keluarga["ref"]["nik"].stringValue, no_kk: keluarga["ref"]["no_kk"].stringValue, dob: keluarga["ref"]["dob"].stringValue, height: keluarga["ref"]["body_height"].stringValue, weight: keluarga["ref"]["body_weight"].stringValue, blood: keluarga["ref"]["blood_type"].stringValue, relationship: keluarga["ref"]["relationship"].stringValue, allergy: keluarga["ref"]["allergy"].stringValue,created_at : keluarga["created_at"].stringValue, updated_at: keluarga["updated_at"].stringValue, image: keluarga["profile_picture"].stringValue))
                        
                    }else{
                        complited(json["messages"].stringValue,nil)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited("error",nil)
                }
                
                
            }
        
    }
    
    
    
    
    func deletekeluarga(token: String,uuid:String ,complited: @escaping(Bool)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        let url = "\(AppSettings.Url)family/\(uuid)"
        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        complited(true)
                        
                    }else{
                        complited(false)
                        
                    }
                case let .failure(error):
                    complited(false)
                }
                
                
            }
        
    }
    
    
    func tambahkels(images:UIImage,token:String,data : ModelProfile,complited: @escaping(String,ModelProfile?)->()){
        let url = "\(AppSettings.Url)family"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
     
        print(images)
        
        AF.upload(multipartFormData: { (multipartFormData) in
         
//            multipartFormData.append(images.jpegData(compressionQuality: 1)!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            
            multipartFormData.append(UIImageJPEGRepresentation(images, 1)!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(Data(data.blood.data(using: .utf8)!), withName: "blood_type")
            multipartFormData.append(Data(data.height.data(using: .utf8)!), withName: "body_height")
            multipartFormData.append(Data(data.weight.data(using: .utf8)!), withName: "body_weight")
            multipartFormData.append(Data(data.dob.data(using: .utf8)!), withName: "dob")
            multipartFormData.append(Data(data.full_name.data(using: .utf8)!), withName: "full_name")
            multipartFormData.append(Data(data.gender.data(using: .utf8)!), withName: "gender")
            multipartFormData.append(Data(data.nik.data(using: .utf8)!), withName: "nik")
            multipartFormData.append(Data(data.no_kk.data(using: .utf8)!), withName: "no_kk")
            multipartFormData.append(Data(data.email.data(using: .utf8)!), withName: "email")
            multipartFormData.append(Data(data.phone_number.data(using: .utf8)!), withName: "phone_number")
            multipartFormData.append(Data(data.relationship.data(using: .utf8)!), withName: "relationship")


                                                          
        }, to: url ,method: .post, headers: headers).responseJSON { respon in
            print(respon)
            switch respon.result {
            case let .success(value):
                let json = JSON(value)
                if json["code"].stringValue == "200"{
                    let keluarga = json["data"]
                    complited("success",ModelProfile(uuid: keluarga["uuid"].stringValue, full_name: keluarga["full_name"].stringValue, email: keluarga["email"].stringValue, phone_number: keluarga["phone_number"].stringValue, gender: keluarga["gender"].stringValue, status: keluarga["status"].stringValue, nik: keluarga["ref"]["nik"].stringValue, no_kk: keluarga["ref"]["no_kk"].stringValue, dob: keluarga["ref"]["dob"].stringValue, height: keluarga["ref"]["body_height"].stringValue, weight: keluarga["ref"]["body_weight"].stringValue, blood: keluarga["ref"]["blood_type"].stringValue, relationship: keluarga["ref"]["relationship"].stringValue, allergy: keluarga["ref"]["allergy"].stringValue,created_at : keluarga["created_at"].stringValue, updated_at: keluarga["updated_at"].stringValue, image: keluarga["profile_picture"].stringValue))
                    
                }else{
                    complited(json["messages"].stringValue,nil)
                    
                }
            case let .failure(error):
                complited("server error",nil)
            }
            
            
        }
        
        
    }
    
    func changekel(images:UIImage,token:String,data : ModelProfile,complited: @escaping(String,String)->()){
        let url = "\(AppSettings.Url)family/\(data.uuid)"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        print(url)
  
        AF.upload(multipartFormData: { (multipartFormData) in
//
//            multipartFormData.append(images.jpegData(compressionQuality: 1)!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            
               multipartFormData.append(UIImageJPEGRepresentation(images, 1)!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(Data(data.uuid.data(using: .utf8)!), withName: "uuid")
            multipartFormData.append(Data(data.blood.data(using: .utf8)!), withName: "blood_type")
            multipartFormData.append(Data(data.height.data(using: .utf8)!), withName: "body_height")
            multipartFormData.append(Data(data.weight.data(using: .utf8)!), withName: "body_weight")
            multipartFormData.append(Data(data.dob.data(using: .utf8)!), withName: "dob")
            multipartFormData.append(Data(data.full_name.data(using: .utf8)!), withName: "full_name")
            multipartFormData.append(Data(data.gender.data(using: .utf8)!), withName: "gender")
            multipartFormData.append(Data(data.nik.data(using: .utf8)!), withName: "nik")
            multipartFormData.append(Data(data.no_kk.data(using: .utf8)!), withName: "no_kk")
            multipartFormData.append(Data(data.email.data(using: .utf8)!), withName: "email")
            multipartFormData.append(Data(data.phone_number.data(using: .utf8)!), withName: "phone_number")
            multipartFormData.append(Data(data.relationship.data(using: .utf8)!), withName: "relationship")



//            multipartFormData.append(Data(data..data(using: .utf8)!), withName: "device_id")
          
                                                           


        }, to: url ,method: .post, headers: headers).responseJSON { respon in
            print(respon)
            switch respon.result {
            case let .success(value):
                let json = JSON(value)
                if json["code"].stringValue == "200"{
                    
                    let datatmp = ModelProfile(uuid: json["data"]["uuid"].stringValue, full_name: json["data"]["full_name"].stringValue, email: json["data"]["email"].stringValue, phone_number: json["data"]["phone_number"].stringValue, gender: json["data"]["gender"].stringValue, status: json["data"]["status"].stringValue, nik: json["data"]["ref"]["nik"].stringValue, no_kk: json["data"]["ref"]["no_kk"].stringValue, dob: json["data"]["ref"]["dob"].stringValue, height: json["data"]["ref"]["body_height"].stringValue, weight: json["data"]["ref"]["body_weight"].stringValue, blood: json["data"]["ref"]["blood_type"].stringValue, relationship: json["data"]["ref"]["relationship"].stringValue, allergy: json["data"]["ref"]["allergy"].stringValue, created_at: json["data"]["created_at"].stringValue, updated_at: json["data"]["updated_at"].stringValue, image: json["data"]["profile_picture"].stringValue)
                    complited("success",json["data"]["profile_picture"].stringValue)

                    
                }else{
                    complited(json["messages"].stringValue,"")
                    
                }
            case let .failure(error):
                complited("Server error","")
            }
            
            
        }
        
        
    }
    
    func changeprofile(images:UIImage,token:String,data : ModelProfile,complited: @escaping(ModelProfile?,String)->()){
        let url = "\(AppSettings.Url)profile/patient"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
  
        let device = UserDefaults.standard.string(forKey: "DOKTERKELUARGA_FCM_TOKEN") ?? ""
        AF.upload(multipartFormData: { (multipartFormData) in
         
//            multipartFormData.append(images.jpegData(compressionQuality: 1)!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(UIImageJPEGRepresentation(images, 1)!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            
            multipartFormData.append(Data(data.uuid.data(using: .utf8)!), withName: "uuid")
            multipartFormData.append(Data(data.blood.data(using: .utf8)!), withName: "blood_type")
            multipartFormData.append(Data(data.height.data(using: .utf8)!), withName: "body_height")
            multipartFormData.append(Data(data.weight.data(using: .utf8)!), withName: "body_weight")
            multipartFormData.append(Data(data.dob.data(using: .utf8)!), withName: "dob")
            multipartFormData.append(Data(data.full_name.data(using: .utf8)!), withName: "full_name")
            multipartFormData.append(Data(data.gender.data(using: .utf8)!), withName: "gender")
            multipartFormData.append(Data(data.nik.data(using: .utf8)!), withName: "nik")
            multipartFormData.append(Data(data.no_kk.data(using: .utf8)!), withName: "no_kk")
            multipartFormData.append(Data(device.data(using: .utf8)!), withName: "device_id")
            



        }, to: url ,method: .post, headers: headers).responseJSON { respon in
            print(respon)
            switch respon.result {
            case let .success(value):
                let json = JSON(value)
                if json["code"].stringValue == "200"{
                    
                    let datatmp = ModelProfile(uuid: json["data"]["uuid"].stringValue, full_name: json["data"]["full_name"].stringValue, email: json["data"]["email"].stringValue, phone_number: json["data"]["phone_number"].stringValue, gender: json["data"]["gender"].stringValue, status: json["data"]["status"].stringValue, nik: json["data"]["ref"]["nik"].stringValue, no_kk: json["data"]["ref"]["no_kk"].stringValue, dob: json["data"]["ref"]["dob"].stringValue, height: json["data"]["ref"]["body_height"].stringValue, weight: json["data"]["ref"]["body_weight"].stringValue, blood: json["data"]["ref"]["blood_type"].stringValue, relationship: json["data"]["ref"]["relationship"].stringValue, allergy: json["data"]["ref"]["allergy"].stringValue, created_at: json["data"]["created_at"].stringValue, updated_at: json["data"]["updated_at"].stringValue, image: json["data"]["profile_picture"].stringValue)
                    complited(datatmp,"success")

                    
                }else{
                    complited(nil,json["messages"].stringValue)
                    
                }
            case let .failure(error):
                complited(nil,"Server error")
            }
            
            
        }
        
        
    }
    
}
