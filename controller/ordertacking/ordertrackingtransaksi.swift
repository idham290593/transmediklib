//
//  ordertrackingtransaksi.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/08/21.
//

import CoreLocation
import Kingfisher
import UIKit

class ordertrackingtransaksiViewController: UIViewController,CLLocationManagerDelegate {
    
    //
    //komplain view
    //input
    @IBOutlet weak var tinggikomplain: NSLayoutConstraint!
    @IBOutlet weak var dash: UIView!
    
   
    @IBOutlet weak var komplinelisttext: UILabel!
    @IBOutlet weak var desckompline: UILabel!
    @IBOutlet weak var photokompline: UIImageView!
    @IBOutlet weak var nameapotek: UILabel!
    @IBOutlet weak var alamatapotek: UILabel!
    @IBOutlet weak var gambarapotek: UIImageView!
    
    //statik
    @IBOutlet weak var iconkomplain: UIImageView!
    @IBOutlet weak var iconfarmasi: UIImageView!
    
    
    //end komplain view
    //point check
    @IBOutlet weak var point1: UIImageView!
    @IBOutlet weak var point2: UIImageView!
    @IBOutlet weak var point3: UIImageView!
    @IBOutlet weak var point4: UIImageView!
    
    
    
    //header
    @IBOutlet weak var scoll: UIScrollView!
    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var back: UIImageView!
    
    @IBOutlet weak var viewdetailist: UIView!
    //point
    
    @IBOutlet weak var textviewbutkomplain: UILabel!
    @IBOutlet weak var viewshowkomplin: UIView!
   
    @IBOutlet weak var imagestatus: UIImageView!
    @IBOutlet weak var statuspemesanan: UILabel!
    
    //listobat
    
    @IBOutlet weak var waktupemesanan: UILabel!
    @IBOutlet weak var tableobat: UITableView!
    @IBOutlet weak var tinggitable: NSLayoutConstraint!
    
    var isshowkomplain = false{
        didSet{
            settinggikomplain()
//            status(status: data!.order_status)

            if isshowkomplain{
                textviewbutkomplain.text = "Lihat proses utama"
                
            }else{
                textviewbutkomplain.text = "Lihat proses komplain"
               
            }
        }
    }
    var tinggirow :[CGFloat] = []
    {
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
    @IBOutlet weak var totalbelanja: UILabel!
    @IBOutlet weak var biayapengiriman: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var total: UILabel!
    var long : Double?
    var lat : Double?
    var alamattext = ""
    
    //metode pembayaran
    @IBOutlet weak var viewmetodepembayaran: UIView!
    @IBOutlet weak var namepembayaran: UILabel!
    @IBOutlet weak var statuspembayaran: UILabel!
    
    //penerima
    @IBOutlet weak var penerima: UILabel!
    @IBOutlet weak var tlp: UILabel!
    
    //    alamat
    @IBOutlet weak var alamat: UILabel!
    @IBOutlet weak var detailpengiriman: UILabel!
    @IBOutlet weak var imagealamat: UIImageView!
    
    //kurir
    @IBOutlet weak var kurir: UILabel!
    @IBOutlet weak var idkurir: UILabel!
    
    
    @IBOutlet weak var invoice: UILabel!
    @IBOutlet weak var imaginvoice: UIImageView!
    
    
    //    send
    @IBOutlet weak var seinding: UIView!
    @IBOutlet weak var textsending: UILabel!
    
    var token = ""
    var id = ""
    var api = historiesobject()
    var data : ordertrackingtransaksimodel!
    var list :[detailobattraking] = []
    var obat = Obat()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idkurir.text = ""
        layout()
        dash.addDashedBorder(color : UIColor.init(rgb: 0xE5E5E5))
        point1.layer.cornerRadius =  point1.frame.height / 2
       point2.layer.cornerRadius = point1.frame.height / 2
        point3.layer.cornerRadius = point1.frame.height / 2
        point4.layer.cornerRadius = point1.frame.height / 2
        viewshowkomplin.layer.cornerRadius = 10
        scoll.bounces = false
        viewshowkomplin.isHidden.toggle()
        viewshowkomplin.backgroundColor = Colors.basicvalue
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                self.api.getdetailhistory(token: token, id: self.id) { (data, msg) in
                    print("brsz")
                    if msg.contains("Unauthenticated"){
                        UserDefaults.standard.set(true, forKey: "logout")
                        self.dismiss(animated: false, completion: nil)
                        self.presentingViewController?.dismiss(animated: false, completion: nil)
                    }
                    if data != nil {
                        self.list = data!.medicines
                        self.data = data
//                        self.statuspemesanan.text = data!.order_status
                       
                        self.statustext(status: data!.order_status)
                        self.totalbelanja.text = data!.total_order
                        self.biayapengiriman.text  = data!.shipping_fee
                        self.discount.text = "Rp.\(data!.voucher_amount)"
                        self.total.text = data!.total
                        self.penerima.text = data!.consignee
                        self.tlp.text = data!.phone_number
                        self.alamat.text = data!.address
                        self.detailpengiriman.text = data!.note
                        self.kurir.text = data!.courier
                        self.namepembayaran.text = data!.payment_name
                        self.invoice.text = data!.invoice
                        self.statuspembayaran.text = data!.payment_status
//                        self.statuspemesanan.text = data!.order_status
                        self.waktupemesanan.text = data!.order_date
                        
                        
                        if data!.order_status == "Complained" || data!.order_status == "Handled" || data!.order_status == "Solved"{
                            self.viewshowkomplin.isHidden.toggle()
                            
                            self.api.getdetailkeluhan(token: token, id: self.id) { (data, msg) in
                                
                                print("kelauars")
                                
                                if data != nil {
                                    var kompline = ""
                                    if data!.complain_type_name.count > 0 {
                                        for index in data!.complain_type_name{
                                            print("=============")
                                            print(index)
                                            if kompline.count == 0 {
                                                kompline = index
                                            }else{
                                                kompline =  "\(kompline),\(index)"
                                            }
                                            
                                        }
                                    }
                                 
                                
                                    
                                    self.komplinelisttext.text = kompline
                                    self.desckompline.text = data!.desc == "" ? "-" :  data!.desc
                                    let url = URL(string: data!.image_complain)
                                    self.photokompline.kf.setImage(with: url)
                                    let url1 = URL(string: data!.gambarapotek )
                                    self.gambarapotek.kf.setImage(with: url1)
                                    self.nameapotek.text = data!.namaapotek
                                    self.alamatapotek.text = data!.alamatapotek
                                }
                                
                            }
                        }
                        self.tableobat.reloadData()
                    }
                }
            }
        
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        tableobat.delegate = self
        tableobat.dataSource = self
        headerlabel.textColor = Colors.headerlabel
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        seinding.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendingfunc)))
//        viewshowkomplin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ishowing)))
//
//
    }
    
    func settinggikomplain(){
        self.view.layoutIfNeeded()
        let tmp = 80 + 28 + 35 + 28 + 20
        let alamatorphoto = gambarapotek.frame.height > alamatapotek.frame.height ? gambarapotek.frame.height :alamatapotek.frame.height
        let tinggimaterial = CGFloat(tmp)
        
        let totaltinggi  = tinggimaterial + alamatorphoto + komplinelisttext.frame.height + desckompline.frame.height  + nameapotek.frame.height
        UIView.animate(withDuration : 0.5){
            if self.isshowkomplain{
                self.tinggikomplain.constant  = totaltinggi

            }else{
                self.tinggikomplain.constant  = CGFloat(0)

            }
            self.view.layoutIfNeeded()
        }
    }

    func statustext(status : String){
          
        print("statustext >>>" + status )
        switch status {
        case "Unpaid":
            self.statuspemesanan.text = "Menunggu Pembayaran"
            self.statuspemesanan.textColor = .red
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            seinding.isHidden = true

            break
        case "Paid":
            self.statuspemesanan.text = "Transaksi berhasil"
            self.statuspemesanan.textColor = .init(hexString: "FFD600")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order Berhasil", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            seinding.isHidden = true


            break
        case "Accepted":
            self.statuspemesanan.text = "Pesanan diterima Apotik"
            self.statuspemesanan.textColor = UIColor.init(hexString: "005377")
            seinding.isHidden = true
            point1.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order diterima Apotik", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!

            break
        case "Delivery":
            self.statuspemesanan.text = "Pesanan dikirim Apotik"
            self.statuspemesanan.textColor = UIColor.init(hexString: "70C900")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order Dikirim", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            break
        case "Delivered":
            self.statuspemesanan.text = " Pesanan Diterima"
            self.statuspemesanan.textColor = UIColor.init(hexString: "4080F0")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order diterima", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            break
        case "Cancel By System":
            self.statuspemesanan.text = "Pesanan Gagal"
            self.statuspemesanan.textColor = .red
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            seinding.isHidden = true

            break
        case "Rejected":
            self.statuspemesanan.text = "Pesanan Ditolak Apotik"
            self.statuspemesanan.textColor = UIColor.init(hexString: "E75656")
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            seinding.isHidden = true

            break
        case "Payment Failed":
            self.statuspemesanan.text = "Pembayaran Gagal"
            self.statuspemesanan.textColor = .red
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            seinding.isHidden = true

            break
        case "Complained":
            self.statuspemesanan.text = "Kendala diterima"
            self.statuspemesanan.textColor = UIColor.init(hexString: "FFD600")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.isHidden.toggle()
            seinding.isHidden = true

            break
        case "Handled":
            self.statuspemesanan.text = "Kendala Diproses"
            self.statuspemesanan.textColor = UIColor.init(hexString: "005377")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.isHidden.toggle()
            seinding.isHidden = true

            break
            
        case "Solved":
            self.statuspemesanan.text = "Kendala Selesai"
            self.statuspemesanan.textColor = UIColor.init(hexString: "4080F0")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.isHidden.toggle()
            seinding.isHidden = true

            
            break
        case "Canceled":
            self.statuspemesanan.text = "Pemesanan Obat Batal"
            self.statuspemesanan.textColor = UIColor.init(hexString: "4080F0")
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            
            break
        default:
            self.statuspemesanan.text = "Pesanan Gagal"
            self.statuspemesanan.textColor = .red
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            
        }
        
        
        
    }
    

    
    @objc func sendingfunc(){

        if data!.order_status == "Delivered"{
            let vc = UIStoryboard(name: "Ordertracking", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "keluhanpesananobatViewController") as? keluhanpesananobatViewController
            vc?.id = self.id
            
            present(vc!, animated: false, completion: nil)
        }

        
    }
    
    func layout(){
        self.view.layoutIfNeeded()
        
        seinding.layer.cornerRadius = 10
        seinding.layer.borderWidth = 1
        seinding.layer.borderColor  = Colors.basicvalue.cgColor
        tableobat.bounces = false
        
        
    }
    
    
    /*
    func status(status : String){

        switch status {
        case "Paid":

            imagestatus.image =  UIImage(named: "Order Berhasil", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            seinding.isHidden = false
            break

        case "Accepted":
            imagestatus.image =  UIImage(named: "Order diterima Apotik", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            seinding.isHidden = true
            break

        case "Delivery":
            imagestatus.image =  UIImage(named: "Order Dikirim", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            seinding.isHidden = true
            break


        case "Delivered":
            imagestatus.image =  UIImage(named: "Order diterima", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            seinding.backgroundColor = Colors.basicvalue
            textsending.text = "Keluhan"
            textsending.textColor = .white
            seinding.isHidden = false

            break

        case "Solved":

            if isshowkomplain{

                imagestatus.image =  UIImage(named: "kendala solved", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            }else{

                imagestatus.image =  UIImage(named: "order kendala solved", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            }
           
            seinding.backgroundColor = Colors.basicvalue
            textsending.text = "Pesan ulang"
            textsending.textColor = .white
            seinding.isHidden = true

            break







        case "Complained":

            if isshowkomplain{

                imagestatus.image =  UIImage(named: "kendala komplain", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!

            }else{

                imagestatus.image =  UIImage(named: "order kendala komplain", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            }


            seinding.backgroundColor = Colors.basicvalue
            textsending.text = "Keluhan"
            textsending.textColor = .white
            seinding.isHidden = true

            break

        case "Handled":

            if isshowkomplain{

                imagestatus.image =  UIImage(named: "kendala prosess", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!

            }else{

                imagestatus.image =  UIImage(named: "order kendala proses", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            }
     
            seinding.backgroundColor = Colors.basicvalue
            textsending.text = "Keluhan"
            textsending.textColor = .white
            seinding.isHidden = true

            break


        case "Cancel By System":
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            textsending.text = "Pesan ulang"
            seinding.isHidden = true
            break

        default:
            seinding.isHidden = true
            seinding.backgroundColor = Colors.basicvalue
            textsending.text = "Pesan ulang"
            textsending.textColor = .white
            self.statuspemesanan.text = "Transaksi gagal"
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!

        }

    }
    
    
    */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        let loc = CLLocation(latitude: lat!, longitude: long!)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loc) { (locstring, err) in
            if let _ = err {
                return
            }
            let pm = locstring! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = locstring![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                self.alamattext = addressString
                
                //                print(addressString)
            }
            
            
        }
        
        locationManager.stopUpdatingLocation()
        
    }
    
    
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension ordertrackingtransaksiViewController :ordertrackingtransaksiTableViewCelldelegate, UITableViewDelegate,UITableViewDataSource{
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

//
//extension ordertrackingtransaksiViewController : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if data != nil {
//            if data!.order_status == "Complained" || data!.order_status == "Handled" || data!.order_status == "Solved"{
//                return 2
//            }else{
//                return 1
//            }
//        }else{
//            return 0
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "order", for: indexPath) as! checkorderCollectionViewCell
//            self.view.layoutIfNeeded()
//            cell.dash.addDashedBorder(color : UIColor.init(rgb: 0xE5E5E5))
//            cell.status(status: data!.order_status)
//            cell.point1.layer.cornerRadius =  cell.point1.frame.height / 2
//            cell.point2.layer.cornerRadius =  cell.point1.frame.height / 2
//            cell.point3.layer.cornerRadius = cell.point1.frame.height / 2
//            cell.point4.layer.cornerRadius = cell.point1.frame.height / 2
//
//
//            return cell
//        }else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keluhan", for: indexPath) as! checkkeluhanorderCollectionViewCell
//            self.view.layoutIfNeeded()
//            cell.dash.addDashedBorder(color : UIColor.init(rgb: 0xE5E5E5))
//            cell.status(status: data!.order_status)
//            cell.point1.layer.cornerRadius =  cell.point1.frame.height / 2
//            cell.point2.layer.cornerRadius =  cell.point1.frame.height / 2
//            cell.point3.layer.cornerRadius = cell.point1.frame.height / 2
//
//
//            return cell
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // dataArary is the managing array for your UICollectionView.
//
//        return luas
//    }
//
//}
