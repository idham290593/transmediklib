//
//  listalamatViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 16/08/21.
//

import UIKit
protocol listalamatViewControllerdelegate{
    func ambilalamat(alamat:String , note:String,long:String,lat:String)
}

class listalamatViewController: UIViewController {
    
    
    @IBOutlet var notconnection: UIView!
    
    @IBOutlet weak var navi: UIView!
    @IBOutlet var notfound: UIView!
    
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var add: UIImageView!
    var alamat = Address()
    var loading = false
    @IBOutlet weak var table: UITableView!
    var token = ""
    var data:[AlamatModel] = []
    var tambahalamat = true
    var delegate : listalamatViewControllerdelegate!
    var rowhapus :Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        refresh()
        
//        if !tambahalamat{
//            add.isHidden = true
//        }
        headerlabel.textColor = Colors.headerlabel
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        add.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tambah)))
        shadownavigation.shadownav(view: navi)
    }
    
    
    func refresh(){
        if CheckInternet.Connection(){
            loading = true
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                    self.alamat.getaddress(token: token) { (data) in
                        self.loading = false
                        if data != nil{
                            self.data = data!
                            self.table.backgroundView = nil
                        }else{
                            self.table.backgroundView = self.notfound
                        }
                        self.table.reloadData()

                    }
                
            }
        }else{
            table.backgroundView = notconnection
        }
        
    }
    @objc func tambah(){
        let vc = UIStoryboard(name: "Alamat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "MapviewalamatViewController") as? MapviewalamatViewController
        vc?.delegate = self
        present(vc!, animated: true, completion: nil)
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    
    
}


 extension listalamatViewController : NotificationcustomizeViewControllerdelegate, UITableViewDelegate,UITableViewDataSource,listalamatTableViewCelldelegate,MapviewalamatViewControllerdelegate{
    func next(foraction: String) {
        if rowhapus != nil{
            if  CheckInternet.Connection(){
                alamat.deleteaddress(token: token, id: data[rowhapus!].id) { (status) in
                    if status{
                        self.data.remove(at: self.rowhapus!)
                        self.rowhapus = nil
                        self.table.reloadData()
                    }
                }
            }

        }
        
        
    }
    
    func tambahdata(alamat: AlamatModel) {
        data.append(alamat)
        table.backgroundView = nil
        table.reloadData()
        refresh()
        
        
    }
    
    func editdata(alamat: AlamatModel, row: Int) {
        data[row] = alamat
        table.reloadData()
    }
    
    func edit(row: Int) {
        let vc = UIStoryboard(name: "Alamat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "MapviewalamatViewController") as? MapviewalamatViewController
        vc?.alamatmodel = data[row]
        vc?.delegate = self
        vc?.row = row
        vc?.tambah = false
        
        present(vc!, animated: true, completion: nil)
    }
    
    func delete(row: Int) {
 
        
        
        let vc = UIStoryboard(name: "Notification", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "NotificationcustomizeViewController") as? NotificationcustomizeViewController
        vc?.delegate = self
        rowhapus = row
        
        if data[row].address_type != "Alamat Kantor"{
            vc?.imagetext = "alamathome"
            
        }else{
            vc?.imagetext = "alamatoffice"
            
        }
        vc?.headertext = "Hapus Alamat"
        vc?.desctext = "Apakah anda yakin akan menghapus data Alamat anda?"
        vc?.nexttext = "Hapus"
        vc?.foraction = "hapus alamat"
        
    
        
        present(vc!, animated: false, completion: nil)
    }
    
    func favorit(row: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(data.count)
        return loading ? 1 : data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if loading {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//                as! listalamatTableViewCell
//            cell.backgroundview.layer.shadowColor = UIColor.black.cgColor
//            cell.backgroundview.layer.cornerRadius  = 13
//            cell.backgroundview.layer.shadowOffset = CGSize.zero
//            cell.backgroundview.layer.shadowRadius = 2
//            cell.backgroundview.layer.shadowOpacity = 0.2
            
            
            return cell
        }else{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! listalamatTableViewCell
            cell.backgroundview.layer.shadowColor = UIColor.black.cgColor
            cell.backgroundview.layer.cornerRadius  = 13
            cell.backgroundview.layer.shadowOffset = CGSize.zero
            cell.backgroundview.layer.shadowRadius = 2
            cell.backgroundview.layer.shadowOpacity = 0.2
            print("types")
            print(data[indexPath.row].address_type)
            if data[indexPath.row].address_type == "Alamat rumah"{
                cell.iconrumah.image = UIImage(named: "alamathome")
                print("type1")
                
            }else if data[indexPath.row].address_type == "Tambah alamat lainnya"{
                print("type1")

                cell.iconrumah.image = UIImage(named: "Pin Lokasi")
            }else{
                print("type1")

                cell.iconrumah.image = UIImage(named: "alamatoffice")

            }
            cell.delegate = self
            cell.row = indexPath.row
            cell.headeralamat.text = data[indexPath.row].address_type
            cell.perumahan.text = data[indexPath.row].note
            cell.detailalamat.text = data[indexPath.row].address
            if !tambahalamat{
                cell.love.isHidden = true
                cell.edit.isHidden = true
                cell.hapusalamat.isHidden = true
            }
            cell.love.isHidden = true

            
            
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tambahalamat{
            delegate.ambilalamat(alamat: data[indexPath.row].address, note: data[indexPath.row].note, long: data[indexPath.row].map_lng, lat: data[indexPath.row].map_lat)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
}
