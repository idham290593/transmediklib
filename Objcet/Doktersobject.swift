//
//  Doktersobject.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class Doctors: NSObject {
    
    
    
    
    func getdokter(token:String,id:String,complited: @escaping(Detaildokter?)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)doctors/\(id)"
        
        
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(url)

                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        var alumnistring = ""
                        var failitiesstring = ""
                        var failities :[Detailtanyadoktertepat_praktek] = []
                        var edu : [Detailtanyadokteralmuni] = []
                        
                        json["data"]["facilities"].array?.forEach({ (tempf) in
                            if failitiesstring == "" {
                                failitiesstring = tempf["name"].stringValue
                                
                            }else{
                                failitiesstring = "\(failitiesstring) \n\(tempf["name"].stringValue)"
                                
                            }

                            failities.append(Detailtanyadoktertepat_praktek(id: tempf["id"].stringValue, dokters_id: tempf["dokters_id"].stringValue, facility_name: tempf["facility_name"].stringValue, province_id: tempf["province_id"].stringValue, province_name: tempf["province_name"].stringValue, regency_id: tempf["regency_id"].stringValue, regency_name: tempf["regency_name"].stringValue, create: tempf["created_at"].stringValue))
                        })
                        
                        json["data"]["educations"].array?.forEach({ (tempe) in
                            if alumnistring == "" {
                                alumnistring = tempe["education"].stringValue
                                
                            }else{
                                alumnistring = "\(alumnistring) \n\(tempe["education"].stringValue)"
                                
                            }
                            edu.append(Detailtanyadokteralmuni(id: tempe["id"].stringValue, dokters_id: tempe["dokters_id"].stringValue, education: tempe["education"].stringValue, graduation_year: tempe["graduation_year"].stringValue, create: tempe["create"].stringValue, updated_at: tempe["updated_at"].stringValue))
                        })
                        
                        let data = Detaildokter(description: json["data"]["description"].stringValue, device_id: json["data"]["device_id"].stringValue, email: json["data"]["email"].stringValue, experience: json["data"]["experience"].stringValue, full_name: json["data"]["full_name"].stringValue, gender: json["data"]["gender"].stringValue, no_str: json["data"]["no_str"].stringValue, object_id: json["data"]["object_id"].stringValue, phone_number: json["data"]["phone_number"].stringValue, profile_picture: json["data"]["profile_picture"].stringValue, province_id: json["data"]["province_id"].stringValue, province_name: json["data"]["province_name"].stringValue, rates: json["data"]["rates"].stringValue, rating: json["data"]["rating"].stringValue, regency_id: json["data"]["regency_id"].stringValue, regency_name: json["data"]["regency_name"].stringValue, specialist: json["data"]["specialist"].stringValue, specialist_slug: json["data"]["specialist_slug"].stringValue, start_experience: json["data"]["start_experience"].stringValue, status: json["data"]["status"].stringValue, status_docter: json["data"]["status_docter"].stringValue, uuid: json["data"]["uuid"].stringValue, facilities: failities, educations: edu,edustring:alumnistring, facilitiesstring:failitiesstring )
                        
                        
                        complited(data)
                        
                    }else{
                        print("error cing")

                        complited(nil)
                        
                    }
                //                        print(value)
                case let .failure(error):
                    print("error cing")
                    complited(nil)
                }
                
                
        }
        
    }
    
}
