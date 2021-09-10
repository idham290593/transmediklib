//
//  formtextareaTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 10/07/21.
//

import UIKit

class formtextareaTableViewCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var bodys: UITextView!
    @IBOutlet weak var notif: UILabel!
    @IBOutlet weak var background: UIView!
    
    
    var row:Int?
    var required = false
    var delegate :form_pertanyaan_delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.layer.cornerRadius = 10
        bodys.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        notif.isHidden = true
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.set_textfield_value_to_master(row: row!, value: bodys.text ?? "")
        if required && bodys.text != "" {
            notif.isHidden = true
        }else{
            notif.isHidden = false
        }
        
        if !required{
            notif.isHidden = true
        }
    }
}
