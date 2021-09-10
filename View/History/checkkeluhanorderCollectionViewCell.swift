//
//  checkkeluhanorderCollectionViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/08/21.
//

import UIKit

class checkkeluhanorderCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var dash: UIView!
    @IBOutlet weak var point3: UIImageView!
    @IBOutlet weak var point2: UIImageView!
    @IBOutlet weak var point1: UIImageView!
    
    func status(status : String){
        
        switch status {
    
            
            
        case "Complained":
            point1.image = UIImage(named: "Check")
           
            break
            
        case "Handled":
            point1.image = UIImage(named: "Check")
            point2.image = UIImage(named: "Check")
   
            
            break
            
        case "Solved":
            point1.image = UIImage(named: "Check")
            point2.image = UIImage(named: "Check")
            point3.image = UIImage(named: "Check")
         
            
            break
            
            
            

        default:
          print("")
            
        }
        
    }
}
