//
//  filterdokterTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//


import UIKit
protocol filterdokterTableViewCelldelegate{
    func check(row:Int,path : Int)
}

class filterdokterTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var check: UIImageView!
    var delegate : filterdokterTableViewCelldelegate!
    var path = 0
    var row = 0
    override func awakeFromNib() {
        super.awakeFromNib()

        check.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkacc)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func checkacc(){
        delegate.check(row: row, path: path)
    }

}
