//
//  resepcellTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 06/09/21.
//

import UIKit

class resepcellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rule: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var qty: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func config(data : Resepobats){
        name.text = data.medicines_name
        rule.text = data.rule
        waktu.text = data.period
        note.text = ""
        qty.text  = "\(data.qty)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
