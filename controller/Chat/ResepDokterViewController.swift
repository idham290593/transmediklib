//
//  ResepDokterViewController.swift
//  Pasien
//
//  Created by Adam M Riyadi on 16/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON
import CDAlertView

protocol ResepDokterViewControllerDelegate: AnyObject {
    func resepDokterClosed()
}

class ResepDokterViewController: MYUIViewController {
    
    var consultation: ConsultationPostModel?
    var date: Date?
    var delegate: ResepDokterViewControllerDelegate?
    var json: JSON?
    var api = resepdigitalobject()
    var resep = [Resepobat]()
    var prescription_id = ""
    var idconsul = ""
//    var consultationEnded: Bool = false {
//        didSet{
//            guard consultationEnded != oldValue else {
//                return
//            }
////            if (consultationEnded) {
////                beliButton.isHidden = false
////            }
////            else {
////                beliButton.isHidden = true
////            }
//        }
//    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.bounces = true
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "back", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil), for: .normal)
        view.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let navigationTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.318, green: 0.765, blue: 0.769, alpha: 1)
        view.font = UIFont(name: "Roboto-Medium", size: 18)
        view.text = LocalizationHelper.getInstance()!.resep_digital
        return view
    }()
    //navigation
    
    private let doctorView: DoctorInfoView = {
        let view = DoctorInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#D8DEE2")
        return view
    }()
    
    private let lineView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#D8DEE2")
        return view
    }()
    
    
    private let pasienView: PasienInfoView = {
        let view = PasienInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let namaObatLabel: UILabel = {
        let view = UILabel()
        view.text = LocalizationHelper.getInstance()?.nama_obat
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(hexString: "#5E5C5C")
        view.font = UIFont(name: "Roboto-Light", size: 14)
        return view
    }()
    
    private let qtyObatLabel: UILabel = {
        let view = UILabel()
        view.text = LocalizationHelper.getInstance()?.jumlah
        view.textAlignment = .right
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(hexString: "#5E5C5C")
        view.font = UIFont(name: "Roboto-Light", size: 14)
        return view
    }()
    
    private let obatStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let berlakuLabel: UILabel = {
        let view = UILabel()
        view.text = LocalizationHelper.getInstance()?.resep_berlaku
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Roboto-Light", size: 15)
        return view
    }()
    private let dateLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.text = LocalizationHelper.getInstance()?.resep_berlaku
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Roboto-Regular", size: 15)
        return view
    }()
    
    private let lineView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#D8DEE2")
        return view
    }()
    
    private let checkbox: UICheckBox = {
        let view = UICheckBox()
        view.isChecked = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle(" \(LocalizationHelper.getInstance()!.ingatkan_saya)", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont(name: "Roboto-Light", size: 15)
        return view
    }()
    
    private let beliButton: UIPrimaryButton = {
        let view = UIPrimaryButton(type: .system)
        view.setTitle(LocalizationHelper.getInstance()?.beli_sekarang, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        
        initializeDatas()
        setupObatStackView()
        setupSubViews()
        setupActions()
    }
    
    

    
    func initializeDatas() {
        
        doctorView.user = consultation?.doctor
        doctorView.date = date
        
        pasienView.user = consultation?.patient
        
        
        var expires = json!["expires"].string
        expires = String(expires?.prefix(10) ?? "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: expires!)
        
        dateFormatter.dateFormat = "E, d MMM yyyy"
        expires = dateFormatter.string(from: date!)
        
        dateLabel.text = expires
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        beliButton.addTarget(self, action: #selector(beliButtonDidTap), for: .touchUpInside)
        checkbox.addTarget(self, action: #selector(checkboxDidTap), for: .touchUpInside)
    }
    private func setupSubViews() {
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        view.addSubview(navigationTitle)
        navigationTitle.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 15).isActive = true
        navigationTitle.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        
        view.addSubview(doctorView)
        doctorView.topAnchor.constraint(equalTo: navigationTitle.bottomAnchor, constant: 20).isActive = true
        doctorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        doctorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        doctorView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: doctorView.bottomAnchor, constant: 5).isActive = true
        lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        doctorView.layoutIfNeeded()
        view.layoutSubviews()
        
        var height = backButton.frame.height + doctorView.frame.height + lineView.frame.height + 20 + 20 + 5 + 15
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 5).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        contentView.addSubview(pasienView)
        pasienView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        pasienView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        pasienView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        pasienView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        pasienView.layoutIfNeeded()
        
        contentView.addSubview(lineView2)
        lineView2.topAnchor.constraint(equalTo: pasienView.bottomAnchor, constant: 5).isActive = true
        lineView2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        lineView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        lineView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        contentView.addSubview(namaObatLabel)
        contentView.addSubview(qtyObatLabel)
        
        namaObatLabel.sizeToFit()
        qtyObatLabel.sizeToFit()
        namaObatLabel.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 15).isActive = true
        namaObatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        
        qtyObatLabel.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 15).isActive = true
        qtyObatLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        contentView.addSubview(obatStackView)
        obatStackView.topAnchor.constraint(equalTo: namaObatLabel.bottomAnchor, constant: 0).isActive = true
        obatStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        obatStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        berlakuLabel.sizeToFit()
        dateLabel.sizeToFit()
        checkbox.sizeToFit()
        beliButton.sizeToFit()
        contentView.addSubview(berlakuLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(lineView3)
        contentView.addSubview(checkbox)
        contentView.addSubview(beliButton)
        
        berlakuLabel.topAnchor.constraint(equalTo: obatStackView.bottomAnchor, constant: 10).isActive = true
        berlakuLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: obatStackView.bottomAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        lineView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView3.centerYAnchor.constraint(equalTo: berlakuLabel.centerYAnchor).isActive = true
        lineView3.leadingAnchor.constraint(equalTo: berlakuLabel.trailingAnchor, constant: 3).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: lineView3.trailingAnchor, constant: 3).isActive = true
        lineView3.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -3).isActive = true
        
        checkbox.topAnchor.constraint(equalTo: berlakuLabel.bottomAnchor, constant: 10).isActive = true
        checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        
        beliButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true

//        co ntentView
        beliButton.topAnchor.constraint(equalTo: berlakuLabel.bottomAnchor, constant: 10).isActive = true
        beliButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        beliButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        checkbox.isHidden = true
        contentView.sizeToFit()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
//        height = pasienView.frame.height + lineView2.frame.height + obatStackView.frame.height + berlakuLabel.frame.height + namaObatLabel.frame.height + checkbox.frame.height + beliButton.frame.height + 5 + 10 + 15 + 10 + 10 + 10 + 25 + 35 + 100
        
        
        height = pasienView.frame.height + lineView2.frame.height + obatStackView.frame.height + berlakuLabel.frame.height + namaObatLabel.frame.height + checkbox.frame.height + 5 + 10 + 15 + 10 + 10 + 10 + 25 + 35 + 100
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        
        scrollView.layoutIfNeeded()
        view.layoutIfNeeded()
//        if (!consultationEnded) {
//            beliButton.isHidden = true
//        }
    }
    
    
    func setupObatStackView() {
        view.layoutSubviews()
        print("resep")
        print(consultation)
        
        print(json)
        let height = backButton.frame.height + doctorView.frame.height + pasienView.frame.height + lineView.frame.height + lineView2.frame.height + 20 + 20 + 5 + 5
        idconsul = String(consultation!.consultation_id!)
        for (key,subJson):(String, JSON) in json!["recipes"] {
            if prescription_id == "" {
                prescription_id = subJson["prescription_id"].stringValue
            }
            let _view : UIResepStaticTableViewCell = {
                let view = UIResepStaticTableViewCell()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.json = subJson
                view.contentMode = .scaleAspectFit
                return view
            }()
            _view.sizeToFit()
            _view.setNeedsLayout()
            _view.layoutIfNeeded()
            obatStackView.addArrangedSubview(_view)
        }
        obatStackView.sizeToFit()
        obatStackView.setNeedsLayout()
        obatStackView.layoutIfNeeded()
    }
    
    @objc func backBtnDidTap(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func beliButtonDidTap(){
//        Toast.show(message: "Beli Obat", controller: self)//

        print("beliButtonDidTap")
        let alert = CDAlertView(title: "Pembelian Obat", message: "Apakah ingin memperbaharui keranjang belanja?", type: .warning)

        let yesAction = CDAlertViewAction(title: LocalizationHelper.getInstance().yes) { (CDAlertViewAction) -> Bool in

            let vc = UIStoryboard(name: "Orderobat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "OrderobatViewController") as? OrderobatViewController
            vc?.id = self.idconsul
            vc?.prescription_id = self.prescription_id
            self.present(vc!, animated: true, completion: nil)

            return true
        }
        let noAction = CDAlertViewAction(title: LocalizationHelper.getInstance().no) { (CDAlertViewAction) -> Bool in
            return true
        }

        alert.add(action: noAction)
        alert.add(action: yesAction)
        alert.show()

    }
    
    @objc func checkboxDidTap(){
        checkbox.isChecked = !(checkbox.isChecked)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.resepDokterClosed()
    }
    
   
    
  
    
//    func getmodelobat(){
//        for (i,index) in self.resep.enumerated() {
//            var field : Cartobat!
//            field = Cartobat(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
//            field.jumlah = NSDecimalNumber(value: index.qty )
//            field.slug = index.slug
//            field.idtransaksi = "\(index.id)"
//            field.prescription_id = "\(self.prescription_id)"
//            field.harga = NSDecimalNumber(value: 0 )
////            self.db.tambahpesananobat(data: field) { ( _ ) in
////                if i == self.resep.count - 1 {
////                    self.db.requestobat { (obat) in
////                        if obat != nil {
////                            let vc = UIStoryboard(name: "Categoryobat", bundle: nil).instantiateViewController(withIdentifier: "CategoryobatViewController" ) as? CategoryobatViewController
////                            vc?.resepobat = true
////                            self.present(vc!, animated: false, completion: nil)
////                                                
////                        }
////                    }
////                 
////                }
////            }
//            
//            
//        }
//    }
    

    

}
