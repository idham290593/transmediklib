//
//  Manage.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/07/21.
//

import Foundation
import UIKit

public class Managefmk{
    
    public init(){}
    // jalan
    
    public func Transmedik_Konsultasi(_ Viewcontroller : UIViewController){
            if UserDefaults.standard.bool(forKey: AppSettings.ON_CHAT){
//            Loading(UIViewController: Viewcontroller)
            if  let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                let chat = Chat()
                chat.checkkonsul(token: token) { (data) in
                    let uuid = UserDefaults.standard.string(forKey: AppSettings.uuid) ?? ""
                    let email = UserDefaults.standard.string(forKey: "email") ?? ""
                    if data != nil {
                        Transmedik.Openchat(id: Int(data!.consultation_id!), data: data!, uuid: uuid, email: email, Viewcontroller)
                    }
                    else {
//                        CloseLoading(Viewcontroller)
                        UserDefaults.standard.removeObject(forKey: AppSettings.ON_CHAT)
                        Toast.show(message: "Konsultasi sudah berakhir", controller: Viewcontroller)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            let bundle =  Bundle(for: fasilitaskesehatanVC.self)
                            let vc = fasilitaskesehatanVC(nibName: "fasilitaskesehatanVC", bundle: bundle)
                            Viewcontroller.present(vc, animated: false, completion: nil)                        }
                    }
                }
            }
        }else{
            let bundle =  Bundle(for: fasilitaskesehatanVC.self)
            let vc = fasilitaskesehatanVC(nibName: "fasilitaskesehatanVC", bundle: bundle)
            Viewcontroller.present(vc, animated: false, completion: nil)

        }
    }
    
    
//    public func Transmedik_Konsultasi(_ Viewcontroller : UIViewController){
//        let bundle =  Bundle(for: fasilitaskesehatanVC.self)
//        let vc = fasilitaskesehatanVC(nibName: "fasilitaskesehatanVC", bundle: bundle)
//        Viewcontroller.present(vc, animated: false, completion: nil)
//    }
    
}
