//
//  cellotherpertanyaanTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 10/07/21.
//

import UIKit

class cellotherpertanyaanTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    

    @IBOutlet weak var views: UIView!
    @IBOutlet weak var values: UITextField!
    @IBOutlet weak var check: UIImageView!
    var delegate : getheightrow?
    var row : Int?
    var ischeck = false{
        didSet{
            if ischeck{
                if radio{
                    check.image = UIImage(named: "Radio Button Active", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                }else{
                    check.image = UIImage(named: "Checkbox Active", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)

                }
            }else{
                if radio{
                    check.image = UIImage(named: "Radio Button", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                }else{
                    check.image = UIImage(named: "Checkbox", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)

                }
            }
        }
    }
    var radio = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        values.delegate = self

        check.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checked)))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.delegate?.getrow(value: self.views.frame.height)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.endkeyboard()
        
        return true
    }

    @IBAction func settestx(_ sender: Any) {
        if values.text  != "" {
            ischeck = true
            delegate?.selectother(row: row!, label: values.text ?? "", value: true)

        }else{
            ischeck = false
            delegate?.selectother(row: row!, label:  "", value: false)
        }
        
    }
    
    @IBAction func check(_ sender: Any) {
       if  values.text  != ""{
        ischeck =  true
       }else{
        ischeck =  false
       }
    }
    
    
    @objc func checked(){
        ischeck = !ischeck
        
        delegate?.clear_radio()
        if values.text != ""{
            delegate?.selectother(row: row!, label: values.text ?? "", value: ischeck)
        }
        if ischeck{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.values.becomeFirstResponder()
            }
            
        }
       
        
    }
}
