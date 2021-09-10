//
//  ChatModel.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import Parse

class ChatModel: PFObject {
    @NSManaged var badge: Int
    @NSManaged var message: ConversationModel?
    @NSManaged var user: PFUser?
    @NSManaged var uid: PFUser?
    @NSManaged var consultation_id: Int
    @NSManaged var typing: String?
    
    override init() {
        super.init()
    }
    
    init(badge: Int, message: ConversationModel?, user: PFUser?, uid: PFUser?, consultation_id: Int, typing: String?) {
        super.init()
        
        self.badge = badge
        self.message = message
        self.user = user
        self.uid = uid
        self.consultation_id = consultation_id
        self.typing = typing
    }
}

extension ChatModel: PFSubclassing {
    static func parseClassName() -> String {
        return "Chats"
    }
    
    override class func query() -> PFQuery<PFObject>? {
        let query = PFQuery(className: ChatModel.parseClassName())
            .includeKey("message")
            .includeKey("user")
            .includeKey("uid")
        query.cachePolicy = .networkElseCache //not used with localDatastore Enabled
        return query
    }
}
