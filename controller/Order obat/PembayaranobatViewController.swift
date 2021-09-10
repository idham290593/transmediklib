//
//  pembayaranobatViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 25/08/21.
//

import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire



class PembayaranobatViewController: UIViewController {
    
    
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var viewtables: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tinggiTableBarang: NSLayoutConstraint!
    @IBOutlet weak var promo: UITextField!
    
    //diskon
    @IBOutlet weak var viewkode: UIView!
    @IBOutlet weak var notediskon: UILabel!
    @IBOutlet weak var biayabarang: UILabel!
    @IBOutlet weak var totalpotongan: UILabel!
    @IBOutlet weak var detailpotongan: UILabel!
    @IBOutlet weak var totalpembayaran: UILabel!
    
    //cour
    
    @IBOutlet weak var imageCour: UIImageView!
    @IBOutlet weak var priceCour: UILabel!
    @IBOutlet weak var nameCour: UILabel!
    
    @IBOutlet weak var myDompetButton: UIButton!
    @IBOutlet weak var saldo: UILabel!
    
    @IBOutlet weak var viewPembayaranLainnya: UIView!
    @IBOutlet weak var topViewpay: UIView!
    @IBOutlet weak var bottomViewPay: UIView!
    @IBOutlet weak var metodePay: UILabel!
    @IBOutlet weak var otherPayButton: UIButton!
    
    
    @IBOutlet weak var konfirmasi: UIView!
    var Voucher = Voucherobject()
    var getmoney = balanceobject()
    var mymoney : Mbalance?
    var datavoucher : ModelVoucer?{
        didSet{
            if datavoucher != nil {
                if notediskon.isHidden {
                    notediskon.isHidden.toggle()
                }
                self.view.layoutIfNeeded()
                if datavoucher!.type == "2"{
                    self.detailpotongan.text = "Potongan " + String(datavoucher!.nominal) + "%"
                }else{
                    self.detailpotongan.text = "Potongan " + String(datavoucher!.nominal)
                }
                
                self.notediskon.text = "Kode promo berhasil dipakai. Anda menghemat \(setmoney(harga: getdiskon()))"
                biayabarang.text = setmoney(harga: totalbarang())
                totalpotongan.text = setmoney(harga: getdiskon())
                totalpembayaran.text = "Rp \(finaltotal().formattedWithSeparator)"

                
            }else{
      
                self.view.layoutIfNeeded()
            }
        }
    }
    
    var detailpayment  : detailpayment?
    var selectCour : Int?
    @IBOutlet weak var viewpromos: UIView!
    var data : GetPriceObat?
    var order = Orderobject()
    var dataorder : [MedicinesPrice]?
    var mylocation : NameMyLocation!
    var saldotext = 0
    var id = ""
    var prescription_id = ""
    var dompet = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getmymoney()
        
       
        
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        self.view.backgroundColor = Colors.backgroundmaster
        notediskon.isHidden.toggle()
        viewpromos.layer.cornerRadius = 8
        nameCour.text = data!.data!.couriers![selectCour!].name!
        priceCour.text = "Rp \(Int(data!.data!.couriers![selectCour!].price!)!.formattedWithSeparator)"
        let url = URL(string: data!.data!.couriers![selectCour!].image!)
        imageCour.kf.setImage(with: url)
        viewkode.layer.cornerRadius = 10
        viewtables.layer.cornerRadius = 10
        konfirmasi.layer.cornerRadius = 10
        self.view.layoutIfNeeded()
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        konfirmasi.backgroundColor = Colors.bluecolor
        konfirmasi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(konfirmasiaction)))
        tinggiTableBarang.constant = table.contentSize.height
        self.view.layoutIfNeeded()
        biayabarang.text = "Rp \(totalbarang().formattedWithSeparator)"
        totalpembayaran.text = "Rp \(finaltotal().formattedWithSeparator)"
        bottomViewPay.isHidden.toggle()
        self.view.layoutIfNeeded()
        viewPembayaranLainnya.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getotherpay)))
        
        
    }
    
    func close() {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func myDompetOnClick(_ sender: Any) {
      
        myDompetButton.setImage(UIImage(named: "Radio Button Active", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!, for: .normal)
        self.detailpayment = nil
        self.dompet = true
        if !bottomViewPay.isHidden {
            bottomViewPay.isHidden.toggle()
        }
        
    }
    
    
    func getmymoney(){
        
        
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
            self.getmoney.confirmConsult(token: token) { (msg, data, status) in
                if msg == "Unauthenticated."{
                    let vc = UIStoryboard(name: "Notification", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "loadingsuccessViewController") as? loadingsuccessViewController
                    UserDefaults.standard.set(true, forKey: "logout")
                    vc?.status =  "gagal login"
                    vc?.delegate = self
                    self.present(vc!, animated: false, completion: nil)
                }
                
                if status{
                    if data != nil {
                        self.mymoney = data
                        self.saldotext = data?.accountbalance ?? 0
                        let _tmp = data?.accountbalance ?? 0
                        self.saldo.text = "Rp \(_tmp.formattedWithSeparator)"
                        
                    }
                    
                    
                }
                
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tinggiTableBarang.constant = table.contentSize.height

    }
    
    @objc func getotherpay(){
        print("getotherpay")
        let vc = UIStoryboard(name: "Orderobat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "metoderpembayaranViewController") as? metoderpembayaranViewController
            vc?.delegate = self
        present(vc!, animated: false, completion: nil)
        
    }
    
    @IBAction func setcode(_ sender: Any) {
        let vc = UIStoryboard(name: "Categoryobat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "includevoucherobatViewController") as? includevoucherobatViewController
        vc?.code = promo.text ?? ""
        vc?.delegate = self
        present(vc!, animated: false, completion: nil)
        
    }
    
    
    
    func totalbarang()-> Int{
        var  _tmptotal = 0
        for index in data!.data!.medicines!{
            _tmptotal += (Int(index.price!)! * index.qty!)
        }
        return _tmptotal
    }
    
    
    
    
    func getdiskon() -> Int{
        var _voucher = 0
        if datavoucher != nil {
            if datavoucher!.type == "2"{
                _voucher = (datavoucher!.nominal * totalbarang()) / 100
            }else{
                _voucher = datavoucher!.nominal
            }
            
        }
        return _voucher
    }
    
    func finaltotal()->Int{
        
        var  _tmptotal = totalbarang()
        if datavoucher != nil {
            _tmptotal -= getdiskon()
        }
        
        _tmptotal += Int(data!.data!.couriers![selectCour!].price!)!
        
        return _tmptotal
    }
}

extension PembayaranobatViewController {
    
    @objc func konfirmasiaction(){
        
        if dompet{
            let vc = UIStoryboard(name: "pinandpassword", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "insertpinViewController") as? insertpinViewController
            vc?.delegate = self
            self.present(vc!, animated: true, completion: nil)
        }else{
            
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                let indexs = data!.data!
                var medicines = ""
                for index in data!.data!.medicines!{
                    if medicines == "" {
                        medicines =  "{ \"medicine_code_partner\": \"\(index.medicine_code_partner!)\",\"name\": \"\(index.name!)\",\"prescription_id\": \(self.prescription_id),\"price\": \(index.price!),\"qty\": \(index.qty!),\"slug\": \"\(index.slug!)\",\"unit\": \"\(index.unit!)\"}"
                    }else{
                        medicines += ",{ \"medicine_code_partner\": \"\(index.medicine_code_partner!)\",\"name\": \"\(index.name!)\",\"prescription_id\": \(self.prescription_id),\"price\": \(index.price!),\"qty\": \(index.qty!),\"slug\": \"\(index.slug!)\",\"unit\": \"\(index.unit!)\"}"
                    }
                   
                }
                let _tmpvoucher = self.datavoucher == nil ?  "null" : self.datavoucher!.slug
                let voceramount = self.datavoucher == nil ? 0 : getdiskon()
                
                
                let paramer = "{\"address\": \"\(mylocation.address)\",\"id\": \(indexs.id!),\"courier\": {\"id\": \(indexs.couriers![selectCour!].id!),\"note\": \"\",\"price\": \(indexs.couriers![selectCour!].price!),\"type\": \"\(indexs.couriers![selectCour!].type!)\"}, \"map_lat\": \"\(mylocation.location.latitude)\", \"map_lng\": \"\(mylocation.location.longitude)\",\"note\": \"\(mylocation.note)\",\"medicines\": [\(medicines)],\"payment_id\": \(detailpayment!.payment_id),\"payment_name\": \"\(detailpayment!.account_name)\",\"pharmacy_address\": \"\(data!.data!.address!)\",\"pharmacy_custNumber\": \"\(data!.data!.pharmacy_custNumber!)\",\"pharmacy_shiptoNumber\": \"\(data!.data!.pharmacy_shiptoNumber!)\",\"pin\": \"null\",\"subtotal\": \(totalbarang()),\"total\": \(finaltotal()), \"voucher\": \(_tmpvoucher),\"voucher_amount\": \(voceramount)}"
                
                print("paramer =>>> " + paramer)
                
                self.order.neworder(token: token, param: paramer) { (msg,trans_merchant_id,url) in
                    
                    if msg == "Unauthenticated."{
                        let vc = UIStoryboard(name: "Notification", bundle: nil).instantiateViewController(withIdentifier: "loadingsuccessViewController") as? loadingsuccessViewController
                        UserDefaults.standard.set(true, forKey: "logout")
                        vc?.status =  "gagal login"
                        vc?.delegate = self
                        self.present(vc!, animated: false, completion: nil)
                    }
                    
                    
                    if msg == "success"{
                        
                        let vc = UIStoryboard(name: "Webviews", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "OpenpdfViewController") as? OpenpdfViewController
                        vc?.headers = "Pembayaran"
                        vc?.delegate = self
                        vc?.urlstring = url!
                        vc?.merchant_id = trans_merchant_id!
                        print("trans_merchant_id >>> " + trans_merchant_id!)
                        self.present(vc!, animated: true, completion: nil)
                        
                        
                        
                    }else{
                        Toast.show(message: msg, controller: self)
                    }
                }
                
                
                
            }
            
        }
        
      
        
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }

    
    
  
    
    
}

extension PembayaranobatViewController :pembayaranrincianobatViewControllerdelegate,insertpinViewControllerdelegate,OpenpdfViewControllerdelegate,openchatfromdoku,metoderpembayaranViewControllerdelegate{
    func send(data: detailpayment) {
        self.detailpayment = data
        self.metodePay.text = data.payment_name
        self.dompet = false
        if self.bottomViewPay.isHidden{
            bottomViewPay.isHidden.toggle()
        }
        
        myDompetButton.setImage(UIImage(named: "Radio Button", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!, for: .normal)
  
        self.view.layoutIfNeeded()
    }
    
    
    
    
    
    func close(_ msg: String, status: Bool) {
        let vc = UIStoryboard(name: "Notification", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "loadingsuccessViewController") as? loadingsuccessViewController
        vc?.texts = status ? "Transaksi berhasil" : "Transaksi gagal"
        vc?.status =  status ? "berhasil" : "gagal"
        vc?.delegate = self
        self.present(vc!, animated: false, completion: nil)
        //
        //
    }
    
    
    //insertpinViewControllerdelegate
    func lanjutpesanan(pin: String) {
        
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
            let indexs = data!.data!
            var medicines = ""
            for index in data!.data!.medicines!{
                if medicines == "" {
                    medicines =  "{ \"medicine_code_partner\": \"\(index.medicine_code_partner!)\",\"name\": \"\(index.name!)\",\"prescription_id\": \(self.prescription_id),\"price\": \(index.price!),\"qty\": \(index.qty!),\"slug\": \"\(index.slug!)\",\"unit\": \"\(index.unit!)\"}"
                }else{
                    medicines += ",{ \"medicine_code_partner\": \"\(index.medicine_code_partner!)\",\"name\": \"\(index.name!)\",\"prescription_id\": \(self.prescription_id),\"price\": \(index.price!),\"qty\": \(index.qty!),\"slug\": \"\(index.slug!)\",\"unit\": \"\(index.unit!)\"}"
                }
               
            }
            let _tmpvoucher = self.datavoucher == nil ?  "null" : self.datavoucher!.slug
            let voceramount = self.datavoucher == nil ? 0 : getdiskon()
            
            
            let paramer = "{\"address\": \"\(mylocation.address)\",\"id\": \(indexs.id!),\"courier\": {\"id\": \(indexs.couriers![selectCour!].id!),\"note\": \"\",\"price\": \(indexs.couriers![selectCour!].price!),\"type\": \"\(indexs.couriers![selectCour!].type!)\"}, \"map_lat\": \"\(mylocation.location.latitude)\", \"map_lng\": \"\(mylocation.location.longitude)\",\"note\": \"\(mylocation.note)\",\"medicines\": [\(medicines)],\"payment_id\": 2,\"payment_name\": \"Escrow\",\"pharmacy_address\": \"\(data!.data!.address!)\",\"pharmacy_custNumber\": \"\(data!.data!.pharmacy_custNumber!)\",\"pharmacy_shiptoNumber\": \"\(data!.data!.pharmacy_shiptoNumber!)\",\"pin\": \"\(pin)\",\"subtotal\": \(totalbarang()),\"total\": \(finaltotal()), \"voucher\": \(_tmpvoucher),\"voucher_amount\": \(voceramount)}"
            print("paramer =>>> " + paramer)
            
            self.order.neworder(token: token, param: paramer) { (msg, trans_merchant_id, url) in
                if msg == "success"{
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        UserDefaults.standard.set(true, forKey: "transaksi")
                        let vc = UIStoryboard(name: "Notification", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "loadingsuccessViewController") as? loadingsuccessViewController
                        vc?.texts = "Selamat! Transaksi Anda Berhasil"
                        self.present(vc!, animated: false, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) {
                            self.dismiss(animated: true, completion: nil)
                            self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                        }
                        
                        
                    }
                    
                }else{
                    Toast.show(message: msg, controller: self)
                }
            }
            
            
            
        }
        
    }
    
    
    
    //metoderpembayaranViewControllerdelegate
    
    
    
    
    //pembayaranrincianobatViewControllerdelegate
    func kode(data: String) {
        promo.text = data
        if promo.text != "" {

            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                    self.Voucher.getvoucher(token: token, code: data, type: 2) { (status, msg, datatmp) in
                        //
                        if msg == "Unauthenticated."{
                            let vc = UIStoryboard(name: "Notification", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "loadingsuccessViewController") as? loadingsuccessViewController
                            UserDefaults.standard.set(true, forKey: "logout")
                            vc?.status =  "gagal login"
                            vc?.delegate = self
                            self.present(vc!, animated: false, completion: nil)
                        }
                        
                        if status{
                            self.datavoucher = datatmp
                            
                        }
                        else{
                            self.datavoucher = nil
                            Toast.show(message: msg, controller: self)
                        }
                    }
                }
            
            
        }else{
            
        }
        
    }
    
    
}


extension PembayaranobatViewController :UITableViewDelegate,UITableViewDataSource{
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  data?.data?.medicines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellpembayaranobatTableViewCell
        let _tmp = data!.data!.medicines![indexPath.row]
        cell.name.text = "\(_tmp.name!) \(_tmp.qty!) @Rp \(Int(_tmp.price!)!.formattedWithSeparator)"
        cell.totalharga.text  =  "Rp \((Int(_tmp.price!)! * _tmp.qty!).formattedWithSeparator)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.layoutIfNeeded()
        tinggiTableBarang.constant = table.contentSize.height

    }
    

}
