//
//  EdituserViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 27/07/21.
//

import UIKit




class EdituserViewController: UIViewController {
    
    
    @IBOutlet weak var labelsend: UILabel!
   
    var uuid = ""
    @IBOutlet weak var child: UIView!
    @IBOutlet weak var send: UIView!
    @IBOutlet weak var viewmaster: UIView!
//    var phr = PHRobject()
    @IBOutlet weak var tittle: UILabel!
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var gambar: UIImageView!

    @IBOutlet weak var tinggitable: NSLayoutConstraint!
    @IBOutlet weak var table: UITableView!
    var delegate: edit_and_add_phrViewControllerdelegate!
    @IBOutlet weak var header: UILabel!
    var kategori = ""
    var typetambah = true

    var datauser  = ModelProfile(uuid: "", full_name: "", email: "", phone_number: "", gender: "", status: "", nik: "", no_kk: "", dob: "", height: "", weight: "", blood: "", relationship: "", allergy: "",created_at : "",updated_at:"", image: "")

    var row = 0
    var complited = false
    var profil = Profile()

    
    override func viewDidLoad() {
        layout()
        super.viewDidLoad()
        table.dataSource  = self
        table.bounces = false
        if typetambah {
            labelsend.text = "Tambah Data"
        }else{
            labelsend.text = "Ubah Data"

        }
        tittle.text = "Personal Heart Record"
        
        header.text = "Kesehatan Umum"
        gambar.image = UIImage(named: "Data kesehatan", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
        tinggitable.constant = CGFloat(100)
        labelsend.text = "Ubah Data"
        send.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendacc)))
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backacc)))
    }
    
    @objc func backacc(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sendacc(){
        
        if let uuid = UserDefaults.standard.string(forKey: AppSettings.uuid), let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                    

                     if self.uuid == uuid{
                         self.profil.updateprofile(data: self.datauser, token: token) { (msg) in
                            if msg.contains("Unauthenticated"){
                                UserDefaults.standard.set(true, forKey: "logout")
                                self.dismiss(animated: false, completion: nil)
                                self.presentingViewController?.dismiss(animated: false, completion: nil)
                            }
                             if msg == "success"{
                                self.delegate.ubahtinggi(tinggi: Int(self.datauser.height) ?? 0, berat: Int(self.datauser.weight) ?? 0, row: self.row)
                                 self.dismiss(animated: false, completion: nil)
                             }else{
                                 Toast.show(message: msg, controller: self)
                             }
                             
                         }
                     }else{
                         self.profil.updatefamily(data: self.datauser, token: token) { (msg) in
                            if msg.contains("Unauthenticated"){
                                UserDefaults.standard.set(true, forKey: "logout")
                                self.dismiss(animated: false, completion: nil)
                                self.presentingViewController?.dismiss(animated: false, completion: nil)
                            }
                             if msg == "success"{
                                self.delegate.ubahtinggi(tinggi: Int(self.datauser.height) ?? 0, berat: Int(self.datauser.weight) ?? 0, row: self.row)
                                 self.dismiss(animated: false, completion: nil)
                             }else{
                                 Toast.show(message: msg, controller: self)
                             }
                         }
                     }
                 }
             
    }
    
}

extension EdituserViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "badan", for: indexPath) as! editphrbadanTableViewCell
        cell.tinggi.text = "\(datauser.height)"
        cell.berat.text = "\(datauser.weight)"
        cell.delegate = self
        
        return cell
    }
    
    
    func layout(){
        child.layer.cornerRadius = 10
        child.layer.shadowColor = UIColor.black.cgColor
        child.layer.shadowOffset = CGSize.zero
        child.layer.shadowRadius = 3
        child.layer.shadowOpacity = 0.3
        send.backgroundColor = Colors.basicvalue
        send.layer.cornerRadius = 10
        
        viewmaster.layer.cornerRadius = 10
        viewmaster.layer.borderColor = UIColor.init(rgb: 0x959393).cgColor
        viewmaster.layer.borderWidth = 1
        
    }
    
}


extension EdituserViewController : editphrbadanTableViewCelldelegate{
    func dismisskeyboards() {
        print("dismis keyboard")
        view.endEditing(true)
    }
    
    
    func kirimtinggi(tinggi: Int) {
        print("1")
        self.datauser.height = "\(tinggi)"
    }
    
    func kirimberat(berat: Int) {
        self.datauser.weight = "\(berat)"
        
    }
    
    
}

