//
//  historiescellkonsulTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 28/07/21.
//

import UIKit
protocol historiescellkonsulTableViewCelldelegate{
    func chatulang(row:Int)
    func nilai(row:Int)
}

class historiescellkonsulTableViewCell: UITableViewCell {

    
    @IBOutlet weak var penilaian: UIView!
    @IBOutlet weak var wobat: NSLayoutConstraint!
    @IBOutlet weak var wwaktu: NSLayoutConstraint!
    @IBOutlet weak var wresep: NSLayoutConstraint!
    
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var totalharga: UILabel!
    var delegate :historiescellkonsulTableViewCelldelegate!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var namedokter: UILabel!
    @IBOutlet weak var pesanulang: UIView!
    @IBOutlet weak var obat: UIImageView!
    @IBOutlet weak var calender: UIImageView!
    @IBOutlet weak var edit: UIImageView!
    var row = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        views.layer.shadowColor = UIColor.black.cgColor
               views.layer.cornerRadius  = 13
               views.layer.shadowOffset = CGSize.zero
               views.layer.shadowRadius = 2
               views.layer.shadowOpacity = 0.2
        penilaian.layer.cornerRadius = 8
        penilaian.layer.borderWidth = 1
        penilaian.layer.borderColor = Colors.basicvalue.cgColor
        penilaian.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nilai)))
        
        pesanulang.layer.cornerRadius = 8
        pesanulang.layer.borderWidth = 1
        pesanulang.layer.borderColor = Colors.basicvalue.cgColor
        pesanulang.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ulang)))
       

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @objc func nilai(){
        delegate.nilai(row: row)
    }
    @objc func ulang(){
        delegate.chatulang(row: row)
    }
  
}
