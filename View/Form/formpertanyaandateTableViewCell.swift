//
//  formpertanyaandateTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 10/07/21.
//

import UIKit

class formpertanyaandateTableViewCell: UITableViewCell {

    let datepickertanggal = UIDatePicker()
    var data : listformmodel?

    @IBOutlet weak var tingginotif: NSLayoutConstraint!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UILabel!
    var typetimes = ""
    var row:Int?
    var delegate :form_pertanyaan_delegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.layer.cornerRadius = 10
//        background.layer.borderWidth = 1
//        background.layer.borderColor = UIColor.gray.cgColor
//        if typetimes == "time"{

//        }

        datepickertanggal.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datepickerview()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        
        let format = DateFormatter()
        if typetimes == "time"{
            format.dateFormat = "HH:mm"

        }else{
            format.dateFormat = "yyyy-MM-dd"
        }
        date.text = format.string(from: datepickertanggal.date)

    }
    @IBAction func endedit(_ sender: Any) {
        delegate?.setdate(row: row!, value:  date.text ?? "")
    }
    
    @objc func nonenext() {
        print("cek none2")

        let format = DateFormatter()
        if typetimes == "time"{
            format.dateFormat = "HH:mm"

        }else{
            format.dateFormat = "yyyy-MM-dd"
        }

        date.text = format.string(from: datepickertanggal.date)
        if date.text == ""{
            tingginotif.constant = CGFloat(20)
        }else{
            tingginotif.constant = 0
        }
        self.delegate?.setdate(row: row!, value: format.string(from: datepickertanggal.date))
        
      
        
        
    }
    
    func datepickerview(){
        let tool = UIToolbar()
        tool.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(nonenext))
        tool.setItems([done], animated: true)
        if typetimes == "time"{
            datepickertanggal.datePickerMode = .time

        }else{
            datepickertanggal.datePickerMode = .date

        }
        date.inputAccessoryView = tool
        date.inputView = datepickertanggal
        
    }
}
