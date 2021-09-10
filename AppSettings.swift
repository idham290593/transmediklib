//
//  AppSettings.swift
//  transmedik
//
//  Created by Idham Kurniawan on 08/07/21.
//

import Foundation
import UIKit


struct AppSettings {
    static let APPS_NAME: String = "Transmedika"
    static let FCM_TOKEN: String = "TRANSMEDIKA_FCM_TOKEN"
    static let NAVIGATIONBAR_HEIGHT : CGFloat = 70
    static let PARSE_APPID: String = "parse-dev-app"
    static let PARSE_SERVER: String = "https://parse-dev.transmedika.co.id/parse/"
    static let PARSE_CLIENTKEY: String = "widicaem"
    static let WAIT_COUNTER: Int = 60
    static let Url: String = "https://api-dev.transmedika.co.id/api/sdk-v1/"
    
    static let Tokentransmedik: String = "transmedikToken"
    static let tokenparse: String = "transmediktokenparse"
    static let email: String = "transmedikemail"
    static let uuid: String = "transmedikuuid"
    static let pin: String = "transmedikpin"
    static let name: String = "transmedikname"
    static let profile_picture: String = "transmedikprofile_picture"
    static let nik: String = "transmediknik"
    static let phone: String = "transmedikphone"
    static let deviceid: String = "transmedikdeviceid"
    
    static let frameworkBundleID  = "id.netkrom.transmedik"
    static let bundleframework = Bundle(identifier: frameworkBundleID)


    
    static let KEY_CURRENT_CONSULTATION: String = "current_consultation"
    static let KEY_UID: String = "uid"
    static let CANCEL_BY_PATIENT: String = "CANCEL BY PATIEN"
    static let ON_CHAT: String = "ON CHAT"
    static let CHAT_SAVE: String = "SAVE"
    static let FINISHED: String = "FINISHED"
    static let REJECTED_BY_DOCTOR: String = "REJECTED BY DOCTOR"
    static let SESSION_ENDED: String = "SESI BERAKHIR"
    static let NOT_SEND:String = "not_send"
    static let Chat_ALLOWED:String = "ALLOWED"

    
    
    static let SENDING_STATUS:String = "sending"
    static let SENT_STATUS:String = "sent"
    static let RECEIVED_STATUS:String = "delivered"
    static let SEEN_STATUS:String = "seen"
    static let FAILED_STATUS:String = "failed"
    static let PHR_REQ:String = "phr_request"
    static let TEXT_TYPE:String = "text"
    static let CATATAN_TYPE:String = "catatan"
    static let SPA_TYPE:String = "spa"
    static let RESEP_DOKTER_TYPE:String = "resep_dokter"
    static let DATE_TYPE:String = "date"
    static let URL_TYPE:String = "link"
    static let IMAGE_TYPE:String = "image"
    static let VIDEO_TYPE:String = "video"
    static let SESSION_ENDED_TYPE:String = "sesi_berakhir"
    static let SYSTEM_MESSAGE_TYPE:String = "system_message"
    
    static let SESSION_ENDED_MESSAGE: String = "Konsultasi sudah selesai"
    
    //notifications
    static let didReceiveNotification: String = "didReceiveNotification"
    static let didReceiveBadgeUpdate: String = "didReceiveBadgeUpdate"
    static let didReceiveTypingStatus: String = "didReceiveTypingStatus"
    
    static let urlCellWidth: CGFloat = 280.0
    static let urlCellHeight: CGFloat = 120.0
    
    static let mediaCellWidth: CGFloat = 280.0
    static let mediaCellHeight: CGFloat = 280.0
    static let videoThumbnailWidth: CGFloat = 800.0
    static let maxImageWidth: CGFloat = 1024.0
    
    static let STUN_SERVER: String = "stun:167.71.204.0:3478"
    static let STUN_USERNAME: String = "netkrom"
    static let STUN_PASSWORD: String = "bull3tX"
    static let RTC_HOST: String = "wss://rtc.mybeam.me/one2one"
    
    //RTC RESPONSE
    static let RTC_REGISTER : String = "registerResponse"
    static let RTC_PRESENTER : String = "presenterResponse"
    static let RTC_ICE_CANDIDATE  : String = "iceCandidate"
    static let RTC_VIEWER : String = "viewerResponse"
    static let RTC_STOP_COMMUNICATION : String = "stopCommunication"
    static let RTC_CLOSE_ROOM : String = "closeRoomResponse"
    static let RTC_INCOMING_CALL : String = "incomingCall"
    static let RTC_START_COMMUNICATION : String = "startCommunication"
    static let RTC_CALL : String = "callResponse"
    static let RTC_CALLING : String = "callingResponse"
    static let RTC_NOTIFY_CALLER_ACTIVE : String = "notifyCallerActive"
    static let RTC_NOTIFY_CALLER_MISSED : String = "notifyCallerNotActive"
    static let RTC_CANCEL_CALLING : String = "cancelCallingResponse"
    static let RTC_REJECT_CALLING : String = "rejectCallingResponse"
    static let RTC_BUSY : String = "busyResponse"
    static let RTC_UNKNOWN : String = "unknown"
    //RTC RESPONSE
    
    static let RTC_REGISTER_REJECTED : String = "rejected"
    static let RTC_REGISTER_ACCEPTED : String = "accepted"
    
    static let CURRENT_CALLING = "CURRENT_CALLING"
    static let CURRENT_RINGING = "CURRENT_RINGING"
    static let CURRENT_COMMUNOICATION = "CURRENT_COMMUNOICATION"
    static let CURRENT_REGISTERED = "CURRENT_REGISTERED"
    static let CURRENT_BUSY = "CURRENT_BUSY"
    
    static let didReceiveCallInBackground = "didReceiveCallInBackground"
}
