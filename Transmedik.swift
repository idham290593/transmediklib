//
//  Transmedik.swift
//  transmedik
//
//  Created by Idham Kurniawan on 12/07/21.
//

import Foundation
import Parse
import UIKit
import Alamofire
import SwiftyJSON


public class Transmedik {
    
    
     public static func checkpin(token:String,pin : String,complited: @escaping(Bool , String)->()){
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = "\(AppSettings.Url)auth/check-pin"
        let parm : Parameters = [ "pin" : pin]
       
        
        AF.request(url, method: .post,parameters: parm,  encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print(url)
                print(parm)
                print(headers)
                print("respon profile check")
                print("vvvvvvvvvvvvvvvvv")
                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        if json["data"].intValue == 1{
                            complited(true , "")
                        }else{
                            complited(false , "Pin sebelumnya tidak sama")
                        }
                        print(json["data"])
                      
                        
                    }else{
                        complited(false,json["messages"].stringValue)
                        
                    }
                case let .failure(error):
                    complited(false,"Terjadi gangguan pada jaringan atau server ")
                }
                
                
        }
        
    }
    
    
    public static func Transmedik_Konsultasi(_ Viewcontroller : UIViewController){
            if UserDefaults.standard.bool(forKey: AppSettings.ON_CHAT){
            Loading(UIViewController: Viewcontroller)
            if  let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                let chat = Chat()
                chat.checkkonsul(token: token) { (data) in
                    let uuid = UserDefaults.standard.string(forKey: AppSettings.uuid) ?? ""
                    let email = UserDefaults.standard.string(forKey: "email") ?? ""
                    if data != nil {
                        Transmedik.Openchat(id: Int(data!.consultation_id!), data: data!, uuid: uuid, email: email, Viewcontroller)
                    }
                    else {
                        CloseLoading(Viewcontroller)
                        UserDefaults.standard.removeObject(forKey: AppSettings.ON_CHAT)
                        Toast.show(message: "Konsultasi sudah berakhir", controller: Viewcontroller)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            let bundle =  Bundle(for: fasilitaskesehatanVC.self)
                            let vc = fasilitaskesehatanVC(nibName: "fasilitaskesehatanVC", bundle: bundle)
                            vc.modalPresentationStyle = .fullScreen

                            Viewcontroller.present(vc, animated: false, completion: nil)
                        }
                    }
                }
            }
        }else{
            let vc = UIStoryboard(name: "Fasilitaskesehatan", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "fasilitaskesehatanViewController") as? fasilitaskesehatanViewController
            
            Viewcontroller.present(vc!, animated: false, completion: nil)
        }
    }
    
    
    
    public static func SetSettingparseTransmedik(){
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = AppSettings.PARSE_APPID
            $0.clientKey = AppSettings.PARSE_CLIENTKEY
            $0.server = AppSettings.PARSE_SERVER
            //$0.isLocalDatastoreEnabled = true
        }
        Parse.initialize(with: parseConfig)
    }
    
    public static func Loading(UIViewController : UIViewController){
        let vc = UIStoryboard(name: "Loading", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "lodingViewController") as? lodingViewController
        UIViewController.present(vc!, animated: false, completion: nil)

    }

    public static func CloseLoading(_ UIViewController : UIViewController){

        UIViewController.dismiss(animated: false, completion: nil)

    }
    
    public static func openmenu(_ view : UIViewController){
        let vc = UIStoryboard(name: "Transmedik", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        
        view.present(vc!, animated: true, completion: nil)
    }
    
    
    
    public static func Openchat(id : Int,data: ConsultationPostModel,uuid : String,email : String, _ UIViewController : UIViewController){
        var query: PFQuery<PFObject>!
        query = ConsultationModel.query()
        query = query.whereKey("consultation_id", equalTo: id)
        var pfdoctor : PFUser?
        var pfuser : PFUser?
        query.findObjectsInBackground(block: { (results, error) in
            if error == nil {

                if let chat = results as? [ConsultationModel] {
                    pfdoctor = chat[0].doctor
                    pfuser = chat[0].patient
                }
            }
        })
        
        query.findObjectsInBackground(block: { (results, error) in
            if error == nil {
                CloseLoading(UIViewController)

                if let chat = results as? [ConsultationModel] {
                    
                    let vc = DetailChatViewController()
                    vc.uuid_patient = uuid
                    vc.uuid_doctor = data.doctor!.uuid!
                    vc.email_patient = email
                    vc.email_doctor = data.doctor!.email!
                    vc.currentConsultation = data
                    vc.currentDoctor = chat[0].doctor
                    vc.currentUser = chat[0].patient
                                        
                    let nav = UINavigationController(navigationBarClass: UICustomNavigationBar.self, toolbarClass: nil)
                    nav.modalPresentationStyle = .fullScreen
                    nav.pushViewController(vc, animated: false)
                    UIViewController.present(nav, animated: true, completion: nil)
                }
            }
        })
    }
    
    public static func Transmedik_Login(_ email : String ,_ Password : String ,_ device_id : String, complited: @escaping(Bool,String)->()){
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "device-id": "ddrsUz__QoOoNLnZ4vLdkz:APA91bGKsrxPY0IRBJ3PwXBoSLRqD-OAL9vaWGkXXv2Q9FLkMjcgwvImwD-X9pt6Ut0g2ZLfbfYirq2OGIaS-aY8ItdSmB_yn-Ab_CUNpH12T9P0EJ96fLLT2-QCKvcW6aYZmUFiYzA4",
            "Authorization": "Bearer d2lkaUBkZXYubmV0a3JvbXNvbHV0aW9uLmNvbSMwODc4MjIyMDQxODkjVkhKaGJuTnRaV1JwYTJFdFFYQndjeTFKYm5SbFozSmhkR2x2Ymc9PQ=="
        ]
        
        
        let params : Parameters = [
            "email" : "widi@dev.netkromsolution.com",
            "gender":"L",
            "identification":"01060016",
            "name":"Widiyanto",
            "nik":"215467125468512888",
            "phone_number":"087822204189"
            
        ]
        
        let url = "\(AppSettings.Url)auth/login"
        
        
        AF.request(url, method: .post,parameters: params,  encoding: JSONEncoding.default, headers: headers)
            .responseJSON { respon in
                print("respon login \(respon)" )
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        UserDefaults.standard.removeObject(forKey: "logout")
                        let token = json["data"]["token"].stringValue
                        let uuid = json["data"]["uuid"].stringValue
                        let email = json["data"]["email"].stringValue
                        let name = json["data"]["name"].stringValue
                        
                        let profile_picture = json["data"]["profile_picture"].stringValue
                        let nik = json["data"]["nik"].stringValue

                        let phone = json["data"]["phone_number"].stringValue
                        let tokenparse = json["data"]["token_parse"].stringValue
                        let deviceid = json["data"]["device_id"].stringValue
                        let objectid = json["data"]["object_id"].stringValue
                        let  pin =  json["data"]["pin"].intValue == 1 ? true : false
                        
                        UserDefaults.standard.setValue(token, forKey: AppSettings.Tokentransmedik)
                        UserDefaults.standard.setValue(uuid, forKey: AppSettings.uuid)
                        UserDefaults.standard.setValue(email, forKey: AppSettings.email)
                        UserDefaults.standard.setValue(name, forKey: AppSettings.name)
                        UserDefaults.standard.setValue(profile_picture, forKey: AppSettings.profile_picture)
                        UserDefaults.standard.setValue(nik, forKey: AppSettings.nik)
                        UserDefaults.standard.setValue(tokenparse, forKey: AppSettings.tokenparse)
                        UserDefaults.standard.setValue(pin, forKey: AppSettings.pin)
                        UserDefaults.standard.setValue(phone, forKey: AppSettings.phone)


                        
                        
//                        let data = Sign_user(nik: nik, email: email, phone: phone, token: token, tokenparse: tokenparse, name: name, uuid: uuid, deviceid: deviceid, profile_picture: profile_picture, fullname: name, pin: pin)

                        complited(true,"")
                        
                    }else{
                        complited(false,json["messages"].stringValue)
                        
                    }
                    print(value)
                case let .failure(error):
                    complited(false,"")
                }
                
                
        }
        
    }
    
}
