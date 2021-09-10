//
//  Obat.swift
//  transmedik
//
//  Created by Idham Kurniawan on 28/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class Obat: NSObject {
    
    
    func getresep(token : String, id:String ,complited: @escaping(Bool,[Resepobat]?,String?)->()){
        
        print(token)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
//        let url = "\(api.API())prescription/\(id)"

        let url = "\(AppSettings.Url)prescription/\(id)"
        print(url)
        print(headers)
    
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    print("uuuu")
                    print(json["code"].stringValue)
                    if json["code"].stringValue == "200"{
                        print(1)
                        print(json["success"].intValue)
                        print(json["success"].boolValue)
                        if json["success"].boolValue{
                            print(2)
                            if json["data"]["recipes"].count > 0{
                                var resep = [Resepobat]()
                                json["data"]["recipes"].array?.forEach({ (datas) in
                                  
                                    resep.append(Resepobat(medicines_name: datas["medicines_name"].stringValue, medicine_code_partner: datas["medicine_code_partner"].stringValue, slug: datas["slug"].stringValue, rule: datas["rule"].stringValue, period: datas["period"].stringValue, unit: datas["unit"].stringValue, prescription_id: datas["prescription_id"].stringValue, qty: datas["qty"].intValue, status: datas["status"].boolValue))
    //
                                })
                                print("mausk sini")
                                complited(true,resep,nil)
                            }else{
                                complited(true,nil,json["messages"].stringValue)
                            }
         

                        }else{
                            print("mausk sini2")

                            complited(true,nil,json["messages"].stringValue )

                        }
                     
                        
                        
                    }else{
                        complited(false,nil,json["messages"].stringValue )
                        
                    }
                case let .failure(error):
                    complited(false,nil,"Terjadi masalah pada jaringan")
                    
                }
                
                
        }
        
    }
    
    
    func categoriesobat(token:String,complited: @escaping([ModelObat]?)->()){
        
      let headers: HTTPHeaders = [
                   "Authorization": "Bearer \(token)",
                   "Accept": "application/json",
                   "Content-Type": "application/json"
               ]
        
        let url = "\(AppSettings.Url)medicine-categories"
        print(url)
        var datas : [ModelObat] = []
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        json["data"].array?.forEach({ (data) in
                            let dt = ModelObat(id: data["slug"].stringValue, name: data["name"].stringValue , image: data["image"].stringValue)
                            print(" uyyy===>>> \(dt.name)")
                            datas.append(dt)
                        })
                        
                        complited(datas)
                    }else{
                        complited(nil)
                        
                    }
                case let .failure(error):
                    complited(nil)
                }
                
                
        }
        
    }
    
    
    //    func selectcategories(token:String,id:String,complited: @escaping([Modeldetailcategoriesobat]?)->()){
    //
    //          let headers: HTTPHeaders = [
    //              "Authorization": token,
    //              "Accept": "application/json",
    //              "Content-Type": "application/json"
    //          ]
    //
    //          let url = "\(api.API())medicine/\(id)"
    //          print(url)
    //          var data : [Modeldetailcategoriesobat] = []
    //
    //          AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
    //              .responseJSON { respon in
    //                  switch respon.result {
    //                  case let .success(value):
    //                      let json = JSON(value)
    //                      if json["code"].stringValue == "200"{
    //                          json["data"].array?.forEach({ (tanya) in
    //
    //                            data.append(Modeldetailcategoriesobat(id: tanya["slug"].stringValue, name: tanya["name"].stringValue, medicine_classification_id: tanya["medicine_classification_id"].stringValue, medicine_category_id: tanya["medicine_category_id"].stringValue, unit: tanya["unit"].stringValue, unit_small: tanya["unit_small"].stringValue, netto: tanya["netto"].intValue, bbpom_reg: tanya["bbpom_reg"].stringValue, min_prices: tanya["min_prices"].intValue, max_prices: tanya["max_prices"].intValue, status: tanya["status"].stringValue, medicine_type: tanya["medicine_type"].intValue, beli: 0, image: tanya["image"].stringValue))
    //                          })
    //
    //                          complited(data)
    //
    //                      }else{
    //                          complited(nil)
    //
    //                      }
    //                      print(value)
    //                  case let .failure(error):
    //                      complited(nil)
    //                  }
    //
    //
    //          }
    //
    //      }
    
    
       func searchobats(token:String,search:String,complited: @escaping(Obats?)->()){
           
           let headers: HTTPHeaders = [
                      "Authorization": "Bearer \(token)",
                      "Accept": "application/json",
                      "Content-Type": "application/json"
                  ]
           
        let url = "\(AppSettings.Url)medicine-options?key=\(search.replacingOccurrences(of: " ", with: "%20"))&per_page=10"

        var data : [newmodelobat] = []
           
           AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
               .responseJSON { respon in
                   print(respon)
                   switch respon.result {
                   case let .success(value):
                       let json = JSON(value)
                       if json["code"].stringValue == "200"{
                        if  json["data"]["data"].count == 0{
                            return  complited(nil)
                        }
                        
                           json["data"]["data"].array?.forEach({ (tanya) in
                               var desc :[hashs] = []
                              for (key, values) in tanya["description"] {
                               desc.append(hashs(key: "\(key)", value: values.stringValue))
                               print("key \(key) value2 \(values.stringValue)")

                              }
                               data.append(newmodelobat(bbpom_reg: tanya["bbpom_reg"].stringValue, category_name: tanya["category_name"].stringValue, category_slug: tanya["category_slug"].stringValue, classification_name: tanya["classification_name"].stringValue, classification_slug: tanya["classification_slug"].stringValue, image: tanya["image"].stringValue, unit_small: tanya["unit_small"].stringValue, unit: tanya["unit"].stringValue, slug: tanya["slug"].stringValue, packaging: tanya["packaging"].stringValue, name: tanya["name"].stringValue, medicine_type: tanya["medicine_type"].stringValue, qty_unit_small: tanya["qty_unit_small"].stringValue, status: tanya["status"].boolValue, netto: tanya["netto"].intValue, max_prices: tanya["max_prices"].intValue, min_prices: tanya["min_prices"].intValue, description: desc))
                               if data.count ==  json["data"]["data"].count{
                                   let res = Obats(data: data, first_page_url: json["data"]["first_page_url"].stringValue, nextpage: json["data"]["next_page_url"].stringValue, last_page_url: json["data"]["last_page_url"].stringValue, prev_page_url: json["data"]["prev_page_url"].stringValue, lastpage: json["data"]["last_page"].intValue, total: json["data"]["total"].intValue)
                                   complited(res)
                               }
                                
                           })
                           
                          
                           
                       }else{
                           complited(nil)
                           
                       }
   //                    print(value)
                   case let .failure(error):
                       complited(nil)
                   }
                   
                   
           }
           
       }
    
    
    
    
        func selectcategorieswithurl(token:String,url:String,complited: @escaping(Obats?)->()){
            
            let headers: HTTPHeaders = [
                       "Authorization": "Bearer \(token)",
                       "Accept": "application/json",
                       "Content-Type": "application/json"
                   ]
            
            print(url)
            var data : [newmodelobat] = []
            
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { respon in
                    print(respon)
                    switch respon.result {
                    case let .success(value):
                        let json = JSON(value)
                        if json["code"].stringValue == "200"{
                            json["data"]["data"].array?.forEach({ (tanya) in
                                var desc :[hashs] = []
                               for (key, values) in tanya["description"] {
                                desc.append(hashs(key: "\(key)", value: values.stringValue))
                                print("key \(key) value2 \(values.stringValue)")

                               }
                                data.append(newmodelobat(bbpom_reg: tanya["bbpom_reg"].stringValue, category_name: tanya["category_name"].stringValue, category_slug: tanya["category_slug"].stringValue, classification_name: tanya["classification_name"].stringValue, classification_slug: tanya["classification_slug"].stringValue, image: tanya["image"].stringValue, unit_small: tanya["unit_small"].stringValue, unit: tanya["unit"].stringValue, slug: tanya["slug"].stringValue, packaging: tanya["packaging"].stringValue, name: tanya["name"].stringValue, medicine_type: tanya["medicine_type"].stringValue, qty_unit_small: tanya["qty_unit_small"].stringValue, status: tanya["status"].boolValue, netto: tanya["netto"].intValue, max_prices: tanya["max_prices"].intValue, min_prices: tanya["min_prices"].intValue, description: desc))
                                if data.count ==  json["data"]["data"].count{
                                    let res = Obats(data: data, first_page_url: json["data"]["first_page_url"].stringValue, nextpage: json["data"]["next_page_url"].stringValue, last_page_url: json["data"]["last_page_url"].stringValue, prev_page_url: json["data"]["prev_page_url"].stringValue, lastpage: json["data"]["last_page"].intValue, total: json["data"]["total"].intValue)
                                    complited(res)
                                }
                                 
                            })
                            
                           
                            
                        }else{
                            complited(nil)
                            
                        }
    //                    print(value)
                    case let .failure(error):
                        complited(nil)
                    }
                    
                    
            }
            
        }
    
    func selectcategories(token:String,id:String,complited: @escaping(Obats?)->()){
        
        let headers: HTTPHeaders = [
                   "Authorization": "Bearer \(token)",
                   "Accept": "application/json",
                   "Content-Type": "application/json"
               ]
        
        let url = "\(AppSettings.Url)medicine/\(id)?per_page=10"
        print(url)
        var data : [newmodelobat] = []
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        if json["data"]["data"].count == 0 {
                            return complited(nil)
                        }
                        json["data"]["data"].array?.forEach({ (tanya) in
                            var desc :[hashs] = []
                           for (key, values) in tanya["description"] {
                            desc.append(hashs(key: "\(key)", value: values.stringValue))
                            print("key \(key) value2 \(values.stringValue)")

                           }
                            data.append(newmodelobat(bbpom_reg: tanya["bbpom_reg"].stringValue, category_name: tanya["category_name"].stringValue, category_slug: tanya["category_slug"].stringValue, classification_name: tanya["classification_name"].stringValue, classification_slug: tanya["classification_slug"].stringValue, image: tanya["image"].stringValue, unit_small: tanya["unit_small"].stringValue, unit: tanya["unit"].stringValue, slug: tanya["slug"].stringValue, packaging: tanya["packaging"].stringValue, name: tanya["name"].stringValue, medicine_type: tanya["medicine_type"].stringValue, qty_unit_small: tanya["qty_unit_small"].stringValue, status: tanya["status"].boolValue, netto: tanya["netto"].intValue, max_prices: tanya["max_prices"].intValue, min_prices: tanya["min_prices"].intValue, description: desc))
                            if data.count ==  json["data"]["data"].count{
                                let res = Obats(data: data, first_page_url: json["data"]["first_page_url"].stringValue, nextpage: json["data"]["next_page_url"].stringValue, last_page_url: json["data"]["last_page_url"].stringValue, prev_page_url: json["data"]["prev_page_url"].stringValue, lastpage: json["data"]["last_page"].intValue, total: json["data"]["total"].intValue)
                                complited(res)
                            }
                             
                        })
                        
                       
                        
                    }else{
                        complited(nil)
                        
                    }
//                    print(value)
                case let .failure(error):
                    complited(nil)
                }
                
                
        }
        
    }
    
    func getpricetransaksi(token:String,long:String,lat:String,data:[reqpriceobat],id:String,transaction_id:String,complited: @escaping(String,respriceobat?)->()){
        print("getpricetransaksi")
       let headers: HTTPHeaders = [
                   "Authorization": "Bearer \(token)",
                   "Accept": "application/json",
                   "Content-Type": "application/json"
               ]
        
        var temp :[Parameters] = []
        
        for index in data {
            temp.append([
                "medicine":index.medicine,
                "qty":index.qty,
                "prescription_id" : id
            ])
        }
        let param :Parameters = [
            "map_lat":lat,
            "map_lng":long,
            "orders":temp,
            "transaction_id":transaction_id
        ]
        
        let url = "\(AppSettings.Url)medicine-stocks-pharmacy"
        print(url)
        print(param)
        
        var data : [resdetailobat] = []
        
        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["messages"].stringValue == "Unauthenticated." {
                        complited(json["messages"].stringValue,nil)
                    }
                    
                    
                    if json["code"].stringValue == "200"{
                        if json["data"]["medicines"].count == 0{
                            complited(json["messages"].stringValue,nil)
                        }else{
                        json["data"]["medicines"].array?.forEach({ (obat) in
                            
                            data.append(resdetailobat(slug: obat["slug"].stringValue, name: obat["name"].stringValue, unit: obat["unit"].stringValue, price: obat["price"].intValue, stock: obat["stock"].intValue, qty: obat["qty"].intValue, available: obat["available"].intValue == 1 ? true : false, min_prices: obat["min_prices"].intValue, max_prices: obat["max_prices"].intValue, order_id: 0, prescription_id: obat["prescription_id"].stringValue, status: obat["status"].intValue == 1 ? true : false))
                        })
                        
                        if data.count == json["data"]["medicines"].count{
                            complited("",respriceobat(id: json["data"]["id"].stringValue, pharmacy_name: json["data"]["pharmacy_name"].stringValue, medicine_available: json["data"]["medicine_available"].stringValue, distances: json["data"]["distances"].stringValue, detail: data, destination: alamatdelivery(address: json["data"]["address"].stringValue, long: json["data"]["map_lng"].doubleValue, lat: json["data"]["map_lat"].doubleValue), phone_number: json["data"]["phone_number"].stringValue, email: json["data"]["email"].stringValue, fullname: json["data"]["fullname"].stringValue))
                        }
                        }
                    }else{
                        complited(json["messages"].stringValue,nil)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited("error server",nil)
                }
                
                
        }
     
    }
    
    
    
    func getprice(token:String,long:String,lat:String,data:[reqpriceobat],complited: @escaping(Bool,GetPriceObat?,String)->()){
        
        
       let headers: HTTPHeaders = [
                   "Authorization": "Bearer \(token)",
                   "Accept": "application/json",
                   "Content-Type": "application/json"
               ]
        
        var temp :[Parameters] = []
        
        for index in data {
            temp.append([
                "medicine" : index.medicine,
                "medicine_code_partner" :index.code,
                "qty":index.qty,
                "prescription_id" : index.prescription_id
            ])
        }
        let param :Parameters = [
            "map_lat":lat,
            "map_lng":long,
            "orders":temp,
        ]
        let url = "\(AppSettings.Url)medicine-stocks-pharmacy"
        print(url)
        print(param)
        print(headers)
        
        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("ini ress")
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["success"].boolValue{
                        
                        do{
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(GetPriceObat.self, from: respon.data!)
                            if response.code == 200{
                                complited(true,response,response.messages!)

                            }else{
                                complited(false,response,response.messages!)
                            }
                         

                         
                            
                        }catch{
                            print("error trying to convert data to JSON: \(error)")
                            complited(false,nil,"error server")
                           
                        }
                    }else{
                        complited(false,nil,json["messages"].stringValue)
                    }
                    
                    
                case let .failure(error):
                    complited(false,nil,"error server")
                }
                
                
        }
       
        
    }
    
}
