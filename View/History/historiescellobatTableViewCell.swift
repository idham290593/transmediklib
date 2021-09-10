//
//  historiescellobatTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/08/21.
//

import UIKit

protocol historiescellobatTableViewCelldelegate {
    func pesanulang(row : Int)
}

class historiescellobatTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var more: UILabel!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var namadokter: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var total: UILabel!
    var row = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        views.layer.shadowColor = UIColor.black.cgColor
        views.layer.cornerRadius  = 13
        views.layer.shadowOffset = CGSize.zero
        views.layer.shadowRadius = 2
        views.layer.shadowOpacity = 0.2

      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
  
    func statustext(status : String){
        
        switch status {
        case "Unpaid":
            self.status.text = "Menunggu Pembayaran"
            self.status.textColor = .red
            break
        case "Paid":
            self.status.text = "Transaksi berhasil"
            self.status.textColor = .init(hexString: "FFD600")
            break
        case "Accepted":
            self.status.text = "Pesanan diterima Apotik"
            self.status.textColor = UIColor.init(hexString: "005377")
            break
        case "Delivery":
            self.status.text = "Pesanan dikirim Apotik"
            self.status.textColor = UIColor.init(hexString: "70C900")
            break
        case "Delivered":
            self.status.text = " Pesanan Diterima"
            self.status.textColor = UIColor.init(hexString: "4080F0")
            break
        case "Cancel By System":
            self.status.text = "Pesanan Gagal"
            self.status.textColor = .red
            break
        case "Rejected":
            self.status.text = "Pesanan Ditolak Apotik"
            self.status.textColor = UIColor.init(hexString: "E75656")
            break
        case "Payment Failed":
            self.status.text = "Pembayaran Gagal"
            self.status.textColor = .red
            break
        case "Complained":
            self.status.text = "Kendala diterima"
            self.status.textColor = UIColor.init(hexString: "FFD600")
            break
        case "Handled":
            self.status.text = "Kendala Diproses"
            self.status.textColor = UIColor.init(hexString: "005377")
            break
            
        case "Solved":
            self.status.text = "Kendala Selesai"
            self.status.textColor = UIColor.init(hexString: "4080F0")
            break
        case "Canceled":
            self.status.text = "Pemesanan Obat Batal"
            self.status.textColor = UIColor.init(hexString: "4080F0")
            break
        default:
            self.status.text = "Pesanan Gagal"
            self.status.textColor = .red
            
        }
        
    }
}
