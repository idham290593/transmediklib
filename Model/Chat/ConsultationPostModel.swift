//
//  ConsultationPostModel.swift
//  Pasien
//
//  Created by Adam M Riyadi on 09/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

public struct ConsultationPostModel : Codable {
    let consultation_id: Int?
    let doctor: ConsultationUserModel?
    let patient: ConsultationUserModel?
}
