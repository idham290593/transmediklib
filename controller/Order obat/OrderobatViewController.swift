//
//  OrderobatViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 10/08/21.
//

import UIKit
import CoreLocation
import Kingfisher

struct NameMyLocation {
    var location : CLLocationCoordinate2D
    var address,note : String
}
class OrderobatViewController: UIViewController,CLLocationManagerDelegate, listalamatViewControllerdelegate {
    
    
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var tableResep: UITableView!
    @IBOutlet weak var hightable: NSLayoutConstraint!
    @IBOutlet weak var tableKurir: UITableView!
    @IBOutlet weak var hightTableKurir: NSLayoutConstraint!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var edit: UIImageView!
    @IBOutlet weak var alamat: UILabel!
    @IBOutlet weak var catatan: UITextField!
    
    //note
    
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var imageNote: UIImageView!
    @IBOutlet weak var labelNote: UILabel!
    
    
    var selectcour : Int?
    var loading = false{
        didSet{
            if loading{
                self.loading(self)
            }else{
                self.closeloading(self)
            }
        }
    }
    let locationManager = CLLocationManager()
    var api = Obat()
    var location : NameMyLocation?{
        didSet{
            print("location set")
        }
    }
    var id = ""
    var prescription_id = ""
    var data : GetPriceObat?
    var resepobat = [Resepobat]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableResep.delegate = self
        tableResep.dataSource = self
        tableKurir.delegate = self
        tableKurir.dataSource = self
        self.hightable.constant = tableResep.contentSize.height
        self.hightTableKurir.constant = tableKurir.contentSize.height
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        getresep()
        saveButton.layer.cornerRadius = 10
        
        edit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setalamat)))
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        
        
    }

    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    func refreshlayout(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.hightable.constant = self.tableResep.contentSize.height
            self.hightTableKurir.constant = self.tableKurir.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func pesan(_ sender: Any) {
        if self.selectcour == nil {
            return Toast.show(message: "Anda belum memilih jasa pengiriman", controller: self)
        }
        
       if self.location == nil {
            return Toast.show(message: "Alamat pengiriman belum terisi.", controller: self)
        }
        
        let vc = UIStoryboard(name: "Orderobat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "PembayaranobatViewController") as? PembayaranobatViewController
        vc?.data = self.data
        vc?.selectCour = self.selectcour
        vc?.mylocation = self.location
        vc?.prescription_id = prescription_id
        vc?.id = id
        
        present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let tmplocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let loc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print("get my location")
        print(tmplocation)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loc) { (locstring, err) in
            if let _ = err {
                return print("error cuy")
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
                
                print(addressString)
                self.alamat.text = addressString
                self.location = NameMyLocation(location: tmplocation, address: addressString, note: "")
                //                print(addressString)
            }
            
            
        }
        
        locationManager.stopUpdatingLocation()
        
    }
    
    
    
    
    func ambilalamat(alamat: String, note: String, long: String, lat: String) {
        let tmplocation = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
        self.location = NameMyLocation(location: tmplocation, address: alamat, note: note)

        
        
        self.alamat.text = alamat
        self.catatan.text = note
        
        getprice()
        
    }
    
    @objc func setalamat(){
        let vc = UIStoryboard(name: "Alamat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "listalamatViewController") as? listalamatViewController
        vc?.delegate = self
        vc?.tambahalamat = false
        present(vc!, animated: true, completion: nil)
    }
    
    func getprice(){
        if  let token = UserDefaults.standard.string(forKey:  AppSettings.Tokentransmedik){
            var model = [reqpriceobat]()
            for (i,index) in self.resepobat.enumerated(){
       
                model.append(reqpriceobat(medicine: index.slug!, qty: index.qty!, prescription_id: index.prescription_id!, code: index.medicine_code_partner!))
               
            }
            self.api.getprice(token: token, long:
                                "\(self.location?.location.longitude ?? 0.0)", lat: "\(self.location?.location.longitude ?? 0.0)", data: model) { (status,data,msg) in
                
                if data != nil {
                    print("data not nul")
                    self.data = data
                    self.tableResep.reloadData()
                    self.tableKurir.reloadData()
                    self.refreshlayout()
                    self.viewNote.isHidden.toggle()
                
                }else{
                    self.labelNote.text = msg
                }
            }
        }
    }
    
    func getresep(){
        if CheckInternet.Connection(){
            if  let token = UserDefaults.standard.string(forKey:  AppSettings.Tokentransmedik){
                self.loading = true
                api.getresep(token: token, id: id) { (status, dataresep,msg) in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.loading = false
//
//                    }

                    if status {
                        print(1)
                        if dataresep != nil{
                            self.resepobat = dataresep!
                            self.getprice()
                          
                        }else{
                            self.labelNote.text = msg ?? ""
                        }
                    
                        
                    }else{
                        self.labelNote.text = msg ?? ""
                    }
                }
            }
        }else{
            labelNote.text = "Internet tidak terhubung. Tolong cek kembali koneksi anda!"
        }
 
        
    }
}



extension OrderobatViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("medicines")
        print(data?.data?.medicines?.count ?? 0)
        print("medicines")
        print(data?.data?.couriers?.count ?? 0)
        switch tableView {
        case tableResep:
            return  data?.data?.medicines?.count ?? 0
        case tableKurir:
            return  data?.data?.couriers?.count ?? 0
        default:
            fatalError()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tableResep:
            if data != nil {
                let index = data?.data?.medicines?[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cartobatpriceTableViewCell
                cell.namaobat.text = "\(index?.name ?? "") @Rp\(Int(index!.price ?? "0")!.formattedWithSeparator)"
                let total = Int(index!.price!)! * index!.qty!
                cell.harga.text = "Rp \(total.formattedWithSeparator)"
                cell.qty.text = "  \(index!.qty!)  "
                cell.qty.layer.borderWidth = 1
                cell.qty.layer.borderColor = UIColor.black.cgColor
                
                return cell
                
            }
        case tableKurir:
            if data != nil {
                let index = data?.data?.couriers?[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListcourTableViewCell
                
                
                
                let url = URL(string:  index?.image ?? "")
                cell.gambar.kf.setImage(with: url)
                cell.name.text = index?.name!
                cell.price.text = "Rp \(Int(index?.price ?? "0")!.formattedWithSeparator)"
                if selectcour != nil {
                    if selectcour! == indexPath.row{
                        cell.check.image = UIImage(named: "Radio Button Active", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                        
                    }else{
                        cell.check.image =   UIImage(named: "Radio Button", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                      
                        
                    }
                    
                }else{
                    cell.check.image =   UIImage(named: "Radio Button", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                }
                
                
                
                return cell
                
            }
        default:
            break
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableKurir{
            selectcour = indexPath.row
            tableKurir.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return  UITableViewAutomaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.layoutIfNeeded()
        switch tableView {
        case tableResep:
            print("tableResep")
            print(tableResep.contentSize.height)
            hightable.constant = tableResep.contentSize.height
            self.view.layoutIfNeeded()
            
            
        case tableKurir:
            print("tableKurir")
            
            print( tableKurir.contentSize.height)
            hightTableKurir.constant = tableKurir.contentSize.height
            self.view.layoutIfNeeded()
            
        default:
            break
        }
    }
    
    
}
