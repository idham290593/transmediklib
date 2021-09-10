//
//  FaskesObject.swift
//  transmedik
//
//  Created by Idham Kurniawan on 08/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class Fasilitaskesehatan: NSObject {
  
    
    func url(token:String,url : String , complited: @escaping([Fasilitaskesehatanmodel]?,String?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
   
       
        
         var tmp :[Fasilitaskesehatanmodel] = []
        AF.request(url, method: .post,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        print("responsi")
                        print(json["data"]["data"].count)
                        json["data"]["data"].array?.forEach({ (data) in
                            tmp.append(Fasilitaskesehatanmodel(id: data["id"].stringValue, name: data["name"].stringValue, province_id: data["province_id"].stringValue, province: data["province"].stringValue, regency_id: data["regency_id"].stringValue, regency: data["regency"].stringValue, address: data["address"].stringValue, lat: data["map_lat"].doubleValue, long: data["map_lng"].doubleValue, image: data["image"].stringValue, medical_form: data["medical_form"].boolValue))
                            if tmp.count == json["data"]["data"].count{
                                complited(tmp,json["data"]["next_page_url"].stringValue)

                            }
                        })
                    }else{
                        complited(tmp,nil)
                        
                    }
                case let .failure(error):
                    complited(tmp,nil)
                }
                
                
        }
        
    }
    
    func ordersearch(token:String,search : String , complited: @escaping([Fasilitaskesehatanmodel]?,String?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
   
        let url = "\(AppSettings.Url)medical-facilities-public?search=\(search)&per_page=15"
        print(url)
        
         var tmp :[Fasilitaskesehatanmodel] = []
        AF.request(url, method: .post,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        print("responsi")
                        print(json["data"]["data"].count)
                        json["data"]["data"].array?.forEach({ (data) in
                            tmp.append(Fasilitaskesehatanmodel(id: data["id"].stringValue, name: data["name"].stringValue, province_id: data["province_id"].stringValue, province: data["province"].stringValue, regency_id: data["regency_id"].stringValue, regency: data["regency"].stringValue, address: data["address"].stringValue, lat: data["map_lat"].doubleValue, long: data["map_lng"].doubleValue, image: data["image"].stringValue, medical_form: data["medical_form"].boolValue))
                            if tmp.count == json["data"]["data"].count{
                                complited(tmp,json["data"]["next_page_url"].stringValue)

                            }
                        })
                    }else{
                        complited(tmp,nil)
                        
                    }
                case let .failure(error):
                    complited(tmp,nil)
                }
                
                
        }
        
    }
    
    
    func getfaskesclosein(token:String,long:Double,lat:Double,complited: @escaping([Fasilitaskesehatanmodel]?,String?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
   
        let url = "\(AppSettings.Url)medical-facilities-closein?map_lng=\(long)&map_lat=\(lat)"
        print(url)
        
         var tmp :[Fasilitaskesehatanmodel] = []
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["messages"].stringValue == "Unauthenticated."{
                        complited(tmp,json["messages"].stringValue)
                    }
                    
                    if json["message"].stringValue == "Unauthenticated."{
                        complited(tmp,json["message"].stringValue)
                    }
                    
                    
                    if json["code"].stringValue == "200"{
                       
                        json["data"].array?.forEach({ (data) in
                            tmp.append(Fasilitaskesehatanmodel(id: data["id"].stringValue, name: data["name"].stringValue, province_id: data["province_id"].stringValue, province: data["province"].stringValue, regency_id: data["regency_id"].stringValue, regency: data["regency"].stringValue, address: data["address"].stringValue, lat: data["map_lat"].doubleValue, long: data["map_lng"].doubleValue, image: data["image"].stringValue, medical_form: data["medical_form"].boolValue))
                            if tmp.count == json["data"].count{
                                complited(tmp,"null")

                            }
                        })
                    }else{
                        complited(tmp,nil)
                        
                    }
                case let .failure(error):
                    complited(tmp,nil)
                }
                
                
        }
        
    }
    func order(token:String,complited: @escaping([Fasilitaskesehatanmodel]?,String?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
   
        let url = "\(AppSettings.Url)medical-facilities-public?per_page=15"
        print(url)
        
         var tmp :[Fasilitaskesehatanmodel] = []
        AF.request(url, method: .post,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["messages"].stringValue == "Unauthenticated."{
                        complited(tmp,json["messages"].stringValue)
                    }
                    
                    if json["message"].stringValue == "Unauthenticated."{
                        complited(tmp,json["message"].stringValue)
                    }
                    
                    
                    if json["code"].stringValue == "200"{
                        print("responsi")
                        print(json["data"]["data"].count)
                        json["data"]["data"].array?.forEach({ (data) in
                            tmp.append(Fasilitaskesehatanmodel(id: data["id"].stringValue, name: data["name"].stringValue, province_id: data["province_id"].stringValue, province: data["province"].stringValue, regency_id: data["regency_id"].stringValue, regency: data["regency"].stringValue, address: data["address"].stringValue, lat: data["map_lat"].doubleValue, long: data["map_lng"].doubleValue, image: data["image"].stringValue, medical_form: data["medical_form"].boolValue))
                            if tmp.count == json["data"]["data"].count{
                                complited(tmp,json["data"]["next_page_url"].stringValue)

                            }
                        })
                    }else{
                        complited(tmp,nil)
                        
                    }
                case let .failure(error):
                    complited(tmp,nil)
                }
                
                
        }
        
    }
}
