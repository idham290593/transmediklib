//
//  listalamatTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 18/08/21.
//


import UIKit

protocol listalamatTableViewCelldelegate{
    func edit(row : Int)
    func delete(row : Int)
    func favorit(row : Int)
    
}

class listalamatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hapusalamat: UIImageView!
    @IBOutlet weak var iconrumah: UIImageView!
    @IBOutlet weak var headeralamat: UILabel!
    @IBOutlet weak var love: UIImageView!
    @IBOutlet weak var hapus: UIImageView!
    @IBOutlet weak var edit: UIImageView!
    @IBOutlet weak var perumahan: UILabel!
    @IBOutlet weak var detailalamat: UILabel!
    var delegate : listalamatTableViewCelldelegate!
    @IBOutlet weak var backgroundview: UIView!
    var row : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hapusalamat.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(hapusacc))))
        edit.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(editacc))))
    }
    @objc func editacc(){
        delegate.edit(row: row!)
    }
    
    @objc func hapusacc(){
        delegate.delete(row: row!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
