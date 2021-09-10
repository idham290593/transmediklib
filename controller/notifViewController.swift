//
//  notifViewController.swift
//  Pasien
//
//  Created by Idham Kurniawan on 05/04/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//

import UIKit

class notifViewController: UIViewController {

  

    @IBOutlet var viewss: Notifserverdown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

    }
    
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
  
}
