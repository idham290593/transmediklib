//
//  ResepViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 06/09/21.
//

import UIKit
import SwiftyJSON
import Alamofire
import CDAlertView


class ResepViewController: UIViewController {

    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var back: UIView!
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var doctorPhoto: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var spesialist: UILabel!
    @IBOutlet weak var nomor: UILabel!
    
    @IBOutlet weak var pasienPhoto: UIImageView!
    @IBOutlet weak var pasienName: UILabel!
    @IBOutlet weak var pasienAge: UILabel!
    
    @IBOutlet weak var tables: UITableView!
    
    @IBOutlet weak var tinggiTable: NSLayoutConstraint!
    @IBOutlet weak var tglExp: UILabel!
    @IBOutlet weak var beli: UIView!
    
    
    var consultation: ConsultationPostModel?
    var json: JSON?
    var api = resepdigitalobject()
    var resep = [Resepobat]()
    var prescription_id = ""
//    var idconsul = ""
    var data : Resepdigital?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        pasienPhoto.layer.cornerRadius = 25
        doctorPhoto.layer.cornerRadius = 30

        registerTableView()
        tables.dataSource = self
        tables.delegate = self
        tinggiTable.constant = tables.contentSize.height
        beli.layer.cornerRadius = 10
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        beli.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buy)))
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
            api.getresep(token: token, id: String(consultation!.consultation_id!)) { data in
               
                do {
                    let decoder = JSONDecoder()
                    let respon = try decoder.decode(responresep.self, from: data!)
                    self.data = respon.data
                    self.prescription_id = String(respon.data!.recipes![0].prescription_id!)
                    self.doctorName.text = respon.data?.doctor?.doctor_name ?? ""
                    self.nomor.text = respon.data?.doctor?.number ?? ""
                    let url = URL(string: respon.data?.doctor?.image ?? "")
                    self.doctorPhoto.kf.setImage(with: url)
                    self.spesialist.text = respon.data!.doctor!.specialist
                    let urls = URL(string: (respon.data?.patient!.image)!)
                    self.pasienPhoto.kf.setImage(with: urls)
                    self.pasienName.text = respon.data!.patient!.patient_name
                    self.pasienAge.text = respon.data!.patient!.age
                    self.tglExp.text = respon.data!.expires
                    self.tables.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.tables.layoutIfNeeded()
                        self.tinggiTable.constant = self.tables.contentSize.height
                    }

                  

                    
              
                } catch {
                    print("eror")
                }
            }

        }
        
    }
    
    private func registerTableView() {
        tables.register(ResepObatTableViewCell.nib(), forCellReuseIdentifier: ResepObatTableViewCell.identifier)
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func buy(){
        //        Toast.show(message: "Beli Obat", controller: self)//

                print("beliButtonDidTap")
                let alert = CDAlertView(title: "Pembelian Obat", message: "Apakah ingin memperbaharui keranjang belanja?", type: .warning)

                let yesAction = CDAlertViewAction(title: LocalizationHelper.getInstance().yes) { (CDAlertViewAction) -> Bool in

                    let vc = UIStoryboard(name: "Orderobat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "OrderobatViewController") as? OrderobatViewController
                    vc?.id = String(self.consultation!.consultation_id!)
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
 
    

}

extension ResepViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("retun =>> \(data?.recipes?.count ?? 0)")
        return data?.recipes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResepObatTableViewCell.identifier, for: indexPath) as! ResepObatTableViewCell
        cell.config(data: data!.recipes![indexPath.row])
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("willDisplay")
//
//
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        tables.layoutIfNeeded()
        self.tinggiTable.constant = tables.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("willDisplay")
        tableView.layoutIfNeeded()
        self.tinggiTable.constant = tableView.contentSize.height
      }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView(tableView: tableView, willDisplayMyCell: cell as! ResepObatTableViewCell, forRowAtIndexPath: indexPath)
    }

    private func tableView(tableView: UITableView, willDisplayMyCell myCell: ResepObatTableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        print("willDisplay2")

        tableView.layoutIfNeeded()
        self.tinggiTable.constant = tableView.contentSize.height    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        print("estimatedHeightForRowAt")

        return  UITableViewAutomaticDimension
    }
    
}
