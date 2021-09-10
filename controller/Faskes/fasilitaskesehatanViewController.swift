//
//  fasilitaskesehatanViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 08/07/21.
//


import UIKit
import Kingfisher

public class fasilitaskesehatanViewController: UIViewController,UITextFieldDelegate, openchatfromdoku {
    
    
    
    @IBOutlet weak var collection: UICollectionView!
    var api = Fasilitaskesehatan()
    var selected = ""
    var mylok = false
    var data :[Fasilitaskesehatanmodel] = []
    var funcspesial = Specialist()
    var nexts = ""
    @IBOutlet weak var viewfield: UIView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var top: UIView!
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var header: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        collection.register(UINib(nibName: "FaskessCollectionViewCell", bundle: AppSettings.bundleframework), forCellWithReuseIdentifier: "FaskessCollectionViewCell")

        viewfield.layer.cornerRadius =  viewfield.layer.frame.height / 2
        viewfield.layer.borderWidth = 1
        viewfield.layer.borderColor = UIColor.lightGray.cgColor
        collection.backgroundColor = Colors.backgroundmaster
        collection.delegate = self
        collection.dataSource = self
        refresh()
//        setnavi()
        header.text = "Klinik"
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        search.delegate = self
        search.returnKeyType = .done
        shadownavigation.shadownav(view: top)
    }
    

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
   
        if search.text != "" {
            searchacc()
        }else{
            refresh()
        }
        self.view.endEditing(true)
        
        return true
    }
 
    func refresh(){
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
            self.api.order(token: token) { (data,nextpage) in
              
                if nextpage == "Unauthenticated."{
                    UserDefaults.standard.set(true, forKey: "logout")
                    self.dismiss(animated: false, completion: nil)
                }
                
                if data != nil {
                    print("bres")
                    self.data = data!
                    self.collection.reloadData()
                }
                if nextpage == nil {
                    self.nexts = ""
                }else{
                    self.nexts = nextpage!
                }
                
            }
        }
    }



    @objc func searchacc(){
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                let cari = self.search.text!.replacingOccurrences(of: " ", with: "%20")
                self.api.ordersearch(token: token ,search : cari ) { (data,nextpage) in
                    if data != nil {
                      
                        self.data = data!
                        self.collection.reloadData()
                        
                    }
                    if nextpage == nil {
                        self.nexts = ""
                    }else{
                        self.nexts = nextpage!
                    }
                    
                }
            }
        
    }
    
    func nextlist(){
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                self.api.url(token: token,url : self.nexts) { (data,nextpage) in
                    if data != nil {
                        
                        for i in 0..<data!.count{
                            self.data.append(data![i])
                            if i == data!.count - 1{
                                self.collection.reloadData()
                            }
                        }
                        
                    }
                    
                    if nextpage == nil {
                        self.nexts = ""
                    }else{
                        self.nexts = nextpage!
                    }
                    
                }
            }
        
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    func close() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
   
}

extension fasilitaskesehatanViewController : UIScrollViewDelegate{
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll = >")
            if collection.contentOffset.y <= CGFloat(-150) && CheckInternet.Connection(){
                
                collection.isScrollEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.collection.isScrollEnabled = true
                }
                if nexts != ""{
                    nextlist()
                }
                
            }
            
        
        
    }
    
    
    
}

extension fasilitaskesehatanViewController:UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FaskessCollectionViewCell", for: indexPath) as! FaskessCollectionViewCell
            let url = URL(string: data[indexPath.row].image)
                cell.images.kf.setImage(with: url)
                cell.label.text = data[indexPath.row].name
                
                return cell
    }
    

    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if CheckInternet.Connection(){
//            loading()
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                    self.funcspesial.getspesialisklinik(token: token ,id: self.data[indexPath.row].id) { (datadokter,msg) in
                        if msg == "Unauthenticated."{
                            let vc = UIStoryboard(name: "Notification", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "loadingsuccessViewController") as? loadingsuccessViewController
                            UserDefaults.standard.set(true, forKey: "logout")
                            vc?.status =  "gagal login"
                            vc?.delegate = self
                            self.present(vc!, animated: false, completion: nil)
                        }
                        
                        if datadokter != nil {
                            if datadokter!.count > 0{
                                let vc = UIStoryboard(name: "Fasilitaskesehatan", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "detailklinikViewController") as? detailklinikViewController
                                vc?.tanyadokter = datadokter!
                                vc?.alamat = self.data[indexPath.row].address
                                vc?.name = self.data[indexPath.row].name
                                vc?.imageurl = self.data[indexPath.row].image
                                vc?.id = self.data[indexPath.row].id
                                vc?.isform = self.data[indexPath.row].medical_form
                                self.present(vc!, animated: true, completion: nil)
//                                self.activityIndicatorView.startAnimating()
                            }else{
                                var list : [listformmodel] = []
                                var valueform : [valuesonform] = []
                                let apifacility = FormObject()
                                apifacility.getform(token: token, id: self.data[indexPath.row].id , spesialist: "") { (data,msg) in
                                    if msg == "Unauthenticated."{
                                        let vc = UIStoryboard(name: "Notification", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "loadingsuccessViewController") as? loadingsuccessViewController
                                        UserDefaults.standard.set(true, forKey: "logout")
                                        vc?.status =  "gagal login"
                                        vc?.delegate = self
                                        self.present(vc!, animated: false, completion: nil)
                                    }
                                    
                                        for index in data {
                                           valueform.append(valuesonform(id: index.id, question: index.question, jawaban: "", required: index.required))
                                        }
                                        list = data
//                                    self.activityIndicatorView.stopAnimating()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            
                                            let vc = UIStoryboard(name: "Tanyadokter", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "DetailtanyadokterViewController") as? DetailtanyadokterViewController
                                            vc?.id = ""
                                            vc?.isform = self.data[indexPath.row].medical_form
                                            vc?.header = self.data[indexPath.row].name
                                            vc?.facilityid = self.data[indexPath.row].id
                                            vc?.list = list
                                            self.present(vc!, animated: true, completion: nil)
                                        }
                                    }
                            }
                           

                        }else{
                           


                            
                        }
                    }
                }
            
        }else{
            Toast.show(message: "tolong cek koneksi anda", controller: self)
        }


     
    
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("Sett")
        return CGSize(width: (self.collection.frame.width - 20) / 2, height:   (self.collection.frame.width - 20 ) / 2)
    }
   
    
}


