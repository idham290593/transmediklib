//
//  Mbalance.swift
//  Pasien
//
//  Created by Idham Kurniawan on 10/12/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
struct Mbalance {
    var accountno,accounttypecode,accountname,paymentid,paymentname : String
    var accountbalance,pointrewardbalance : Int
}

struct historybalance {
    var  TransactionDescription1,TransactionID,TransactionTimeStamp :String
    var  TransactionAmount : Int
}
