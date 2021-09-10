//
//  paymentobject.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class paymentobject: NSObject {

    
    
    
    func checkpayment(token:String,_ param : String,complited: @escaping(Bool)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)doku/first-check"
        
        let params :Parameters = ["trans_merchant_id" : param]

        
        print(params)
        AF.request(url, method: .post, parameters : params , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("respon profile")
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        complited(json["data"].intValue == 1 ? true : false)

                    }else{
                        complited(false)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(false)
                }
                
                
        }
        
    }
    
    func dokupayment(token:String,_ param : String,complited: @escaping(Bool , String,String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)doku/receive?\(param)"

        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("respon profile")
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        complited(true,json["data"]["trans_merchant_id"].stringValue,json["data"]["url"].stringValue)

                    }else{
                        complited(false,json["messages"].stringValue,"")
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(false,"Terjadi gangguan pada jaringan atau server ","")
                }
                
                
        }
        
    }
    
    func postpayment(token:String,id : String,name:String,complited: @escaping(Bool , String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)payments"
//        var modelpayment
        let param : Parameters = [ "payment_id": id ,
                                   "payment_name" : name ]
        
        AF.request(url, method: .post,parameters: param, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("respon profile")
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        complited(true,json["messages"].stringValue)

                    }else{
                        complited(false,json["messages"].stringValue)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(false,"Terjadi gangguan pada jaringan atau server ")
                }
                
                
        }
        
    }
    
    func getpayment(token:String,complited: @escaping(Bool , String,modelpayment?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)payment-types"
        print(url)
        print(headers)
//        var modelpayment
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("respon profile")
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        var walet : [detailpayment] = []
                        var debit : [detailpayment] = []
                        var transfer : [detailpayment] = []
                        var vacount : [detailpayment] = []
                        var asuransi : [detailpayment] = []

                        
                        json["data"].array?.forEach({ (data) in
                            if data["name"].stringValue == "E-Wallet"{
                                data["payment"].array?.forEach({ (waletindex) in
                                    walet.append(detailpayment(payment_id: waletindex["id"].stringValue, payment_name: waletindex["payment_name"].stringValue, payment_number: waletindex["payment_number"].stringValue, account_name: waletindex["account_name"].stringValue, description: waletindex["description"].stringValue, image: waletindex["image"].stringValue))
                                })
                            }
                            if data["name"].stringValue == "CC/Debit"{
                                data["payment"].array?.forEach({ (waletindex) in
                                    debit.append(detailpayment(payment_id: waletindex["id"].stringValue, payment_name: waletindex["payment_name"].stringValue, payment_number: waletindex["payment_number"].stringValue, account_name: waletindex["account_name"].stringValue, description: waletindex["description"].stringValue, image: waletindex["image"].stringValue))
                                })
                            }
                            if data["name"].stringValue == "Bank Transfer"{
                                data["payment"].array?.forEach({ (waletindex) in
                                    transfer.append(detailpayment(payment_id: waletindex["id"].stringValue, payment_name: waletindex["payment_name"].stringValue, payment_number: waletindex["payment_number"].stringValue, account_name: waletindex["account_name"].stringValue, description: waletindex["description"].stringValue, image: waletindex["image"].stringValue))
                                })
                            }
                            
                            if data["name"].stringValue == "Transfer Virtual Account"{
                                data["payment"].array?.forEach({ (waletindex) in
                                    vacount.append(detailpayment(payment_id: waletindex["id"].stringValue, payment_name: waletindex["payment_name"].stringValue, payment_number: waletindex["payment_number"].stringValue, account_name: waletindex["account_name"].stringValue, description: waletindex["description"].stringValue, image: waletindex["image"].stringValue))
                                })
                            }
                            if data["name"].stringValue == "Asuransi"{
                                data["payment"].array?.forEach({ (waletindex) in
                                    asuransi.append(detailpayment(payment_id: waletindex["id"].stringValue, payment_name: waletindex["payment_name"].stringValue, payment_number: waletindex["payment_number"].stringValue, account_name: waletindex["account_name"].stringValue, description: waletindex["description"].stringValue, image: waletindex["image"].stringValue))
                                })
                            }
                            
                            
                        })
                        
                        complited(true,json["messages"].stringValue,modelpayment(EWallet: walet, VAccount: vacount, Asuransi: asuransi, Bank_Transfer: transfer, Debit: debit))

                        
                       
                        
                    }else{
                        complited(false,json["messages"].stringValue,nil)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(false,"Terjadi gangguan pada jaringan atau server ",nil)
                }
                
                
        }
        
    }
}
