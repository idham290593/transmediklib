//
//  User.swift
//  Pasien
//
//  Created by Idham on 02/10/20.
//  Copyright © 2020 idham. All rights reserved.
//

import Foundation
class UserModels{
    var email,fullname,phone,uuid,pass : String
    init(email : String,fullname:String,phone:String,uuid : String,pass:String) {
        self.email = email
        self.fullname = fullname
        self.phone = phone
        self.uuid = uuid
        self.pass = pass
        
    }
}
