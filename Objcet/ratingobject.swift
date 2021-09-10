//
//  ratingobject.swift
//  transmedik
//
//  Created by Idham Kurniawan on 28/07/21.
//

import Foundation
import Alamofire
import SwiftyJSON
class ratingobject: NSObject {

    func pushrating(token: String,commen:[String] , id:String,desc:String,rating : String, completion: @escaping(String)->()){
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + token,
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
            
            let body :Parameters = [
                "comment": commen,
                "consultation_id":id,
                "description" : desc,
                "rating": rating

            ]
        let url = "\(AppSettings.Url)rating"
            
            
            AF.request(url, method: .post,parameters: body, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { respon in
                
                    switch respon.result {
                    case let .success(value):
                        let json = JSON(value)
                        var data :[historybalance] = []
                        if json["code"].stringValue == "200"{
                            
                            completion("berhasil")

                        } else{
                            completion(json["message"].stringValue)
                        }
                        
                        print(value)
                    case let .failure(error):
                        print(error)
                        
                        completion("Error koneksi")

                    }
                    
                }
        }
        
        

    }
