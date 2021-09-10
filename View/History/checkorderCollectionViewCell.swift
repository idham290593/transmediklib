//
//  checkorderCollectionViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/08/21.
//

import UIKit

class checkorderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dash: UIView!
    @IBOutlet weak var point1: UIImageView!
    @IBOutlet weak var point2: UIImageView!
    @IBOutlet weak var point3: UIImageView!
    @IBOutlet weak var point4: UIImageView!
    
    
    func status(status : String){
        
        switch status {
        case "Unpaid":
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            break
            
        case "Paid":
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
          
            break
            
        case "Accepted":
            point1.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
     
            break

        case "Delivery":
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
      
            break
            
            
        case "Delivered":
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
         
            break
            
        case "Solved":
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            
            break
            
        case "Complained":
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.image =  UIImage(named: "Tanda Seru", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
          
           
            break
            
        case "Handled":
            point1.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.image =  UIImage(named: "Tanda Seru", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
          
            
            break

            
            
        case "Cancel By System":
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
           
            break

        default:
           print("")
        }
        
    }
}
