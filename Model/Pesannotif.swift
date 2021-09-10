//
//  Pesannotif.swift
//  Pasien
//
//  Created by Idham Kurniawan on 28/12/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import Parse

struct pesannotifmodel {
    var  body,image,updatedAt,createdAt,objectId,read_at,title,content,notification_type:String
}

class Pesannotif: PFObject {
    @NSManaged var body: String?
    @NSManaged var image_path: String?
    @NSManaged override var updatedAt: Date?
    @NSManaged override var createdAt: Date?
    @NSManaged override var objectId: String?
    @NSManaged var read_at: Date?
    @NSManaged var title: String?
    @NSManaged var content: String?
    @NSManaged var notification_type: String?



    override init() {
        super.init()
    }

    init(body: String?,  image_path: String?, updatedAt: Date?,createdAt: Date?, objectId: String?,read_at:Date?, title: String?,content: String?,notification_type:String?) {
        super.init()
        self.read_at = read_at
        self.objectId = objectId
        self.updatedAt = updatedAt
        self.body = body
        self.image_path = image_path
        self.title = title
        self.content = content
        self.notification_type = notification_type
        self.createdAt = createdAt

    }
}


extension Pesannotif: PFSubclassing {
    static func parseClassName() -> String {
        return "Messages"
    }

    override class func query() -> PFQuery<PFObject>? {
        let query = PFQuery(className: Pesannotif.parseClassName())
        return query
        
        
    }
    
    
}

