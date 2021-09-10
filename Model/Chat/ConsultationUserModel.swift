//
//  ConsultationDoctorModel.swift
//  Pasien
//
//  Created by Adam M Riyadi on 09/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

struct ConsultationUserModel : Codable {
    let activated_at: String?
    let activation_code: String?
    let balance: Int?
    let banned_at: String?
    let banned_reason: String?
    let blocked_at: String?
    let blocked_reason: String?
    let created_at: String?
    let device_id: String?
    let email: String?
    let email_verified_at: String?
    let full_name: String?
    let gender: String?
    let last_activity: String?
    let map_lat: String?
    let map_lng: String?
    let parent_id: String?
    let parse: String?
    let phone_number: String?
//    let pin: String?
    let profile_picture: String?
    let ref_id: Int?
    let ref_type: String?
    let registered_at: String?
    let status: String?
    let updated_at: String?
    let uuid: String?
}
