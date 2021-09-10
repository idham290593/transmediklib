//
//  Martikel.swift
//  Pasien
//
//  Created by Idham on 09/11/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

struct Artikels {
    var data : [Martikel]
    var first_page_url,nextpage,last_page_url,prev_page_url :String
    var lastpage,total :Int
   
    
}
class Martikel{
  
    var slug,title,author,desc,category_name,category_slug,created_at,image : String

    init(slug: String,title: String,author: String,desc: String,category_name: String,category_slug: String,created_at: String,image : String){
        self.slug = slug
        self.title = title
        self.author = author
        self.desc = desc
        self.category_name = category_name
        self.category_slug = category_slug
        self.image = image
        self.created_at = created_at
        
        
    }
}


class Mcategoryartikel{
  
    var slug,name,created_at : String

    init(slug: String,name: String,created_at: String){
        self.slug = slug
        self.name = name
        self.created_at = created_at
        
        
    }
}


