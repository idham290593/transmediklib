//
//  FormjawabViewController.swift
//  Pasien
//
//  Created by Idham Kurniawan on 03/06/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//
//

import UIKit
import SwiftyJSON


class FormjawabViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var back: UIView!
    

    var form = FormObject()
    var id = ""
    var data : [answers] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        header.text = "Jawaban"
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        self.view.backgroundColor = Colors.backgroundmaster
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
            self.form.getformjawaban(token: token, id: self.id) { ( data ) in
                if data != nil {
                    self.data = data!
                }
                self.table.reloadData()
             
            }
        }
    }
    
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
   
}

extension FormjawabViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! celljawabanTableViewCell
        cell.backgroundColor = .clear
        cell.header.text = data[indexPath.row].question
        cell.body.text = data[indexPath.row].answer
        
        return cell
    }
    
    
}
