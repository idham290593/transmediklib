//
//  filerdokterViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 08/07/21.
//


struct filterdokterdetail {
    var name,symbol :String
    var value:String
    var check :Bool
}
struct filterdokter {
    var rates,experince : [filterdokterdetail]
}

protocol filerdokterViewControllerdelegate {
    func sendfilter(data  :filterdokter )
}

import UIKit

class filerdokterViewController: UIViewController {
    
    
    
    @IBOutlet weak var tinggi: NSLayoutConstraint!
    
    var delegate : filerdokterViewControllerdelegate!
    @IBOutlet weak var table: UITableView!
    var datafilter  :filterdokter!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var kembali: UIView!
    @IBOutlet weak var save: UIView!
    @IBOutlet weak var textreset: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.bounces = false
        table.delegate = self
        table.dataSource = self
        save.backgroundColor = Colors.basicvalue
        kembali.layer.borderWidth = 1
        kembali.layer.borderColor = UIColor.init(rgb: 0xc4c4c4).cgColor
        textreset.textColor = .init(rgb: 0xc4c4c4)
        header.layer.cornerRadius = 15
        kembali.layer.cornerRadius = 15
        save.layer.cornerRadius = 15
        
        blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keluar)))
        kembali.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reset)))
        save.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendacc)))
    }
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration : 0.3){
            let total = CGFloat((44 * 8) + 60 + 25)
            self.tinggi.constant = total
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    @objc func sendacc(){
        delegate.sendfilter(data: datafilter)
        dismiss(animated: false, completion: nil)
    }
    @objc func reset(){
        for i in 0..<datafilter.experince.count{
            datafilter.experince[i].check = false
        }
        
        for i in 0..<datafilter.rates.count{
            datafilter.rates[i].check = false
        }
        table.reloadData()
    }
    
    
    @objc func keluar(){
        dismiss(animated: false, completion: nil)
    }
    
}

extension filerdokterViewController : UITableViewDelegate ,UITableViewDataSource,filterdokterTableViewCelldelegate{
    func check(row: Int, path: Int) {
        if path == 0 {
            datafilter.experince[row].check = !datafilter.experince[row].check
        }else{
            datafilter.rates[row].check = !datafilter.rates[row].check

        }
        table.reloadData()

    }
    
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("calll")
        return 2
    }
    //
    //    func section
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Pengalaman Dokter"
        }else{
            return "Biaya Dokter"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.init(rgb: 0xE9F8F8)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return datafilter.experince.count
        }else{
            return datafilter.rates.count

        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! filterdokterTableViewCell
            cell.name.text = datafilter.experince[indexPath.row].name
            if datafilter.experince[indexPath.row].check{
//                cell.check.image = UIImage(named: "Checked")
                cell.check.image = UIImage(named: "Checked", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)

            }else{
                cell.check.image = UIImage(named: "Uncheck", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
                
            }
            
            cell.row = indexPath.row
            cell.delegate = self
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! filterdokterTableViewCell
            cell.name.text = datafilter.rates[indexPath.row].name
            if datafilter.rates[indexPath.row].check{
                cell.check.image = UIImage(named: "Checked", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
            }else{
                cell.check.image = UIImage(named: "Uncheck", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
            }
            cell.row = indexPath.row
            cell.path = 1
            cell.delegate = self
            
            return cell
        }
        
    }
    
    
}
