//
//  detailklinikViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 08/07/21.
//

import UIKit
import Kingfisher
import CoreGraphics


public class detailklinikViewController: UIViewController, openchatfromdoku {
 
    

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var tinggicoll: NSLayoutConstraint!
    @IBOutlet weak var setgambar: UIImageView!
    @IBOutlet weak var gambar: UIView!
    @IBOutlet weak var nameklinik: UILabel!
    @IBOutlet weak var collview: UIView!
    @IBOutlet weak var alamatklinik: UILabel!
    @IBOutlet weak var coll: UICollectionView!
    var imageurl = ""
    var name = ""
    var alamat = ""
    var token = ""

    var tanyadokter : [Tanyadokter] = []
    var loading = false
    var isform = false
    var funcspesial = Specialist()
    var id = ""
    var list : [listformmodel] = []
//    var valueform : [valuesonform] = []
    var api = FormObject()

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        coll.delegate = self
        coll.dataSource = self
        print("isform = > \(isform)" )

        let url = URL(string: imageurl)
        setgambar.kf.setImage(with: url)
        nameklinik.text = name
        alamatklinik.text = alamat
        collview.layer.cornerRadius = 10
        collview.layer.borderWidth = 1
        collview.layer.borderColor = UIColor.lightGray.cgColor
     
        self.view.layoutIfNeeded()
        let dd:CGFloat = CGFloat(tanyadokter.count) / 3.0
        let round:Int = Int(dd.rounded(.up))
        header.text = "Klinik"
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        tinggicoll.constant = (((self.view.frame.width - 20) / 3)) * CGFloat(round)
        
        self.view.layoutIfNeeded()
       
        
    }
    
    func close() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    public override func viewDidAppear(_ animated: Bool) {
  
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }

}

extension detailklinikViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tanyadokter.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FaskessCollectionViewCell
        
        let url = URL(string: tanyadokter[indexPath.row].image)
        
    
        cell.images.kf.setImage(with: url)
        cell.label.text = tanyadokter[indexPath.row].name
    cell.layoutIfNeeded()
    cell.images.layer.cornerRadius = cell.images.frame.height / 2
        return cell
        
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !CheckInternet.Connection(){
            return Toast.show(message: "Tolong cek koneksi anda terlebih dahulu.", controller: self)
        }

        if isform{
            
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                    self.api.getform(token: token, id: self.id , spesialist: self.tanyadokter[indexPath.row].slug) { (data,msg) in

                        
                        if msg == "Unauthenticated."{
                            let vc = UIStoryboard(name: "Notification", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "loadingsuccessViewController") as? loadingsuccessViewController
                            UserDefaults.standard.set(true, forKey: "logout")
                            vc?.status =  "gagal login"
                            vc?.delegate = self
                            self.present(vc!, animated: false, completion: nil)
                        }
                        
                        
                        self.list = data
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            let vc = UIStoryboard(name: "Tanyadokter", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "DetailtanyadokterViewController") as? DetailtanyadokterViewController
                            vc?.id = self.tanyadokter[indexPath.row].slug
                            vc?.header = self.tanyadokter[indexPath.row].name
                            vc?.facilityid = self.id
                            vc?.isform = self.isform
                            vc?.list = self.list
                            self.present(vc!, animated: true, completion: nil)
                        }
                    }
                }
            
        }else{
            let vc = UIStoryboard(name: "Tanyadokter", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "DetailtanyadokterViewController") as? DetailtanyadokterViewController
            vc?.id = self.tanyadokter[indexPath.row].slug
            vc?.header = self.tanyadokter[indexPath.row].name
            vc?.facilityid = self.id
            vc?.isform = self.isform
            vc?.list = self.list
            self.present(vc!, animated: true, completion: nil)
        }
        
  
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        self.view.layoutIfNeeded()
       
        let l = CGSize(width: ((self.coll.frame.width - 15) / 3)  , height: ((self.coll.frame.width - 15) / 3))
        return  l
        
    }
}

