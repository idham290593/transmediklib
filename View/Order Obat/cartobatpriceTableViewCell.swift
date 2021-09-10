//
//  cartobatpriceTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 10/08/21.
//

import UIKit

class cartobatpriceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bviews: UIView!
    @IBOutlet weak var namaobat: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var harga: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }

}
