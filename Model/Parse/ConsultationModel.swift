//
//  ConsultationModel.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation
import Parse

class ConsultationModel: PFObject {
    @NSManaged var consultation_id: NSNumber?
    @NSManaged var status: String?
    @NSManaged var keluhan_patient: String?
    @NSManaged var detail_patient: String?
    @NSManaged var patient: PFUser?
    @NSManaged var doctor: PFUser?
    @NSManaged var medical_facility: String?
    @NSManaged override var createdAt: Date?

    override init() {
        super.init()
    }

    init(consultation_id: NSNumber?,  status: String?, keluhan_patient: String?, detail_patient: String?, patient: PFUser?, doctor: PFUser?,medical_facility : String?,createdAt: Date?) {
        super.init()
        self.patient = patient
        self.doctor = doctor
        self.consultation_id = consultation_id
        self.status = status
        self.keluhan_patient = keluhan_patient
        self.detail_patient = detail_patient
        self.medical_facility = medical_facility
        self.createdAt = createdAt
    }
}

extension ConsultationModel: PFSubclassing {
    static func parseClassName() -> String {
        return "Consultations"
    }
    
    override class func query() -> PFQuery<PFObject>? {
        let query = PFQuery(className: ConsultationModel.parseClassName())
            .includeKey("patient")
            .includeKey("doctor")
        query.cachePolicy = .networkElseCache //not used with localDatastore Enabled
        return query
    }
}
