//
//  SpecialistObject.swift
//  transmedik
//
//  Created by Idham Kurniawan on 08/07/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class Specialist: NSObject {
    
    
    
    
    func getspesialisklinik(token:String,id:String ,complited: @escaping([Tanyadokter]?,String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)specialists-medical-facility/\(id)"
        print(url)
       
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        var list : [Tanyadokter] = []
                        json["data"].array?.forEach({ (data) in
                            list.append(Tanyadokter(id: data["id"].stringValue, create:  "", image:  data["image"].stringValue, name:  data["name"].stringValue, slug:  data["slug"].stringValue))
                        })
                        complited(list,"")
                    }else{
                        complited(nil,json["messages"].stringValue)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(nil,"")
                }
                
                
            }
        
    }
    
    
    func getfilter(token:String,complited: @escaping(filterdokter?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)parameter-filter-doctor"
        print(url)
        var exp : [filterdokterdetail] = []
        var rate : [filterdokterdetail] = []
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        json["data"]["experience"].array?.forEach({ (tanya) in
                            exp.append(filterdokterdetail(name: tanya["description"].stringValue, symbol: tanya["symbol"].stringValue, value: tanya["value"].stringValue, check: false))
                        })
                        
                        
                        
                        json["data"]["rates"].array?.forEach({ (tanya) in
                            rate.append(filterdokterdetail(name: tanya["description"].stringValue, symbol: tanya["symbol"].stringValue, value: tanya["value"].stringValue, check: false))
                        })
                        
                        complited(filterdokter(rates: rate, experince: exp))
                        
                    }else{
                        complited(nil)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(nil)
                }
                
                
            }
        
    }
    func specialist(token:String,complited: @escaping([Tanyadokter]?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)specialists"
        print(url)
        var data : [Tanyadokter] = []
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        json["data"].array?.forEach({ (tanya) in
                            data.append(Tanyadokter(id: tanya["id"].stringValue, create: tanya["created_at"].stringValue, image: tanya["image"].stringValue, name: tanya["name"].stringValue,slug: tanya["slug"].stringValue))
                        })
                        
                        complited(data)
                        
                    }else{
                        complited(nil)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(nil)
                }
                
                
            }
        
    }
    
    //    func specialist1(token:String,id:String,complited: @escaping([Detailtanyadokter]?)->()){
    func specialist1(token:String,id:String,filter : filterdokter?,search : String ,facilityid:String? ,complited: @escaping(Detailtanyadokters?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        var totalexp = 0
        var totalrate = 0
        var exp : [Parameters] = []
        var rates : [Parameters] = []
        if filter != nil {
            for i in filter!.experince{
                if i.check {
                    let dt : Parameters = [ "symbol" : i.symbol,
                                            "value" : i.value ]
                    exp.append(dt)
                    totalexp += 1
                }
            }
            
            for i in filter!.rates{
                if i.check {
                    let dt :Parameters = [
                        "symbol" : i.symbol,
                        "value" : i.value
                    ]
                    rates.append(dt)
                    totalrate += 1
                }
            }
            
        }
        var param : Parameters = [ "search" : search]
        if exp.count > 0{
            param["experience"] = exp
        }
        
        if rates.count > 0{
            param["rates"] = rates
        }
        var url = ""
        if facilityid == nil {
             url = "\(AppSettings.Url)doctor?specialist=\(id)&per_page=15"

        }else{
             url = "\(AppSettings.Url)doctor?specialist=\(id)&per_page=15&medical_facility_id=\(facilityid!)"

        }
        
        print(url)
        print(param)
        
        var dataspesialis : [Newdetailtanyadokter] = []
        
        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("ini respon dari ==>> " + url)
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        if json["data"]["data"].count == 0 {
                            return complited(nil)
                        }
                        json["data"]["data"].array?.forEach({ (data) in
                            dataspesialis.append(Newdetailtanyadokter(description: data["description"].stringValue, device_id: data["device_id"].stringValue, email: data["email"].stringValue, experience: data["experience"].stringValue, full_name: data["full_name"].stringValue, gender: data["gender"].stringValue, no_str: data["no_str"].stringValue, object_id: data["object_id"].stringValue, phone_number: data["phone_number"].stringValue, profile_picture: data["profile_picture"].stringValue, province_id: data["province_id"].stringValue, province_name: data["province_name"].stringValue, rates: data["rates"].stringValue, rating: data["rating"].stringValue, regency_id: data["regency_id"].stringValue, regency_name: data["regency_name"].stringValue, specialist: data["specialist"].stringValue, specialist_slug: data["specialist_slug"].stringValue, start_experience: data["start_experience"].stringValue, status: data["status"].stringValue, status_docter: data["status_docter"].stringValue, uuid: data["uuid"].stringValue, color: data["status_docter"].stringValue == "Online" ? Colors.basicvalue : UIColor.init(rgb: 0x959393), statuscolor: data["status_docter"].stringValue == "Online" ? UIColor.init(rgb: 0x48DF01) : UIColor.init(rgb: 0xE75656) ))
                            
                            if dataspesialis.count == json["data"]["data"].count{
                                complited(Detailtanyadokters(data: dataspesialis, first_page_url: json["data"]["first_page_url"].stringValue, nextpage: json["data"]["next_page_url"].stringValue, last_page_url: json["data"]["last_page_url"].stringValue, prev_page_url: json["data"]["prev_page_url"].stringValue, lastpage: json["data"]["last_page"].intValue, total: json["data"]["total"].intValue))
                            }
                        })
                        
                        
                        
                    }else{
                        complited(nil)
                        
                    }
                    print(value)
                case let .failure(error):
                    print(error)
                    print("eeror cing")
                    complited(nil)
                }
                
                
            }
        
    }
    
    
    func specialistwithurl(token:String,url:String,filter : filterdokter?,complited: @escaping(Detailtanyadokters?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        
        var totalexp = 0
        var totalrate = 0
        var exp : [Parameters] = []
        var rates : [Parameters] = []
        if filter != nil {
            for i in filter!.experince{
                if i.check {
                    let dt : Parameters = [ "symbol" : i.symbol,
                                            "value" : i.value ]
                    exp.append(dt)
                    totalexp += 1
                }
            }
            
            for i in filter!.rates{
                if i.check {
                    let dt :Parameters = [
                        "symbol" : i.symbol,
                        "value" : i.value
                    ]
                    rates.append(dt)
                    totalrate += 1
                }
            }
            
        }
        var param : Parameters = [ "rates" : totalrate == 0 ? "" : rates,
                                   "experince" : totalexp == 0 ? "" : exp]
        
        var dataspesialis : [Newdetailtanyadokter] = []
        
        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        json["data"]["data"].array?.forEach({ (data) in
                            dataspesialis.append(Newdetailtanyadokter(description: data["description"].stringValue, device_id: data["device_id"].stringValue, email: data["email"].stringValue, experience: data["experience"].stringValue, full_name: data["full_name"].stringValue, gender: data["gender"].stringValue, no_str: data["no_str"].stringValue, object_id: data["object_id"].stringValue, phone_number: data["phone_number"].stringValue, profile_picture: data["profile_picture"].stringValue, province_id: data["province_id"].stringValue, province_name: data["province_name"].stringValue, rates: data["rates"].stringValue, rating: data["rating"].stringValue, regency_id: data["regency_id"].stringValue, regency_name: data["regency_name"].stringValue, specialist: data["specialist"].stringValue, specialist_slug: data["specialist_slug"].stringValue, start_experience: data["start_experience"].stringValue, status: data["status"].stringValue, status_docter: data["status_docter"].stringValue, uuid: data["uuid"].stringValue, color: data["status_docter"].stringValue == "Online" ? Colors.basicvalue : UIColor.init(rgb: 0x959393), statuscolor: data["status_docter"].stringValue == "Online" ? UIColor.init(rgb: 0x48DF01) : UIColor.init(rgb: 0xE75656)))
                            
                            if dataspesialis.count == json["data"]["data"].count{
                                complited(Detailtanyadokters(data: dataspesialis, first_page_url: json["data"]["first_page_url"].stringValue, nextpage: json["data"]["next_page_url"].stringValue, last_page_url: json["data"]["last_page_url"].stringValue, prev_page_url: json["data"]["prev_page_url"].stringValue, lastpage: json["data"]["last_page"].intValue, total: json["data"]["total"].intValue))
                            }
                        })
                        
                        
                        
                    }else{
                        complited(nil)
                        
                    }
                    print(value)
                case let .failure(error):
                    print(error)
                    print("eeror cing")
                    complited(nil)
                }
                
                
            }
        
    }
    
}
