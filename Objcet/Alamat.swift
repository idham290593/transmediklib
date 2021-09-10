//
//  Alamat.swift
//  transmedik
//
//  Created by Idham Kurniawan on 16/08/21.
//


import UIKit
import Alamofire
import SwiftyJSON

class Address: NSObject {
    
    
    func getaddress(token:String,complited: @escaping([AlamatModel]?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        
        
        let url = "\(AppSettings.Url)patient-address"
        var alamat :[AlamatModel] = []
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        if  json["data"].count == 0 {
                            return complited(nil)
                        }
                        json["data"].array?.forEach({ (data) in
                            alamat.append(AlamatModel(address: data["address"].stringValue, address_type: data["address_type"].stringValue, id: data["id"].stringValue, map_lat: data["map_lat"].stringValue, map_lng: data["map_lng"].stringValue, note: data["note"].stringValue, patient_id: data["patient_id"].stringValue))
                        })
                        complited(alamat)
                        
                    }else{
                        complited(nil)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(nil)
                }
        }
        
    }
    
    
    func addaddress(data:AlamatModel ,token:String,complited: @escaping()->()){
        

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param : Parameters = [
            
            "address_type": data.address_type,
            "address": data.address,
            "map_lat": data.map_lat,
            "map_lng": data.map_lng,
            "note" : data.note,
            
        ]
        
        
        
        let url = "\(AppSettings.Url)patient-address"
        
        
        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        complited()
                        
                    }else{
                        complited()
                        
                    }
                    print(value)
                case let .failure(error):
                    complited()
                }
                
                
        }
        
    }
    
    func updateaddress(data: AlamatModel ,uuid :String ,token:String,complited: @escaping()->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let param : Parameters = [
            
            "address_type": data.address_type,
            "address": data.address,
            "id" : data.id,
            "map_lat": data.map_lat,
            "map_lng": data.map_lng,
            "note" : data.note,
            
        ]
        
        
        
        let url = "\(AppSettings.Url)patient-address/\(data.id)"
        
        
        AF.request(url, method: .put, parameters:  param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        complited()
                        
                    }else{
                        complited()
                        
                    }
                    print(value)
                case let .failure(error):
                    complited()
                }
                
                
        }
        
    }
    
    
    func deleteaddress(token:String,id:String ,complited: @escaping(Bool)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        
        
        let url = "\(AppSettings.Url)patient-address/\(id)"
        var alamat :[AlamatModel] = []
        
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
                    print(value)
                case let .failure(error):
                    complited(false)
                }
                
                
        }
        
    }
    
}
