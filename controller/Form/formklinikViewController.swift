//
//  formklinikViewController.swift
//  Pasien
//
//  Created by Idham Kurniawan on 15/03/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//

import UIKit

class formklinikViewController: UIViewController {

    
    var api = FormObject()
   
    var list : [listformmodel] = []
    var valueform : [valuesonform] = []
    var delegate :form_pertanyaan_delegate?
    var typetext = true
    
    @IBOutlet weak var coll: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    



}
//
//extension formklinikViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // dataArary is the managing array for your UICollectionView.
//       
//        let luas = CGSize(width: coll.frame.width, height: CGFloat(48))
//        return luas
//    }
//    
//    
//}
