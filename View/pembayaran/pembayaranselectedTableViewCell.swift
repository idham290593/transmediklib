//
//  pembayaranselectedTableViewCell.swift
//  Pasien
//
//  Created by Idham Kurniawan on 10/12/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import UIKit

class pembayaranselectedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var namebank: UILabel!
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var background: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.cornerRadius  = 13
        background.layer.shadowOffset = CGSize.zero
        background.layer.shadowRadius = 2
        background.layer.shadowOpacity = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
