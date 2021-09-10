//
//  Gradient.swift
//  Pasien
//
//  Created by Yudi Muhamad T on 01/10/20.
//  Copyright © 2020 idham. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    
    func  setGrradientbackground(colorone:UIColor , colortwo: UIColor){
        let gradienlayer = CAGradientLayer()
        gradienlayer.frame = bounds
        gradienlayer.colors = [colorone.cgColor , colortwo.cgColor]
        gradienlayer.locations = [0.0,1.0]
        gradienlayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradienlayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradienlayer, at: 0)

    }
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}
