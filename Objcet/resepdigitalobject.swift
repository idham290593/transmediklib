//
//  resepdigitalobject.swift
//  transmedik
//
//  Created by Idham Kurniawan on 26/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class resepdigitalobject: NSObject {
    
    
    func getresep(token : String, id:String ,complited: @escaping(Data?)->()){
        
        print(token)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)prescription/\(id)"
        print(url)
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    do {
                        complited(try json.rawData())
                    }catch{
                        print("error")
                    }
                case let .failure(error):
                    complited(nil)
                    
                }
                
                
        }
        
    }
    
    
    
}
