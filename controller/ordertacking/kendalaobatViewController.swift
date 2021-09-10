//
//  kendalaobatViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/08/21.
//

import UIKit
import Kingfisher



class kendalaobatViewController: UIViewController {

    
    @IBOutlet weak var tinggitable: NSLayoutConstraint!
    @IBOutlet weak var scroll: UIScrollView!
    
    
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var headerlabel: UILabel!
    
    @IBOutlet weak var status1: UIImageView!
    @IBOutlet weak var status2: UIImageView!
    @IBOutlet weak var status3: UIImageView!
    @IBOutlet weak var gambarstatus: UIImageView!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var tableobat: UITableView!
    
    @IBOutlet weak var totalbelanja: UILabel!
    @IBOutlet weak var biayapengiriman: UILabel!
    @IBOutlet weak var disc: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var collkeluhan: UICollectionView!
    @IBOutlet weak var viewdesckeluhan: UIView!
    @IBOutlet weak var desckeluhan: UITextView!
    @IBOutlet weak var countdesc: UILabel!
    
    
    @IBOutlet weak var gambar: UIImageView!
    
   
    var api = historiesobject()
    var data : keluhanorderobat?
    var id = ""
    
    var listkeluhan:[keluhanobat] = [
        keluhanobat(keluhan: "Kemasan Rusak", check: false),
        keluhanobat(keluhan: "Pesanan Tidak Sesuai", check: false),
        keluhanobat(keluhan: "Obat Kadaluarsa", check: false)]
    var list :[detailobattraking] = []
    var tinggirow :[CGFloat] = []{
        didSet{
            if tinggirow.count == list.count{
                var i :CGFloat = 0.0
                for index in tinggirow{
                    i += index
                }
                tinggitable.constant = i
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerlabel.textColor = Colors.headerlabel
        tableobat.delegate = self
        tableobat.dataSource = self
        collkeluhan.delegate = self
        collkeluhan.dataSource = self
        desckeluhan.isEditable = false
        scroll.bounces = false
        viewdesckeluhan.layer.cornerRadius = 10
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                self.api.getdetailkeluhan(token: token, id: self.id) { (data, msg) in
                    print("brsz")
                    
                    
                    if msg.contains("Unauthenticated"){
                        UserDefaults.standard.set(true, forKey: "logout")
                        self.dismiss(animated: false, completion: nil)
                        self.presentingViewController?.dismiss(animated: false, completion: nil)
                    }
                    if data != nil {
                       if data!.complain_type_name.count > 0 {
                            for index in data!.complain_type_name{
                                for i in 0..<self.listkeluhan.count{
                                    if self.listkeluhan[i].keluhan == index{
                                        self.listkeluhan[i].check = true
                                    }
                                }
                            }
                        }
                        
                        //
                        self.total.text = "\(data!.total)"
                        self.waktu.text = data!.order_date
                        let url = URL(string: data!.image_complain)
                        self.gambar.kf.setImage(with: url)
                        self.desckeluhan.text = data!.desc
                        self.countdesc.text = "\(data!.desc.count)/600"
                        self.disc.text = "\(data!.voucher_amount)"
                        self.status(status: data!.order_status)
                        self.list = data!.detail
                        self.collkeluhan.reloadData()
                        self.tableobat.reloadData()
                    }

                }
            }
        
        
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    
    func status(status : String){
        
        switch status {
        case "Complained":
            status1.image = UIImage(named: "Check")
            gambarstatus.image = UIImage(named: "solusi1")
            
        case "Handled":
            status1.image = UIImage(named: "Check")
            status2.image = UIImage(named: "Check")
            gambarstatus.image = UIImage(named: "solusi2")

        case "Solved":
            status1.image = UIImage(named: "Check")
            status2.image = UIImage(named: "Check")
            status3.image = UIImage(named: "Check")
            gambarstatus.image = UIImage(named: "solusi3")

        default:
            print("")
        }
    }

}

extension kendalaobatViewController:UITableViewDelegate , UITableViewDataSource,ordertrackingtransaksiTableViewCelldelegate{
    
    func tinggi(t: CGFloat) {
        tinggirow.append(t)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ordertrackingtransaksiTableViewCell
        cell.jumlahobat.text = "\(list[indexPath.row].qty) x "
        cell.namaobat.text = list[indexPath.row].name
        cell.rupiah.text = list[indexPath.row].price

        cell.delegate = self
        
        return cell
    }
    
    
}

extension kendalaobatViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listkeluhan.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! keluhanpesananobatcollCell
        
        cell.layer.cornerRadius = 8
        cell.nama.text = listkeluhan[indexPath.row].keluhan
        if listkeluhan[indexPath.row].check {
            cell.backgroundColor = Colors.basicvalue
            cell.nama.textColor = UIColor.white
        }else{
            cell.backgroundColor = UIColor.init(rgb: 0xF0F0F0)
            cell.nama.textColor = UIColor.init(rgb: 0x5E5C5C)

            

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        let item = listkeluhan[indexPath.row].keluhan
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)
        ])
        let luas = CGSize(width: itemSize.width + CGFloat(30), height: CGFloat(35))
        return luas
    }
    
}
