//
//  ResepObatTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 07/09/21.
//

import UIKit

class ResepObatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rule: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var qty: UILabel!
    
    static let identifier = "ResepObatTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ResepObatTableViewCell", bundle: AppSettings.bundleframework)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func config(data : Resepobats){
        print(data)
        print("oo")
        name.text = data.medicines_name
        rule.text = data.rule
        waktu.text = data.period
        note.text = ""
        qty.text  = "\(data.qty!) \(data.unit!)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
