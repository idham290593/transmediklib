//
//  uiview.swift
//  Pasien
//
//  Created by Idham Kurniawan on 22/03/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController  {
   
    func setmoney(harga : Int) -> String{
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: NSNumber(value: harga)) {
            let outputs = formattedTipAmount.replacingOccurrences(of: "$", with: "")
            let outputs1 = "Rp. \(outputs.replacingOccurrences(of: "IDR", with: ""))"
           return String(outputs1)
        }
        return ""
    }

    
    func loading(_ UIViewController : UIViewController){
        let vc = UIStoryboard(name: "Loading", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "lodingViewController") as? lodingViewController
        present(vc!, animated: false, completion: nil)
        
    }
    
    func closeloading(_ UIViewController : UIViewController){
        dismiss(animated: false, completion: nil)
    }
    
  

}


//extension UIView {
////    func fadeTransition(_ duration:CFTimeInterval) {
////        let animation = CATransition()
////        animation.timingFunction = CAMediaTimingFunction(name:
////            CAMediaTimingFunctionName.easeInEaseOut)
////        animation.type = CATransitionType.fade
////        animation.duration = duration
////        layer.add(animation, forKey: CATransitionType.fade.rawValue)
////    }
//    
//   
//}
//
//
