//
//  formpertanyaanselectionTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 10/07/21.
//

import UIKit
protocol getheightrow {
    func getrow( value : CGFloat)
    func selectedrow(row : Int , label : String ,value : Bool)
    func selectother(row : Int , label : String ,value : Bool)
    func clear_radio()
    func endkeyboard()

    
}


class formpertanyaanselectionTableViewCell: UITableViewCell,getheightrow {
    
 
 
    @IBOutlet weak var notif: NSLayoutConstraint!
    @IBOutlet weak var tinggi: NSLayoutConstraint!
    var radio = false
    var jawaban = ""
//    var height : [CGFloat] = []{
//        didSet{
//
//
//            if height.count == listvalue.count{
//                var _tmp : CGFloat = 0.0
//                for i in 0..<height.count {
//                    _tmp += height[i]
//                    if i == height.count - 1{
//                        tinggi.constant = _tmp
//                        delegate?.refresh(row: row!)
//                    }
//                }
//
//            }
//        }
//    }
    var listvalue : [listvalue] = []{
        didSet{
            
            tables.reloadData()
        }
    }
    @IBOutlet weak var header: UILabel!
    var row:Int?
    var required = false
    @IBOutlet weak var tables: UITableView!
    @IBOutlet weak var background: UIView!
    var delegate :form_pertanyaan_delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tables.delegate = self
        tables.dataSource = self
        tables.isScrollEnabled = false
        background.layer.cornerRadius = 10
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.tables.reloadData()
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    func getrow(value: CGFloat) {
       
    }
    func clear_radio(){
        if !radio{
            return
        }
        for i in 0..<listvalue.count{
            listvalue[i].check =  false
          
        }
        notif.constant = 0
        self.tables.reloadData()
        delegate?.set_radio_value_to_master(row: self.row!, value: "", list: nil, status: false, datavalue: listvalue)
        

        
    }
    func selectother(row: Int, label: String, value: Bool) {
        
        if row == listvalue.count - 1 {
            jawaban = label
        }
        
        
        if !radio{
            var _temp = ""
            listvalue[row].check = value
            print("pilihan")
            for i in 0..<listvalue.count{
                if listvalue[i].check {
                    var jawaban = ""
                    if listvalue[i].label == "Lainnya"{
                        jawaban = label
                    }else{
                        jawaban = listvalue[i].label
                    }
                    print(jawaban)
                    
                    
                    if _temp.count == 0 {
                        _temp = jawaban
                    }else{
                        _temp = _temp + "|" + jawaban
                    }
                }
            }

            print("checknox")
            print(_temp)
            delegate?.set_checkbox_value_to_master(row: self.row!, value: _temp, datavalue: listvalue)
            
        }else{
            print("radio")

            for i in 0..<listvalue.count{
                if i != row {
                    listvalue[i].check =  false
                }
              
            }
            
            if   listvalue[row].check != value{
                listvalue[row].check = value
//                tables.reloadData()

            }
            print(label)

            delegate?.set_radio_value_to_master(row: self.row!, value: label, list: row, status: value, datavalue:  self.listvalue)
            
        }
        
        
        var status = false
        for i in 0..<listvalue.count{
            if listvalue[i].check  {
                status = true
            }
          
        }
        if status{
            notif.constant = 0
        }else{
            notif.constant = CGFloat(20)
        }
        
    }
    func endkeyboard(){
        delegate?.endkyeboard()
    }
    
    func filter()-> String?{
        
        let _label = listvalue.map {$0.label}
        let set2 : Set<String> = Set(_label)
        
        let hasil = jawaban.components(separatedBy: "|")
        let set1 : Set<String> = Set(hasil)
        
        print("ini hasillllnya")
        print(set1)
        print(set2)
        
        
        var data =  listvalue.map {$0.label}
        for index in hasil{
            if !data.contains(index) {
                return index
            }
            
        }
      
        return nil
        
    }
    

    
    
    func selectedrow(row: Int, label: String  ,value : Bool) {
        
        
        
        if !radio{
            var _temp = ""
            listvalue[row].check = value
            print("pilihan")
            for i in 0..<listvalue.count{
                if listvalue[i].check {
                    var jawaban = ""
                    if listvalue[i].label == "Lainnya"{
                        print(filter() ?? "kosong")
                        jawaban = filter() ?? ""
                    }else{
                        jawaban = listvalue[i].label
                    }
                    
                  print(jawaban)
                    if _temp.count == 0 {
                        _temp = listvalue[i].label
                    }else{
                        _temp = _temp + "|" + listvalue[i].label
                    }
                }
            }

            print("checknox")

            delegate?.set_checkbox_value_to_master(row: self.row!, value: _temp, datavalue: listvalue)
            
        }else{
            print("radio")
            jawaban = label
            for i in 0..<listvalue.count{
                if i != row {
                    listvalue[i].check =  false
                }
              
            }
            
            if   listvalue[row].check != value{
                listvalue[row].check = value
//                tables.reloadData()

            }
            
            delegate?.set_radio_value_to_master(row: self.row!, value: label, list: row, status: value, datavalue:  self.listvalue)
            
        }
        
        
        var status = false
        for i in 0..<listvalue.count{
            if listvalue[i].check  {
                status = true
            }
          
        }
        if status{
            notif.constant = 0
        }else{
            notif.constant = CGFloat(20)
        }
        
        
    }
    
   
    
}

extension formpertanyaanselectionTableViewCell : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listvalue.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tinggi.constant = tables.contentSize.height

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if listvalue[indexPath.row].label == "Lainnya" {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "other", for: indexPath) as! cellotherpertanyaanTableViewCell
            
            cell.row = indexPath.row

            print("lainnya masuk")
            print( filter() == nil ? "kosong" : filter())
            cell.values.text = filter() == nil ? "" : filter()
            cell.radio = self.radio
            cell.ischeck = listvalue[indexPath.row].check
     
            cell.delegate = self

            return cell
        }else{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "value", for: indexPath) as! cellvaluepertanyaanTableViewCell
            cell.row = indexPath.row
            cell.radio = self.radio
            cell.ischeck = listvalue[indexPath.row].check
            cell.values.text = listvalue[indexPath.row].label
            cell.delegate = self

            return cell
        }
     
    }
    
    
}


