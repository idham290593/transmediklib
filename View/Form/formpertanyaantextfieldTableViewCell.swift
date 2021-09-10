//
//  formpertanyaantextfieldTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 10/07/21.
//

import UIKit




class formpertanyaantextfieldTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var nametext: UITextField!
    var row:Int?
    var required = false
    var delegate :form_pertanyaan_delegate?
    var typetext = ""
    
    @IBOutlet weak var tingginotif: NSLayoutConstraint!
    @IBOutlet weak var background: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.layer.cornerRadius = 10
//        background.layer.borderWidth = 1
//        background.layer.borderColor = UIColor.gray.cgColor
        nametext.delegate = self
       
       

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.endkyeboard()
        return true
    }
    
    @IBAction func check(_ sender: Any) {
        print("end keyboard")
        let _isi = nametext.text ?? ""
        if required{
            if _isi == "" {
                tingginotif.constant = CGFloat(20)
                notes.text = "Pertanyaan ini harus di isi"
                return
            } else  if typetext == "email" && !_isi.contains("@"){
                if _isi.contains("."){
                    tingginotif.constant = CGFloat(0)
                }else{
                    tingginotif.constant = CGFloat(20)
                    notes.text = "isi tidak sesuai"
                }
                return
            }else{
                tingginotif.constant = 0
            }
        }
    }
    

    @IBAction func edit(_ sender: Any) {
        if required{
            if nametext.text == "" {
                tingginotif.constant = CGFloat(20)
                notes.text = "Pertanyaan ini harus di isi"
                return
            }else{
                tingginotif.constant = 0
            }
        }else{
            tingginotif.constant = 0
        }
       
        delegate?.set_textfield_value_to_master(row: row!, value: String(nametext.text ?? ""))
    }
}
