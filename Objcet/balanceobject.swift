//
//  balanceobject.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class balanceobject: NSObject {
    
//    Mbalance
    
    var count = Count()
    
    
    func waktu (waktu : Double)->String{
        let ddt = Date(timeIntervalSince1970: TimeInterval(waktu) / 1000)
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "dd-MM-yyyy"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: ddt)
        
         
        switch dayInWeek {
        case "Monday":
          return "Sen, \(myDateFormatter.string(from: ddt))"
        case "Tuesday":
          return "Sel, \(myDateFormatter.string(from: ddt))"
        case "Wednesday":
          return "Rab, \(myDateFormatter.string(from: ddt))"
        case "Thursday":
          return "Kam, \(myDateFormatter.string(from: ddt))"
        case "Friday":
          return "Jum, \(myDateFormatter.string(from: ddt))"
        case "Saturday":
          return "Sab, \(myDateFormatter.string(from: ddt))"
        case "Sunday":
          return "Min, \(myDateFormatter.string(from: ddt))"
        default:
            return myDateFormatter.string(from: ddt)
        }

       
    }
    
    func gethistorybalance(token: String,from:String , to:String, completion: @escaping(String,[historybalance]?,Bool)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)history-balances?from=\(from)&to=\(to)"
        
        print(url)
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("gethistorybalance")
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    var data :[historybalance] = []
                    if json["code"].stringValue == "200"{
                        
                        if json["data"].count == 0{
                            return  completion(json["code"].stringValue,nil,false)
                        }
                        
                        json["data"].array?.forEach({ (index) in
 
//                            index["TransactionTimeStamp"].doubleValue
                            
                            
                            data.append( historybalance(TransactionDescription1: index["TransactionDescription1"].stringValue, TransactionID: index["TransactionID"].stringValue, TransactionTimeStamp: self.waktu(waktu: index["TransactionTimeStamp"].doubleValue), TransactionAmount: index["TransactionAmount"].intValue))
                           
                            if data.count == json["data"].count{
                                return   completion("",data,true)
                            }
                        })
                       
                    } else{
                        completion(json["message"].stringValue,nil,false)
                    }
                    
                    print(value)
                case let .failure(error):
                    print(error)
                    
                    completion("Error koneksi",nil,false)

                }
                
            }
    }
    
    func confirmConsult(token: String, completion: @escaping(String,Mbalance?,Bool)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)account-balance"
        
        print(url)
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    
                    if json["code"].stringValue == "200"{
                        completion("",Mbalance(accountno: json["data"]["GLAccountNo"].stringValue, accounttypecode: json["data"]["GLAccountTypeCode"].stringValue, accountname: json["data"]["GLAccountName"].stringValue, paymentid: json["data"]["PaymentId"].stringValue, paymentname: json["data"]["PaymentName"].stringValue, accountbalance: json["data"]["GLAccountBalance"].intValue, pointrewardbalance: json["data"]["PointRewardBalance"].intValue),true)
                    } else{
                        completion(json["message"].stringValue,nil,false)
                    }
                    
                    print(value)
                case let .failure(error):
                    print(error)
                    
                    completion("Error koneksi",nil,false)

                }
                
            }
    }
    

}
