//
//  MYUIViewController.swift
//  Pasien
//
//  Created by Adam M Riyadi on 07/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import UIKit
import Parse
import CDAlertView

protocol MYUIViewControllerDelegate: AnyObject {
    func orientationDidChange(sender: MYUIViewController)
}

class MYUIViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    weak var orientationDelegate: MYUIViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //swift 4.2
//        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
       

    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder?
        
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

  
    
    func getDialogAlert(title: String, message: String, type: CDAlertViewType) -> CDAlertView {
        let alert = CDAlertView(title: title, message: message, type: type)
        
        return alert
    }
    
    
    deinit {
        
        //swift 4.2
//        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
       
    }
    
    @objc func orientationDidChange() {
        orientationDelegate?.orientationDidChange(sender: self)
    }
}
