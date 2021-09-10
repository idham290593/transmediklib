//
//  history.swift
//  transmedik
//
//  Created by Idham Kurniawan on 28/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class historiesobject: NSObject {
    

    
    func gethiostorybyurl(token:String,url:String,complited: @escaping([ModelHistories]?,String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        

        
        var tmp :[ModelHistories] = []
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("ini respon history url")
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        if json["data"]["data"].count  == 0 {
                            return complited(nil, "")

                        }
                        json["data"]["data"].array?.forEach({ (data) in
                            
                            var datapembelian:[resdetailobat] = []
                            let doctortmp = data["detail_consultation"]["doctor"]
                            let doctor = Detaildokter(description: doctortmp["description"].stringValue, device_id: doctortmp["device_id"].stringValue, email: doctortmp["email"].stringValue, experience: doctortmp["experience"].stringValue, full_name: doctortmp["full_name"].stringValue, gender: doctortmp["gender"].stringValue, no_str: doctortmp["no_str"].stringValue, object_id: doctortmp["object_id"].stringValue, phone_number: doctortmp["phone_number"].stringValue, profile_picture: doctortmp["profile_picture"].stringValue, province_id: doctortmp["province_id"].stringValue, province_name: doctortmp["province_name"].stringValue, rates: doctortmp["rates"].stringValue, rating: doctortmp["rating"].stringValue, regency_id: doctortmp["regency_id"].stringValue, regency_name: doctortmp["regency_name"].stringValue, specialist: doctortmp["specialist"].stringValue, specialist_slug: doctortmp["specialist_slug"].stringValue, start_experience: doctortmp["start_experience"].stringValue, status: doctortmp["status"].stringValue, status_docter: doctortmp["status_docter"].stringValue, uuid: doctortmp["uuid"].stringValue, facilities: [], educations: [], edustring: "", facilitiesstring: "")
                            
                            //get ModelProfile
                            let pasientmp =  data["detail_consultation"]["patient"]
                       
                            let pasien = ModelProfile(uuid: pasientmp["uuid"].stringValue, full_name: pasientmp["full_name"].stringValue, email: pasientmp["email"].stringValue, phone_number: pasientmp["phone_number"].stringValue, gender: pasientmp["gender"].stringValue, status: pasientmp["status"].stringValue, nik: pasientmp["ref"]["nik"].stringValue, no_kk: pasientmp["ref"]["no_kk"].stringValue, dob: pasientmp["ref"]["dob"].stringValue, height: pasientmp["ref"]["body_height"].stringValue, weight: pasientmp["ref"]["body_weight"].stringValue, blood: pasientmp["ref"]["blood_type"].stringValue, relationship: pasientmp["ref"]["relationship"].stringValue, allergy: pasientmp["ref"]["allergy"].stringValue, created_at: pasientmp["created_at"].stringValue, updated_at: pasientmp["updated_at"].stringValue, image: pasientmp["profile_picture"].stringValue)
                            
                            //note
                            let notetemp = data["detail_consultation"]["doctor_note"]
                            let note = doctor_note(note: notetemp["note"].stringValue, next_schedule: notetemp["next_schedule"].stringValue)
                            
                            
                            let prescriptiontemp = data["detail_consultation"]["prescription"]
                            let rescription = prescription(id: prescriptiontemp["id"].stringValue, consultation_id: prescriptiontemp["consultation_id"].stringValue, prescription_number: prescriptiontemp["prescription_number"].stringValue, order_status: prescriptiontemp["order_status"].stringValue, administration_fee: prescriptiontemp["administration_fee"].stringValue, discount_percent: prescriptiontemp["discount_percent"].stringValue, discount: prescriptiontemp["discount"].stringValue, total: prescriptiontemp["total"].stringValue, note: prescriptiontemp["note"].stringValue, status: prescriptiontemp["status"].stringValue, created_at: prescriptiontemp["created_at"].stringValue, updated_at: prescriptiontemp["updated_at"].stringValue, expires: prescriptiontemp["expires"].stringValue)
                            
                            let clinic = modelhistoryclinic(address: prescriptiontemp["clinic"]["address"].stringValue, image: prescriptiontemp["clinic"]["image"].stringValue, name: prescriptiontemp["clinic"]["name"].stringValue)
                            
                            let detailkonsul = detailconsul(doctor: doctor, patient: pasien, consultation_id: data["detail_consultation"]["consultation_id"].stringValue, doctor_note: note, spa: data["detail_consultation"]["spa"].boolValue, prescription: rescription, modelhistoryclinic: clinic)
                            
                            data["detail_order"]["medicines"].array?.forEach({ (dataobat) in
                                datapembelian.append(resdetailobat(slug: dataobat["slug"].stringValue, name: dataobat["name"].stringValue, unit: dataobat["unit"].stringValue, price: dataobat["price"].intValue, stock: dataobat["stock"].intValue, qty: dataobat["qty"].intValue, available: dataobat["available"].boolValue, min_prices: dataobat["min_prices"].intValue, max_prices: dataobat["max_prices"].intValue, order_id: data["detail_order"]["order_id"].intValue, prescription_id: dataobat["prescription_id"].stringValue, status: false))
                            })
                            
                            print("yyyyyyy =>>>\(datapembelian.count)" )

                            tmp.append(ModelHistories(type_history: data["type_history"].stringValue, label: data["label"].stringValue, name: data["name"].stringValue, transaction_date: data["transaction_date"].stringValue, status: data["status"].stringValue, total: data["total"].intValue, detail_medicine: datapembelian, detail_consultation: detailkonsul, rating: data["rating"].intValue))
                            if tmp.count == json["data"]["data"].count{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    print("total respon")
                                    print(tmp.count )
                                complited(tmp, json["data"]["next_page_url"].stringValue)
                                }
                            }
                        })
                    }else{
                        complited(tmp,"")
                        
                    }
                case let .failure(error):
                    complited(tmp,"")
                }
                
                
        }
        
    }
    
    func gethistories(token:String,uuid:String,selected:Int? ,complited: @escaping([ModelHistories]?,String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        
        let url = "\(AppSettings.Url)histories/\(uuid)?filter=\(selected ?? 1)&per_page=10"
        print(url)
        print(headers)
        
        var tmp :[ModelHistories] = []
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("ini respon history")
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        if json["data"]["data"].count  == 0 {
                            return complited(nil, "")

                        }
                        
                        json["data"]["data"].array?.forEach({ (data) in
                            var datapembelian:[resdetailobat] = []
                            //get doctor
                            let doctortmp = data["detail_consultation"]["doctor"]
                            let doctor = Detaildokter(description: doctortmp["description"].stringValue, device_id: doctortmp["device_id"].stringValue, email: doctortmp["email"].stringValue, experience: doctortmp["experience"].stringValue, full_name: doctortmp["full_name"].stringValue, gender: doctortmp["gender"].stringValue, no_str: doctortmp["no_str"].stringValue, object_id: doctortmp["object_id"].stringValue, phone_number: doctortmp["phone_number"].stringValue, profile_picture: doctortmp["profile_picture"].stringValue, province_id: doctortmp["province_id"].stringValue, province_name: doctortmp["province_name"].stringValue, rates: doctortmp["rates"].stringValue, rating: doctortmp["rating"].stringValue, regency_id: doctortmp["regency_id"].stringValue, regency_name: doctortmp["regency_name"].stringValue, specialist: doctortmp["specialist"].stringValue, specialist_slug: doctortmp["specialist_slug"].stringValue, start_experience: doctortmp["start_experience"].stringValue, status: doctortmp["status"].stringValue, status_docter: doctortmp["status_docter"].stringValue, uuid: doctortmp["uuid"].stringValue, facilities: [], educations: [], edustring: "", facilitiesstring: "")
                            
                            //get ModelProfile
                            let pasientmp =  data["detail_consultation"]["patient"]
                       
                            let pasien = ModelProfile(uuid: pasientmp["uuid"].stringValue, full_name: pasientmp["full_name"].stringValue, email: pasientmp["email"].stringValue, phone_number: pasientmp["phone_number"].stringValue, gender: pasientmp["gender"].stringValue, status: pasientmp["status"].stringValue, nik: pasientmp["ref"]["nik"].stringValue, no_kk: pasientmp["ref"]["no_kk"].stringValue, dob: pasientmp["ref"]["dob"].stringValue, height: pasientmp["ref"]["body_height"].stringValue, weight: pasientmp["ref"]["body_weight"].stringValue, blood: pasientmp["ref"]["blood_type"].stringValue, relationship: pasientmp["ref"]["relationship"].stringValue, allergy: pasientmp["ref"]["allergy"].stringValue, created_at: pasientmp["created_at"].stringValue, updated_at: pasientmp["updated_at"].stringValue, image: pasientmp["profile_picture"].stringValue)
                            
                            //note
                            let notetemp = data["detail_consultation"]["doctor_note"]
                            let note = doctor_note(note: notetemp["note"].stringValue, next_schedule: notetemp["next_schedule"].stringValue)
                            
                            
                            let prescriptiontemp = data["detail_consultation"]["prescription"]
                            let rescription = prescription(id: prescriptiontemp["id"].stringValue, consultation_id: prescriptiontemp["consultation_id"].stringValue, prescription_number: prescriptiontemp["prescription_number"].stringValue, order_status: prescriptiontemp["order_status"].stringValue, administration_fee: prescriptiontemp["administration_fee"].stringValue, discount_percent: prescriptiontemp["discount_percent"].stringValue, discount: prescriptiontemp["discount"].stringValue, total: prescriptiontemp["total"].stringValue, note: prescriptiontemp["note"].stringValue, status: prescriptiontemp["status"].stringValue, created_at: prescriptiontemp["created_at"].stringValue, updated_at: prescriptiontemp["updated_at"].stringValue, expires: prescriptiontemp["expires"].stringValue)
                            
                            let clinic = modelhistoryclinic(address: data["detail_consultation"]["clinic"]["address"].stringValue, image: data["detail_consultation"]["clinic"]["image"].stringValue, name: data["detail_consultation"]["clinic"]["name"].stringValue)
                            
                            
                            let detailkonsul = detailconsul(doctor: doctor, patient: pasien, consultation_id: data["detail_consultation"]["consultation_id"].stringValue, doctor_note: note, spa: data["detail_consultation"]["spa"].boolValue, prescription: rescription, modelhistoryclinic: clinic)
                            
                            data["detail_order"]["medicines"].array?.forEach({ (dataobat) in
                                datapembelian.append(resdetailobat(slug: dataobat["slug"].stringValue, name: dataobat["name"].stringValue, unit: dataobat["unit"].stringValue, price: dataobat["price"].intValue, stock: dataobat["stock"].intValue, qty: dataobat["qty"].intValue, available: dataobat["available"].boolValue, min_prices: dataobat["min_prices"].intValue, max_prices: dataobat["max_prices"].intValue, order_id: data["detail_order"]["order_id"].intValue, prescription_id: dataobat["prescription_id"].stringValue, status: false))
                            })
                            
                            print("yyyyyyy =>>>\(datapembelian.count)" )

                            tmp.append(ModelHistories(type_history: data["type_history"].stringValue, label: data["label"].stringValue, name: data["name"].stringValue, transaction_date: data["transaction_date"].stringValue, status: data["status"].stringValue, total: data["total"].intValue, detail_medicine: datapembelian, detail_consultation: detailkonsul, rating: data["rating"].intValue))
                            if tmp.count == json["data"]["data"].count{
                                print("=>>>>>>>>>>>>> \(json["data"]["next_page_url"]) "  + json["data"]["next_page_url"].stringValue)
                                complited(tmp, json["data"]["next_page_url"].stringValue)
                            }
                        })
                    }else{
                        complited(tmp,"")
                        
                    }
                case let .failure(error):
                    complited(tmp,"")
                }
                
                
        }
        
    }
    
    
    func getdetailkeluhan(token:String,id:String ,complited: @escaping(keluhanorderobat?,String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        
//        let url = "\(api.API())history/\(id)"
        let url = "\(AppSettings.Url)order/complained/\(id)"

        print(url)
        print(headers)
        
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("ini respon history")
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        
                        var imageresep :[String] = []
                        var typecomplen :[String] = []
                        var dataobat :[detailobattraking] = []
                        
                        if json["data"]["images"].count > 0{
                            json["data"]["images"].array?.forEach({ (datas) in
                                imageresep.append(datas.stringValue)
                            })
                        }
                      
                        if json["data"]["complain"]["type"].count > 0{
                        json["data"]["complain"]["type"].array?.forEach({ (datas) in
                            typecomplen.append(datas["complain_type_name"].stringValue)
                        })
                        }
                               
                        
                        if json["data"]["details"].count == 0 {
                            complited(keluhanorderobat(desc: json["data"]["complain"]["description"].stringValue, image_complain: json["data"]["complain"]["image"].stringValue, reason_solved: json["data"]["complain"]["reason_solved"].stringValue, order_status: json["data"]["order_status"].stringValue, order_date: json["data"]["order_date"].stringValue, images: imageresep, complain_type_name: typecomplen, detail: dataobat, total: json["data"]["total"].stringValue, voucher_amount: json["data"]["voucher_amount"].stringValue,namaapotek : json["data"]["pharmacy"]["pharmacy_name"].stringValue , alamatapotek : json["data"]["pharmacy"]["address"].stringValue, gambarapotek :json["data"]["pharmacy"]["image"].stringValue),"")
                        }
                        
                        json["data"]["details"].array?.forEach({ (data) in
                          
                            dataobat.append(detailobattraking(slug: "", name: data["medicine_name"].stringValue, unit: data["unit"].stringValue, price: data["price"].stringValue, qty: data["qty"].stringValue, prescription_id: data["prescription_id"].stringValue))
                            
                            if dataobat.count ==  json["data"]["details"].count{
//                                keluhanorderobat
                                complited(keluhanorderobat(desc: json["data"]["complain"]["description"].stringValue, image_complain: json["data"]["complain"]["image"].stringValue, reason_solved: json["data"]["complain"]["reason_solved"].stringValue, order_status: json["data"]["order_status"].stringValue, order_date: json["data"]["order_date"].stringValue, images: imageresep, complain_type_name: typecomplen, detail: dataobat, total: json["data"]["total"].stringValue, voucher_amount: json["data"]["voucher_amount"].stringValue,namaapotek : json["data"]["pharmacy"]["pharmacy_name"].stringValue , alamatapotek : json["data"]["pharmacy"]["address"].stringValue, gambarapotek :json["data"]["pharmacy"]["image"].stringValue),"")
                            }
                            
                        })
                        
                        
                    }else{
                        complited(nil,json["messages"].stringValue)
                        
                    }
                case let .failure(error):
                    complited(nil,"Terjadi masalah pada jaringan")
                }
                
                
        }
        
    }
    
    
    func getdetailhistory(token:String,id:String ,complited: @escaping(ordertrackingtransaksimodel?,String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        
//        let url = "\(api.API())history/\(id)"
        let url = "\(AppSettings.Url)history/\(id)"

        print(url)
        print(headers)
        
        var tmp :[ModelHistories] = []
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("ini respon history")
                print(respon)
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                    
                        if json["data"]["medicines"].count == 0 {
                            complited(ordertrackingtransaksimodel(medicines: [], order_date: json["data"]["order_date"].stringValue, order_status: json["data"]["order_status"].stringValue, consignee: json["data"]["consignee"].stringValue, phone_number: json["data"]["phone_number"].stringValue, address: json["data"]["address"].stringValue, note: json["data"]["note"].stringValue, payment_name: json["data"]["payment_name"].stringValue, payment_status: json["data"]["payment_status"].stringValue, courier: json["data"]["courier"].stringValue, invoice: json["data"]["invoice"].stringValue, total_order: json["data"]["total_order"].stringValue, shipping_fee: json["data"]["shipping_fee"].stringValue, service_fee: json["data"]["service_fee"].stringValue, total: json["data"]["total"].stringValue, voucher_amount: json["data"]["voucher_amount"].intValue),"")
                        }
                        
                        var datapembelian:[detailobattraking] = []
                        json["data"]["medicines"].array?.forEach({ (data) in
                            datapembelian.append(detailobattraking(slug: data["slug"].stringValue, name: data["name"].stringValue, unit: data["unit"].stringValue, price: data["price"].stringValue, qty: data["qty"].stringValue, prescription_id: data["prescription_id"].stringValue))
                            
                            if datapembelian.count ==  json["data"]["medicines"].count{
                                complited(ordertrackingtransaksimodel(medicines: datapembelian, order_date: json["data"]["order_date"].stringValue, order_status: json["data"]["order_status"].stringValue, consignee: json["data"]["consignee"].stringValue, phone_number: json["data"]["phone_number"].stringValue, address: json["data"]["address"].stringValue, note: json["data"]["note"].stringValue, payment_name: json["data"]["payment_name"].stringValue, payment_status: json["data"]["payment_status"].stringValue, courier: json["data"]["courier"].stringValue, invoice: json["data"]["invoice"].stringValue, total_order: json["data"]["total_order"].stringValue, shipping_fee: json["data"]["shipping_fee"].stringValue, service_fee: json["data"]["service_fee"].stringValue, total: json["data"]["total"].stringValue, voucher_amount: json["data"]["voucher_amount"].intValue),"")
                            }
                            
                        })
                        
                        
                    }else{
                        complited(nil,"")
                        
                    }
                case let .failure(error):
                    complited(nil,"")
                }
                
                
        }
        
    }
    
    
}
