//
//  keluhanpesananobatViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/08/21.
//

import UIKit
import YPImagePicker

struct keluhanobat {
    var keluhan:String
    var check : Bool
}

class keluhanpesananobatViewController: UIViewController,UITextViewDelegate {
    var api = Orderobject()
    var id = ""
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var viewf: UIView!
    var gambarview :UIImage?
    @IBOutlet weak var tinggiview: NSLayoutConstraint!
    @IBOutlet weak var coll: UICollectionView!
    @IBOutlet weak var keluhan: UITextView!
    @IBOutlet weak var countkeluhan: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var cancelgambar: UIImageView!
    var listkeluhan:[keluhanobat] = [
        keluhanobat(keluhan: "Kemasan rusak", check: false),
        keluhanobat(keluhan: "Pesanan tidak sesuai", check: false),
        keluhanobat(keluhan: "Obat kadaluarsa", check: false)]
    @IBOutlet weak var sending: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewf.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        keluhan.delegate = self
        keluhan.returnKeyType = .done
        sending.layer.cornerRadius = 10
        sending.backgroundColor = Colors.basicvalue
        coll.delegate = self
        coll.dataSource = self
        photo.layer.cornerRadius = 10
        keluhan.text = "Tulis komentar anda disini"
        keluhan.textColor = UIColor.init(rgb: 0xC4C4C4)
        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gantigambar)))
        cancelgambar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelphoto)))
        blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        sending.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kirim)))
        
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration : 0.3){
            self.tinggiview.constant = CGFloat(430)
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("disss")
       
        countkeluhan.text = " \(keluhan.text.count)/600"
        if text == "\n" {
            self.view.endEditing(true)
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if keluhan.text == "Tulis komentar anda disini"{
            keluhan.text = ""
            countkeluhan.text = " \(0)/600"

            keluhan.textColor = UIColor.init(rgb: 0x5E5C5C)
        }
       }

       func textViewDidEndEditing(_ textView: UITextView) {

        if keluhan.text == ""{
            keluhan.text = "Tulis komentar anda disini"
            countkeluhan.text = " \(0)/600"
            keluhan.textColor = UIColor.init(rgb: 0xC4C4C4)
        }
       }
    
    
    @objc func kirim(){
        if check(){
            if gambarview != nil {
                
                if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                        self.api.complain(images: self.gambarview!, token: token, id: self.id, note: self.keluhan.text == "Tulis komentar anda disini" ? "" : self.keluhan.text, keluhan: self.listkeluhan) { (status,msg) in
                            print(msg)
                            if status{
                                self.dismiss(animated: false, completion: nil)
                                self.presentingViewController?.dismiss(animated: false, completion: nil)
                                
                            }
                            
                        }
                    }
                
             
            }else{
                Toast.show(message: "Gambar belum anda kirim", controller: self)
            }
        }else{
            Toast.show(message: "Pilih keluhan terlebih dahulu", controller: self)
        }
    }
    
    
    func check()-> Bool{
        var ada = false
        var total = 0
        for index in listkeluhan{
            if index.check{
                ada = true
                total += 1
              
            }
        }
        return ada
    }
    @objc func kembali(){
       dismiss(animated: false, completion: nil)
    }

    @objc func cancelphoto(){
        photo.image = UIImage(named: "")
        gambarview = nil
    }

}

extension keluhanpesananobatViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        listkeluhan[indexPath.row].check = !listkeluhan[indexPath.row].check
        coll.reloadData()
    }
    
    
    @objc func gantigambar(){
        print("ganti gambar")
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
//        config.showsFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        //        config.screens = [.library, .photo , .video ]
        config.screens = [.library, .photo  ]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        
        config.library.onlySquare = false
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        
        
        //        config.video.compression = AVAssetExportPresetHighestQuality
        config.video.fileType = .mov
        config.video.recordingTimeLimit = 60.0
        config.video.libraryTimeLimit = 60.0
        config.video.minimumTimeLimit = 3.0
        config.video.trimmerMaxDuration = 60.0
        config.video.trimmerMinDuration = 3.0
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking  { [unowned picker] items, cancelled in
            var getfoto = false
            for item in items {
                getfoto = true
                switch item {
                case .photo(let photo):
                    print("prhoto")
                    self.gambarview = self.resizeImage(image: photo.image, targetSize: CGSize(width: 800.0, height: 600.0))
                    self.photo.image =  self.gambarview
                    
                case .video(let video):
                    print(video)
                }
                
            }
            picker.dismiss(animated: true, completion: nil)
     
        }
        
    
        present(picker, animated: true, completion: nil)
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
