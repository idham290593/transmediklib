//
//  Modeltanyadokter.swift
//  Pasien
//
//  Created by Idham on 05/10/20.
//  Copyright © 2020 idham. All rights reserved.
//

import Foundation
class Tanyadokter {
    var id,name,create,image,slug :String
    
    init(id:String,create:String,image: String,name :String,slug : String) {
        self.image = image
        self.name = name
        self.id = id
        self.slug = slug
        self.create = create
    }
}
