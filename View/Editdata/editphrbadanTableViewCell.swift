//
//  editphrbadanTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//

import UIKit

protocol editphrbadanTableViewCelldelegate{
    func kirimtinggi(tinggi : Int)
    func kirimberat(berat : Int)

}

class editphrbadanTableViewCell: UITableViewCell {
    @IBOutlet weak var tinggi: UITextField!
    var delegate : editphrbadanTableViewCelldelegate!
    @IBOutlet weak var berat: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func tggex(_ sender: Any) {
        
        delegate.kirimberat(berat: Int(berat.text  == "" ? "0" : berat.text ?? "0")!)
    }
    
    @IBAction func badanex(_ sender: Any) {
        delegate.kirimtinggi(tinggi: Int(tinggi.text == "" ? "0" : tinggi.text ?? "0")!)
    }
}
