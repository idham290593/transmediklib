//
//  detailklinikVc.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/07/21.
//

import UIKit

class detailklinikVc :UIViewController {
    
    @IBOutlet weak var tinggicoll: NSLayoutConstraint!
    @IBOutlet weak var setgambar: UIImageView!
    @IBOutlet weak var gambar: UIView!

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var back: UIView!
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

    var funcspesial = Specialist()
    var id = ""
    var list : [listformmodel] = []
//    var valueform : [valuesonform] = []
    var api = FormObject()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        coll.register(UINib(nibName: "FaskessCollectionViewCell", bundle: AppSettings.bundleframework), forCellWithReuseIdentifier: "FaskessCollectionViewCell")
        
        
        coll.delegate = self
        coll.dataSource = self
        
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
    

    override func viewDidAppear(_ animated: Bool) {
  
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }

}

extension detailklinikVc : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tanyadokter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! facilitascellCollectionViewCell
//
//            let url = URL(string: tanyadokter[indexPath.row].image)
////
////
//            cell.image.kf.setImage(with: url)
//            cell.name.text = tanyadokter[indexPath.row].name
//        cell.layoutIfNeeded()
//        cell.image.layer.cornerRadius = cell.image.frame.height / 2
//            return UICollectionViewCell()
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FaskessCollectionViewCell", for: indexPath) as! FaskessCollectionViewCell
        let url = URL(string: tanyadokter[indexPath.row].image)
        cell.images.kf.setImage(with: url)
        cell.label.text = tanyadokter[indexPath.row].name
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !CheckInternet.Connection(){
            return Toast.show(message: "Tolong cek koneksi anda terlebih dahulu.", controller: self)
        }
//        self.valueform.removeAll()
//        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
//
//                self.api.getform(token: token, id: self.id , spesialist: self.tanyadokter[indexPath.row].slug) { (data) in
////                    for index in data {
////                        self.valueform.append(valuesonform(id: index.id, question: index.question, jawaban: "", required: index.required))
////                    }
//                    self.list = data
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                        let vc = UIStoryboard(name: "Tanyadokter", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "DetailtanyadokterViewController") as? DetailtanyadokterViewController
//                        vc?.id = self.tanyadokter[indexPath.row].slug
//                        vc?.header = self.tanyadokter[indexPath.row].name
//                        vc?.facilityid = self.id
////                        vc?.valueform = self.valueform
//                        vc?.list = self.list
//                        self.present(vc!, animated: true, completion: nil)
//                    }
//                }
//            }
        
        
  
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        self.view.layoutIfNeeded()
       
        let l = CGSize(width: ((self.coll.frame.width - 15) / 3)  , height: ((self.coll.frame.width - 15) / 3))
        return  l
        
    }
}

