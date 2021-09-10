//
//  formsViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//

import UIKit
import SwiftyJSON

protocol formsViewControllerdelegate {
    func kirim (list : [listformmodel])
}


class formsViewController: UIViewController {
    
    @IBOutlet weak var textnotif: UIView!
    @IBOutlet weak var tingginotif: NSLayoutConstraint!
    @IBOutlet weak var jawabanbaru: UIView!
    @IBOutlet weak var closenotif: UIImageView!
    @IBOutlet weak var back : UIView!
    @IBOutlet weak var header : UILabel!
    @IBOutlet weak var sendbut: UIView!
    

    @IBOutlet weak var tables: UITableView!
    var api = FormObject()
    var list : [listformmodel] = []
//    var valueform : [valuesonform] = []
    var delegate :form_pertanyaan_delegate?
    var typetext = true
    var delegates : formsViewControllerdelegate?
    var klinik = ""
    var spesialis = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tingginotif.constant = 0
        self.textnotif.isHidden = true
        self.view.layoutIfNeeded()
        
        self.view.layoutIfNeeded()
        sendbut.layer.cornerRadius = sendbut.frame.height / 2
        sendbut.layer.borderWidth = 1
        sendbut.layer.borderColor = UIColor.init(rgb: 0xEE6D84).cgColor

        tables.delegate = self
        tables.dataSource = self
        self.view.backgroundColor = Colors.backgroundcolor
        self.view.backgroundColor = .init(rgb: 0xE5E5E5)
        self.tables.backgroundColor = .clear
        
        header.text = " Klinik"
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        closenotif.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closenotifacc)))
        jawabanbaru.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reset)))

        sendbut.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendacc)))

        
//
    }
    
    @objc func reset(){
        
        for i in 0..<list.count{
            list[i].jawaban = ""
            if list[i].detail != nil {
                for j in 0..<list[i].detail!.count{
                    list[i].detail![j].check = false
                }
            }
            
        }
        
        
        closenotifacc()
        tables.reloadData()
    }
    
    
    
    func convertjson(_ _data : String){
        
        let data = _data.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                
                let jsons = JSON(jsonArray)
                jsons.array?.forEach({ (index) in
                    if let i = self.list.firstIndex(where: {$0.id == index["id"].stringValue}) {
                        self.list[i].jawaban = index["answer"].stringValue
                        if let j = self.list.firstIndex(where: {$0.id == index["id"].stringValue}) {
                          
                            if self.list[j].input_type == "checkbox" || self.list[j].input_type == "radio" {
                                let _tmpjawaban =  index["answer"].stringValue.components(separatedBy: "|")
                                let _tmpidjawaban =  index["idanswer"].stringValue.components(separatedBy: "|")

                                for (i,indexjawaban) in _tmpjawaban.enumerated(){
                                    
                                    if let _jawab = self.list[j].detail!.firstIndex(where: {$0.id == _tmpidjawaban[i]}) {
                                        self.list[j].detail![_jawab].check = true
                                    }
                                    
                                }
                            }
                             
                        }
                        
                        
                    }
                    
                })
                
            } else {
                print("bad json")
            }

        } catch let error as NSError {
            print(error)
        }
        
        
        
        
    }
    
    func savejawaban() {
        var stringform = ""
        for i in 0..<self.list.count{
            //        for (i,index) in self.valueform.enumerated(){
            var idjawaban = ""


            
            if self.list[i].input_type == "checkbox" || self.list[i].input_type == "radio"{
                var _tmp = ""
                for index in self.list[i].detail!{
                    if index.check {
                        if idjawaban == "" {
                            idjawaban = index.id
                        }else{
                            idjawaban = idjawaban + "|" +  index.id
                        }
                    }
                      
                }
                
            }
            
            if stringform == "" {
                stringform = "[{\"answer\":\"\(self.list[i].jawaban)\",\"idanswer\":\"\(idjawaban)\",\"id\":\"\(self.list[i].id)\",\"question\":\"\(self.list[i].question)\"}"
            }else{
                if i == self.list.count - 1{
                    stringform = stringform + ",{\"answer\":\"\(self.list[i].jawaban)\",\"idanswer\":\"\(idjawaban)\",\"id\":\"\(self.list[i].id)\",\"question\":\"\(self.list[i].question)\"}]"
                }else{
                    stringform = stringform + ",{\"answer\":\"\(self.list[i].jawaban)\",\"idanswer\":\"\(idjawaban)\",\"id\":\"\(self.list[i].id)\",\"question\":\"\(self.list[i].question)\"}"
                }
                
            }
            
         
//            if i == self.list.count - 1{
//                print(stringform)
//                db.updatejawaban(id: klinik, spesialis: spesialis, jawban: stringform) {
//                    
//                }
//            }
        }
        
    }
    
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    
  
    
   @objc func closenotifacc(){
        UIView.animate(withDuration : 0.4){
            self.tingginotif.constant = 0
            self.view.layoutIfNeeded()
            
        }
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.textnotif.isHidden = true
        }
    }
    
}

extension formsViewController : UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("regresh form master")
        
        return list.count == 0 ? 0 : list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            switch list[indexPath.row].input_type {
            case "checkbox","radio":
                let cell = tableView.dequeueReusableCell(withIdentifier: "selection", for: indexPath) as! formpertanyaanselectionTableViewCell
                cell.row = indexPath.row
                cell.radio = list[indexPath.row].input_type == "radio" ? true : false
                cell.delegate = self
                cell.listvalue = list[indexPath.row].detail!
                let _tmp = list[indexPath.row].required ? "*" : ""
                cell.backgroundColor = .clear
                cell.header.text = list[indexPath.row].question + _tmp
                if list[indexPath.row].required && list[indexPath.row].jawaban == "" {
                    cell.notif.constant = CGFloat(20)
                }else{
                    cell.notif.constant = CGFloat(0)
                }
                let ind = list[indexPath.row].detail!.count - 1
                cell.jawaban = list[indexPath.row].jawaban
                print("jawaban box")
                print(list[indexPath.row].jawaban)
                
                return cell
                
                
                
            case "text","number","email":
                let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! formpertanyaantextfieldTableViewCell
                
                cell.row = indexPath.row
                cell.delegate = self
                let _tmp = list[indexPath.row].required ? "*" : ""
                cell.header.text = list[indexPath.row].question + _tmp
                cell.backgroundColor = .clear
                
                cell.required = list[indexPath.row].required
                cell.typetext = list[indexPath.row].input_type
                cell.nametext.text = list[indexPath.row].jawaban
                if list[indexPath.row].input_type == "number"{
                    cell.nametext.keyboardType = .numberPad
                }else if list[indexPath.row].input_type == "email" {
                    cell.nametext.keyboardType = .emailAddress
                }
                
                if list[indexPath.row].required{
                    let _isi =  list[indexPath.row].jawaban
                    if _isi == "" {
                        cell.tingginotif.constant = CGFloat(20)
                        cell.notes.text = "Pertanyaan ini harus di isi"
                        
                    } else  if list[indexPath.row].input_type == "email" && !_isi.contains("@")  {
                        if _isi.contains("."){
                            cell.tingginotif.constant = CGFloat(20)
                            cell.notes.text = "isi tidak sesuai"
                        }else{
                            cell.tingginotif.constant = CGFloat(0)
                            cell.notes.text = "isi tidak sesuai"
                        }
                        
                        
                    }else{
                        cell.tingginotif.constant = 0
                    }
                    
                    if list[indexPath.row].jawaban == "" {
                        cell.tingginotif.constant = CGFloat(20)
                    }else{
                        cell.tingginotif.constant = CGFloat(0)
                    }
                }
                
                
                
                
                return cell
                
                
            case "date","time":
                let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath) as! formpertanyaandateTableViewCell
                cell.row = indexPath.row
                cell.delegate = self
                cell.typetimes = list[indexPath.row].input_type
                let _tmp = list[indexPath.row].required ? "*" : ""
                cell.header.text = list[indexPath.row].question + _tmp
                cell.backgroundColor = .clear
                
                if list[indexPath.row].required && list[indexPath.row].jawaban == "" {
                    cell.tingginotif.constant = CGFloat(20)
                }else{
                    cell.tingginotif.constant = CGFloat(0)
                }
                
                cell.date.text = list[indexPath.row].jawaban
                return cell
                
            case "textarea":
                let cell = tableView.dequeueReusableCell(withIdentifier: "textarea", for: indexPath) as! formtextareaTableViewCell
                
                cell.row = indexPath.row
                cell.delegate = self
                let _tmp = list[indexPath.row].required ? "*" : ""
                cell.header.text = list[indexPath.row].question + _tmp
                cell.backgroundColor = .clear
                
                cell.required = list[indexPath.row].required
                cell.bodys.text = list[indexPath.row].jawaban
                
                
                if list[indexPath.row].required{
                    let _isi =  list[indexPath.row].jawaban
                    if _isi == "" {
                        cell.notif.isHidden = false
                        cell.notif.text = "Pertanyaan ini harus di isi"
                        
                    }else{
                        cell.notif.isHidden = true
                    }
                    
                }
                
                
                
                
                return cell
                
            default:
                fatalError()
            }
            
//        }
        
    }
    
    
}



extension formsViewController : form_pertanyaan_delegate{
    func set_checkbox_value_to_master(row: Int, value: String, datavalue: [listvalue]) {
        print("set_checkbox_value_to_master")
        print(value)
        print(row)
        self.list[row].detail = datavalue
        self.list[row].jawaban = value
    }
    
    func send() {
        
    }
    
    
    
    func set_radio_value_to_master(row: Int, value: String, list: Int?, status: Bool, datavalue: [listvalue]) {
        
        self.list[row].detail = datavalue
        self.list[row].jawaban = value
    }
    
    func endkyeboard() {
        self.view.endEditing(true)
    }
    
    
    
    func set_checkbox_value_to_master(row: Int, value: String, list: Int, status: Bool) {
        print("set_checkbox_value_to_master with status")
        self.list[row].detail![list].check = status
        if  self.list[row].jawaban == ""{
            self.list[row].jawaban = value
        }else{
            print(value)
            var _temp = ""
            for (i,index) in self.list[row].detail!.enumerated(){
                if index.check{
                    if _temp.count == 0 {
                        if index.label == "Lainnya"{
                            _temp = value
                        }else{
                            _temp = index.label
                        }
                        
                    }else{
                        if index.label == "Lainnya"{
                            _temp = _temp + "|" + value
                        }else{
                            _temp =  _temp + "|" + index.label
                        }
                        
                    }
                }
                
                self.list[row].jawaban = _temp
            }
            
            self.list[row].jawaban = _temp
        }
    }
    
    
    
    func setdate(row: Int, value: String) {
        list[row].jawaban = value
        self.view.endEditing(true)
        print(list[row].question + " ===> " + value)
    }
    
    func refresh(row : Int) {
        
        
        //        self.tables.beginUpdates()
        //
        //        self.tables.insertRows(at: [IndexPath(row: row, section: 0)], with: .none)
        //        self.tables.endUpdates()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            self.reload(tableView: self.tables)
        }
    }
    
    
    func reload(tableView: UITableView) {
        
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
        
    }
    
    func set_textfield_value_to_master(row: Int, value: String) {
        list[row].jawaban = value
        print(list[row].question + " ===> " + value)
        
    }
    
    
    
    
    func remove_checkbox_value_to_master(row: Int, value: String) {
        print(list[row].question + " ===> " + value)
        var _tmp = list[row].jawaban.components(separatedBy: "|")
        if let index = _tmp.index(of: value) {
            _tmp.remove(at: index)
        }
        
        if _tmp.count == 0 {
            list[row].jawaban = ""
        }else{
            for index in _tmp{
                if  list[row].jawaban == ""{
                    list[row].jawaban = index
                }else{
                    list[row].jawaban = list[row].jawaban + "|" + index
                }
            }
        }
    }
    
    
   @objc func sendacc() {
        print("sending data")
        for i in 0..<list.count{
            if list[i].required && list[i].jawaban == "" {
                print("kosong")
                print(list[i].jawaban)
                let indexPath = IndexPath(row: i , section: 0)
                self.tables.scrollToRow(at: indexPath, at: .none, animated: true)
                
                return
            }
            
            if list[i].input_type == "email" && !list[i].jawaban.contains("@") && !list[i].jawaban.contains(".") {
                let indexPath = IndexPath(row: i , section: 0)
                self.tables.scrollToRow(at: indexPath, at: .none, animated: true)
                Toast.show(message: "Form email tidak sesuai", controller: self)
                return
            }
            
//            if self.list[i].input_type == "checkbox" || self.list[i].input_type == "radio"{
//                var _tmp = ""
//                for index in self.list[i].detail!{
//                    if index.check {
//                        var jawaban = ""
//                        if index.label == "Lainnya"{
//                            jawaban
//                        }
//                        if _tmp == "" {
//                            _tmp = index.label
//                        }else{
//                            _tmp = _tmp + "|" + index.label
//                        }
//                    }
//
//                }
//                list[i].jawaban = _tmp
//
//            }
            
            
            if i == list.count - 1{
                self.savejawaban()
                delegates?.kirim(list: self.list)
                dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    
}
