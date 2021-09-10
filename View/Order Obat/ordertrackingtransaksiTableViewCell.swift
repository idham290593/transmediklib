//
//  ordertrackingtransaksiTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/08/21.
//

import UIKit
protocol  ordertrackingtransaksiTableViewCelldelegate {
    func tinggi(t : CGFloat)
}

class ordertrackingtransaksiTableViewCell: UITableViewCell {

    
    @IBOutlet weak var views: UIView!
    var delegate : ordertrackingtransaksiTableViewCelldelegate!
    @IBOutlet weak var jumlahobat: UILabel!
    @IBOutlet weak var namaobat: UILabel!
    @IBOutlet weak var rupiah: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        jumlahobat.textColor = Colors.basicvalue
        self.views.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.delegate.tinggi(t: self.views.frame.height)
        }
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
