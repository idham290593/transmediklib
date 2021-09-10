//
//  modelpayment.swift
//  Pasien
//
//  Created by Idham Kurniawan on 08/12/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

struct detailpayment {
    var payment_id,payment_name,payment_number,account_name,description,image : String
}

struct modelpayment {
    var EWallet,VAccount,Asuransi,Bank_Transfer,Debit: [detailpayment]
}
