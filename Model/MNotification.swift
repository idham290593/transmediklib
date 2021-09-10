//
//  MNotification.swift
//  Pasien
//
//  Created by Idham Kurniawan on 28/12/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import Parse

struct Notifmodel {
    var  body,image,start,end,tittle,conten,notif_type,createdAt,objectid:String
}

class MNotification: PFObject {
    @NSManaged var body: String?
    @NSManaged var image_path: String?
    @NSManaged var start_date: Date?
    @NSManaged var end_date: Date?
    @NSManaged var title: String?
    @NSManaged override var objectId: String?
    @NSManaged override var createdAt: Date?
    @NSManaged var content: String?
    @NSManaged var notification_type: String?


    override init() {
        super.init()
    }

    init(body: String?,  image_path: String?, start_date: Date?,end_date: Date?, title: String?, content: String?,notification_type: String?,createdAt: Date?,objectId:String?) {
        super.init()

        self.objectId = objectId
        self.body = body
        self.image_path = image_path
        self.start_date = start_date
        self.end_date = end_date
        self.title = title
        self.content = content
        self.notification_type = notification_type
        self.createdAt = createdAt

    }
}


extension MNotification: PFSubclassing {
    static func parseClassName() -> String {
        return "Notifications"
    }

    override class func query() -> PFQuery<PFObject>? {
        let query = PFQuery(className: MNotification.parseClassName())
        return query
        
        
    }
    
    
}


