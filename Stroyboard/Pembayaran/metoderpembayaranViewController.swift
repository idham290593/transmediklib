//
//  metoderpembayaranViewController.swift
//  Pasien
//
//  Created by Idham Kurniawan on 10/12/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import UIKit
protocol metoderpembayaranViewControllerdelegate {
    func send(data : detailpayment)
}

class metoderpembayaranViewController: UIViewController {
    
    
    @IBOutlet weak var tables: UITableView!
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var back: UIView!
    var pay : modelpayment?
    var api = paymentobject()
    var delegate :metoderpembayaranViewControllerdelegate!
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.text = "Pilih jenis pembayaran"
        tables.delegate = self
        tables.dataSource = self
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        if CheckInternet.Connection(){
                if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                    self.loading = true
                    self.tables.reloadData()
                    
                    self.api.getpayment(token: token) { (status, msg, data) in
                        self.loading = false
                        
                        if status{
                            self.pay = data
                      
                            self.tables.reloadData()
                        }else{
                            Toast.show(message: msg, controller: self)
                            self.tables.reloadData()
                        }
                    }
                }
            
            
        }
        
        
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
}

extension metoderpembayaranViewController : UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if loading {
            return 1
        }else{
            return 5
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if loading  {
            return 1
        }else{
            return 5
        }
    }
    //
    //    func section
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !loading  {
            switch section {
            case 0:
                if pay?.EWallet == nil || pay?.EWallet.count == 0{
                    return nil
                    
                }else{
                    return "E-Wallet"
                    
                }
            case 1:
                if pay?.Bank_Transfer == nil || pay?.Bank_Transfer.count == 0{
                    return nil
                }else{
                    return "Bank Transfer"
                    
                }
            case 2:
                if pay?.VAccount == nil || pay?.VAccount.count == 0{
                    return nil 
                }else{
                    
                    return "Virtual Account Bank"
                }
            case 3:
                if pay?.Debit == nil || pay?.Debit.count == 0{
                    return nil
                }else{
                    
                    return "Debit / Credit Card"
                }
                
            case 4:
                if pay?.Asuransi == nil || pay?.Asuransi.count == 0{
                    return nil
                }else{
                    
                    return "Asuransi"
                }
            default:
                fatalError()
            }
            
        }else{
            return nil
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.init(rgb: 0xE9F8F8)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !loading  {
            
            switch section {
            case 0:
                return pay?.EWallet.count ?? 0
            case 1:
                return pay?.Bank_Transfer.count ?? 0
            case 2 :
                return pay?.VAccount.count ?? 0
            case 3 :
                return pay?.Debit.count ?? 0
            case 4 :
                return pay?.Asuransi.count ?? 0
            default:
                fatalError()
            }
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !loading {
            
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! pembayaranselectedTableViewCell
                
                cell.namebank.text = pay!.EWallet[indexPath.row].payment_name
                cell.desc.text = "Transfer melalui akun ," + pay!.EWallet[indexPath.row].payment_name + " anda guna lanjutkan pembayaran"
                
//                switch pay!.EWallet[indexPath.row].payment_name {
//                case "OVO":
//                    cell.images.image = UIImage(named: "ovo")
//                    break
//
//                case "Dana":
//                    cell.images.image = UIImage(named: "dana")
//                    break
//
//                default:
//                    print("errors")
//                }
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! pembayaranselectedTableViewCell
                
                cell.namebank.text = "Transfer " + pay!.Bank_Transfer[indexPath.row].payment_name
             
                cell.desc.text = "Transfer melalui akun ," + pay!.Bank_Transfer[indexPath.row].payment_name + " anda guna lanjutkan pembayaran"
                
//                switch pay!.Bank_Transfer[indexPath.row].payment_name {
//                case "BNI":
//                    cell.images.image = UIImage(named: "bni")
//                    cell.images.layer.cornerRadius = 10
//                    cell.images.layer.borderWidth  = 1
//                    cell.images.layer.borderColor = UIColor.init(rgb: 0xEC6722).cgColor
//                    break
//
//
//                default:
//                    print("errors")
//                }
//
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! pembayaranselectedTableViewCell
                
                cell.namebank.text = "VA " + pay!.VAccount[indexPath.row].payment_name
               
                cell.desc.text = "Transfer melalui akun ," + pay!.VAccount[indexPath.row].payment_name + " anda guna lanjutkan pembayaran"
                
//                switch pay!.VAccount[indexPath.row].payment_name {
//                case "BNI":
//                    cell.images.image = UIImage(named: "bni")
//                    cell.images.layer.cornerRadius = 5
//                    cell.images.layer.borderWidth  = 1
//                    cell.images.layer.borderColor = UIColor.init(rgb: 0xEC6722).cgColor
//                    break
//
//
//                default:
//                    print("errors")
//                }
                
                return cell
                
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! pembayaranselectedTableViewCell
                
                cell.namebank.text = "VA " + pay!.Debit[indexPath.row].payment_name
             
                
                cell.desc.text = "Transfer melalui akun ," + pay!.Debit[indexPath.row].payment_name + " anda guna lanjutkan pembayaran"
                
//                switch pay!.Debit[indexPath.row].payment_name {
//                case "BNI":
//                    cell.images.image = UIImage(named: "bni")
//                    cell.images.layer.cornerRadius = 5
//                    cell.images.layer.borderWidth  = 1
//                    cell.images.layer.borderColor = UIColor.init(rgb: 0xEC6722).cgColor
//                    break
//                    
//                    
//                default:
//                    print("errors")
//                }
                
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! pembayaranselectedTableViewCell
                
                cell.namebank.text =  pay!.Asuransi[indexPath.row].payment_name
             
                
                cell.desc.text = "Transfer melalui akun ," + pay!.Asuransi[indexPath.row].payment_name + " anda guna lanjutkan pembayaran"
                
//                switch pay!.Debit[indexPath.row].payment_name {
//                case "BNI":
//                    cell.images.image = UIImage(named: "bni")
//                    cell.images.layer.cornerRadius = 5
//                    cell.images.layer.borderWidth  = 1
//                    cell.images.layer.borderColor = UIColor.init(rgb: 0xEC6722).cgColor
//                    break
//
//
//                default:
//                    print("errors")
//                }
                
                return cell
            default:
                fatalError()
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "loading", for: indexPath) as! pembayaranselectedTableViewCell
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if pay != nil {
            print("\(indexPath.section) ==>>> \(indexPath.row)")
            switch indexPath.section {
            case 0:
                delegate.send(data: pay!.EWallet[indexPath.row])
            case 1:
                delegate.send(data: pay!.Bank_Transfer[indexPath.row])
            case 2:
                delegate.send(data: pay!.VAccount[indexPath.row])
            case 3:
                delegate.send(data: pay!.Debit[indexPath.row])
            case 4:
                delegate.send(data: pay!.Asuransi[indexPath.row])
                
            default:
                print("error")
            }
            dismiss(animated: true, completion: nil)
        }
        
    }
}
