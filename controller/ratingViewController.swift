//
//  ratingViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 28/07/21.
//

import UIKit
import FloatRatingView
struct modelrating {
    var keluhan:String
    var check :Bool
}
protocol ratingViewControllerdelegate  {
    func kembalirating()
}

class ratingViewController: MYUIViewController,UITextViewDelegate {
    var delegate :ratingViewControllerdelegate!
    var ratingstring = ""{
        didSet{
            print(ratingstring)
        }
    }
    
    @IBOutlet weak var blur: UIVisualEffectView!
    
    @IBOutlet weak var views: UIView!
    var id = ""
    var api = ratingobject()
    var data :[modelrating] = [modelrating(keluhan: "Mudah dan cepat", check: false),modelrating(keluhan: "Dokter Profesional", check: false),modelrating(keluhan: "Biaya terjangkau", check: false)]
    @IBOutlet weak var tinggi: NSLayoutConstraint!
    @IBOutlet weak var sending: UIView!
    @IBOutlet weak var totaldesc: UILabel!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var viewdeszc: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rating.backgroundColor = UIColor.clear
        collection.delegate = self
        collection.dataSource = self
        rating.delegate = self
        rating.contentMode = UIView.ContentMode.scaleAspectFit
        rating.type = .wholeRatings
        rating.type = .wholeRatings
        desc.delegate = self
        desc.returnKeyType = .done
        views.layer.shadowColor = UIColor.black.cgColor
        views.layer.shadowOffset = CGSize.zero
        views.layer.shadowRadius = 2
        views.layer.shadowOpacity = 0.2
        
        
        viewdeszc.layer.cornerRadius = 8
        sending.layer.cornerRadius = 10
        views.layer.cornerRadius = 20
        sending.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kirim)))
        blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        
        
        
        
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func kirim(){
        if ratingstring == "" || ratingstring == "0" {
            return Toast.show(message: "anda belum mengisi rating ", controller: self   )
        }
        
        var comen :[String] = []
        for index in data{
            if index.check{
                comen.append(index.keluhan)
            }
        }
        if comen.count == 0{
            return Toast.show(message: "anda belum memilih komentar ", controller: self   )

        }
        
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                self.api.pushrating(token: token, commen: comen, id: self.id, desc: self.desc.text, rating: self.ratingstring) { ( status) in
                    if status == "berhasil"{
                        self.delegate.kembalirating()
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        Toast.show(message: status, controller: self)
                    }
                }
            }
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        totaldesc.text = " \(desc.text.count)/600"
        if text == "\n" {
            dismissKeyboard()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if desc.text == "" {
            desc.text = "Tulis Komentar . . ."
            desc.textColor = UIColor.init(rgb: 0xc4c4c4)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if desc.text == "Tulis Komentar . . ." {
            desc.text = ""
            desc.textColor = .black
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration : 0.3){
            self.tinggi.constant = CGFloat(450)
            self.view.layoutIfNeeded()
        }
        
    }
    
}

extension ratingViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if data[indexPath.row].check{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "check", for: indexPath) as! ratingCollectionViewCell
            cell.layer.cornerRadius = 8
            cell.title.text = data[indexPath.row].keluhan
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uncheck", for: indexPath) as! ratingCollectionViewCell
            cell.layer.cornerRadius = 8
            cell.title.text = data[indexPath.row].keluhan

            return cell
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         data[indexPath.row].check = !data[indexPath.row].check
        self.collection.reloadData()
    }
    
    
    
}


extension ratingViewController: FloatRatingViewDelegate {
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        dismissKeyboard()

        ratingstring = String(format: "%.0f", self.rating.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        dismissKeyboard()

        ratingstring = String(format: "%.0f", self.rating.rating)
    }
    
}

