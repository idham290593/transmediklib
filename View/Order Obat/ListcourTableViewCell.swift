//
//  ListcourTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 24/08/21.
//

import UIKit


class ListcourTableViewCell: UITableViewCell {

    
    @IBOutlet weak var gambar: UIImageView!
    @IBOutlet weak var check: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    

}
