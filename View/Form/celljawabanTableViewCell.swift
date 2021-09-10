//
//  celljawabanTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 10/07/21.
//

import UIKit

class celljawabanTableViewCell: UITableViewCell {

    
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var view2: UIView!
 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        views.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
   
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
