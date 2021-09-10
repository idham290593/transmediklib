//
//  ConversationModel.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import Parse

class ConversationModel: PFObject {
    @NSManaged var messageId: String?
    @NSManaged var sender_id: PFUser?
    @NSManaged var user: PFUser?
    @NSManaged var text: String?
    @NSManaged var date: Date?
    @NSManaged var uid: PFUser?
    @NSManaged var consultation_id: String?
    @NSManaged var status: String?
    @NSManaged var kind: String?
    
    override init() {
        super.init()
    }
    
    init(messageId: String?, sender_id: PFUser?, user: PFUser?, text: String?, date: Date?, uid: PFUser?, consultation_id: String?, status: String?, kind: String?) {
        super.init()
        
        self.messageId = messageId
        self.sender_id = sender_id
        self.user = user
        self.text = text
        self.date = date
        self.uid = uid
        self.consultation_id = consultation_id
        self.status = status
        self.kind = kind
    }
}

extension ConversationModel: PFSubclassing {
    static func parseClassName() -> String {
        return "Conversations"
    }
    
    override class func query() -> PFQuery<PFObject>? {
        let query = PFQuery(className: ConversationModel.parseClassName())
            .includeKey("sender_id")
            .includeKey("user")
            .includeKey("uid")
        query.cachePolicy = .networkElseCache //not used with localDatastore Enabled
        return query
    }
}
