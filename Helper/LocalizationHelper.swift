//
//  LocalizationHelper.swift
//  Pasien
//
//  Created by Adam M Riyadi on 12/10/20.
//  Copyright © 2020 Netkrom. All rights reserved.
//

import Foundation

class LocalizationHelper {
    static var _locale : LocalizationHelper!
    static var locale = Locale.current.languageCode ?? "id"
    
    var yes = "Ya"
    var no = "Tidak"
    var consultation_no_response = "Maaf Belum ada response dari dokter, silahkan menghubungi dokter lain"
    var consultation_wait = "Dokter kami akan siap dalam"
    var second = "detik"
    var please_wait = "Silahkan tunggu"
    var consultation_cancel = "Batal Konsultasi"
    var consultation_cancel_confirmation = "Yakin akan membatalkan konsultasi ?"
    var consultation_cancelled = "Konsultasi Dibatalkan"
    var consultation_cancelled_failed = "Gagal membatalkan sesi konsultasi"
    var consultation_initialization_failed = "Gagal memulai sesi konsultasi"
    var catatan_dari_dokter = "Catatan dari Dokter"
    var symptoms = "Symptoms"
    var possible_diagnosis = "Possible Diagnosis"
    var advice = "Advice"
    var detail_catatan = "Detail Catatan"
    var chat_lagi_pada = "Chat lagi pada"
    var pesan_dokter = "Pesan dokter"
    var ingatkan_saya = "Ingatkan saya"
    var resep_digital = "Resep Obat Digital"
    var nama_obat = "Nama obat"
    var jumlah = "Jumlah"
    var resep_berlaku = "Resep ini berlaku sampai"
    var detail_obat = "Detail obat"
    var catatan_dokter = "Catatan Dokter"
    var data_pasien = "Data Pasien"
    var waktu = "Waktu"
    var catatan = "Catatan"
    var beli_sekarang = "Beli Sekarang"
    var typing = "Sedang Mengetik ..."
    var spa_system_msg = "mengirimkan anda catatan dokter"
    var catatan_system_msg = "mengirimkan anda jadwal berobat"
    var resep_system_msg = "mengirimkan anda resep obat digital"
    var keluar_conversations = "Keluar dari percakapan"
    var akhiri_conversations = "Ingin mengakhiri konsultasi?"
    var jadwal_konsultasi = "Jadwal Konsultasi"
    var dokter = "Dokter"
    var event_added = "Event berhasil ditambahkan ke kalendar"
    var resep_expire = "Resep Mendekati Kadaluarsa"
    var greet = "Hai"
    
    init() {
        
    }
    
    static func getInstance() -> LocalizationHelper! {
        //locale = Locale.current.languageCode ?? "id"
        locale = "id"
        
        if locale.lowercased() == "en" || locale.lowercased().starts(with: "en") {
            if _locale == nil {
                _locale = LocalizationEN()
            }
            return _locale!
        }
        else {
            if _locale == nil {
                _locale = LocalizationHelper()
            }
            return _locale!
        }
    }
}
