//
//  MAdvertisement.swift
//  Pasien
//
//  Created by Idham on 04/11/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
class MAdvertisement{

    var image,desc,end,start,slug,title : String
    
    init(image: String,desc: String,end: String,start: String,slug: String,title : String) {
        self.image = image
        self.desc = desc
        self.end = end
        self.start = start
        self.slug = slug
        self.title = title
    }
}
