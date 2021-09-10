//
//  childhistoryViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 28/07/21.
//


import UIKit
import Parse



protocol childhistoryViewControllertomasterdelegate{
    func open()
    func close()
    
    func getdata(status : Bool)
}

class childhistoryViewController: UIViewController {
    var query: PFQuery<PFObject>!

    var lastContentOffset : CGFloat = 0.0
    var api = historiesobject()
   
    var getdatahistory = false
    var uuid = ""{
        didSet{
            getdata()
        }
    }
    var conversationQuery: PFQuery<PFObject>!
    var selected:Int?  // 1 untuk obat dan 2 untuk konsultasi
    var nextpage = ""
    var long:Double?
    var lat:Double?
    var alamat = ""
    var obat = Obat()
    var token = ""
    @IBOutlet var notfound: UIView!
    @IBOutlet var notconnection: UIView!
    @IBOutlet weak var table: UITableView!
    var data : [ModelHistories] = []
    var loading = false
    var delegate : childhistoryViewControllertomasterdelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = Colors.backgroundmaster
        table.bounces = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "transaksi"){
            self.getdata()
            print("ambil data")
            UserDefaults.standard.removeObject(forKey: "transaksi")
        }
        
        
    }
    
    func getdata(){
        if CheckInternet.Connection(){
            self.loading(self)
            if uuid != "" && !getdatahistory{
                print("data baru")
                
                data.removeAll()
                self.table.reloadData()
                self.delegate.getdata(status: true)
                loading = true
                self.getdatahistory = true
                table.backgroundView = nil
                    if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                        self.nextpage = ""
                        self.api.gethistories(token: token, uuid: self.uuid, selected: selected) { (data,nextsp) in
                            
                            self.closeloading(self)
                            self.nextpage = nextsp
                            print("datanext => " + nextsp)
                            if nextsp == ""{
                                self.loading = false
                                
                            }else{
                                self.loading = true
                                
                            }
                            
                            self.getdatahistory = false
                            self.delegate.getdata(status: false)
                            
                            if data != nil{
                                
                                
                                if data!.count > 0 {
                                    self.table.backgroundView = nil
                                    
                                }else{
                                    self.table.backgroundView = self.notfound
                                    
                                }
                                self.data = data!
                                self.getdatahistory = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    self.table.reloadData()
                                }
                            }else{
                                self.table.backgroundView = self.notfound
                                self.data.removeAll()
                                self.getdatahistory = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    self.table.reloadData()
                                }
                            }
                            
                        }
                        
                        
                    }
                
            }
        }else{
            self.table.reloadData()
            self.getdatahistory = false
            table.backgroundView = notconnection
            loading = false
        }
    }
    
    
    func adddata(){
        if CheckInternet.Connection(){
            if  !getdatahistory{
                print("tambahdata")
          
                let rowakhir = self.data.count
                self.delegate.getdata(status: true)
                loading = true
                self.getdatahistory = true
                if  let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                        self.api.gethiostorybyurl(token: token,url : self.nextpage ) { (data,nextsp) in
                            self.nextpage = ""
                            self.nextpage = nextsp

                            
                            if data != nil {
                                print("End get data")
                                print(data?.count)
                                
                                self.table.isScrollEnabled = false
                                self.table.beginUpdates()
                                for index in data!{
                                    print("add row data")
                                    
                                    self.data.append(index)
                                    
                                    self.table.insertRows(at: [IndexPath(row: self.data.count-1, section: 0)], with: .none)
                                    
                                }
                                self.table.endUpdates()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                self.getdatahistory = false
                                if nextsp == ""{
                                    self.loading = false
                                    self.table.beginUpdates()
                                    self.table.deleteRows(at: [IndexPath(row: self.data.count, section: 0)], with: .automatic)
                                    self.table.endUpdates()
                                    
                                }else{
                                    self.loading = true
                                    
                                }
                                self.delegate.getdata(status: false)
                                self.table.isScrollEnabled = true
                                
                                print("load")
                                
                                
                                
                            }
                        }
                        
                        
                    }
                
            }
        }else{
            self.getdatahistory = false
            table.backgroundView = notconnection
            loading = false
        }
    }
    
    
    func getday(waktu : String)->String{
        let dateFormatters = DateFormatter()
        dateFormatters.dateFormat = "yyyy'-'MM'-'dd'"
        let dates = dateFormatters.date(from: waktu)!
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: dates)
        
        var bulanstring = ""
        let bulanformat = DateFormatter()
        bulanformat.dateFormat = "MM"
        let bulan = bulanformat.string(from: dates)
        
        let tahunformat = DateFormatter()
        tahunformat.dateFormat = "yyyy"
        let taun = tahunformat.string(from: dates)
        
        let tglformat = DateFormatter()
        tglformat.dateFormat = "dd"
        let tgl = tglformat.string(from: dates)
        
        print( "ini bulan \(bulan)")
        
        switch Int(bulan) {
        case 1:
            bulanstring = "Jan"
        case 2:
            bulanstring = "Feb"
        case 3:
            bulanstring = "Mar"
        case 4:
            bulanstring = "Apr"
        case 5:
            bulanstring = "Mei"
        case 6:
            bulanstring = "Jun"
        case 7:
            bulanstring = "Jul"
        case 8:
            bulanstring = "Agu"
        case 9:
            bulanstring = "Sep"
        case 10:
            bulanstring = "Okt"
        case 11:
            bulanstring = "Nov"
        case 12:
            bulanstring = "Des"
            
        default:
            print("Error")
        }
        
        let tanggals = "\(tgl)-\(bulanstring)-\(taun)"
        switch dayInWeek {
        case "Monday":
          return "Sen, \(tanggals)"
        case "Tuesday":
          return "Sel, \(tanggals)"
        case "Wednesday":
          return "Rab, \(tanggals)"
        case "Thursday":
          return "Kam, \(tanggals)"
        case "Friday":
          return "Jum, \(tanggals)"
        case "Saturday":
          return "Sab, \(tanggals)"
        case "Sunday":
          return "Min, \(tanggals)"
        default:
            return "\(dayInWeek), \(tanggals)"
        }
        
        
       
    }
    
    
    
    func currency(_ total :Int)->String{
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        let minprice = formatter.string(from: NSNumber(value: total))
        let hideidr = minprice!.replacingOccurrences(of: "IDR", with: "")
        return "Rp. \(hideidr.replacingOccurrences(of: "$", with: ""))"
    }
    
}


extension childhistoryViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //    historiescellobatTableViewCell
        
        if loading {
            print("loading true")
            return data.count == 0 ? 1 : data.count + 1
        }else{
            print("loading false")
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("row => \(indexPath.row) =>>>\(self.data.count) ")
        print( self.loading)
        print(self.nextpage)
        if self.loading && self.nextpage != "" &&  self.data.count > 0 {
            let rows = self.data.count - 2
            if indexPath.row == rows  {
                self.adddata()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data[indexPath.row].type_history == "1"{
            let vc = UIStoryboard(name: "Ordertracking", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "ordertrackingtransaksiViewController") as? ordertrackingtransaksiViewController
            vc?.id = String(data[indexPath.row].detail_medicine[0].order_id)
            
            present(vc!, animated: true, completion: nil)
              
        }else{
            print("masuk")
            print(data[indexPath.row].detail_consultation!.consultation_id)
            self.query = ConsultationModel.query()
            self.query = self.query.whereKey("consultation_id", equalTo: Int(data[indexPath.row].detail_consultation!.consultation_id))
            
            self.query.findObjectsInBackground(block: { (results, error) in
                let consultation = results as! [ConsultationModel]
                   
                    
                    DispatchQueue.main.async {
                        let vc = DetailChatViewController()
                        
                        vc.uuid_patient = self.data[indexPath.row].detail_consultation!.patient.uuid
                        vc.uuid_doctor = self.data[indexPath.row].detail_consultation!.doctor.uuid
                        vc.email_patient =  self.data[indexPath.row].detail_consultation!.patient.email
                        vc.email_doctor =  self.data[indexPath.row].detail_consultation!.doctor.email
                        let patient = ConsultationUserModel(activated_at: nil,
                                                           activation_code: nil,
                                                           balance: nil,
                                                           banned_at: nil,
                                                           banned_reason: nil,
                                                           blocked_at: nil,
                                                           blocked_reason: nil,
                                                           created_at: nil,
                                                           device_id: nil,
                                                           email: self.data[indexPath.row].detail_consultation!.patient.email,
                                                           email_verified_at: self.data[indexPath.row].detail_consultation!.patient.email,
                                                           full_name: self.data[indexPath.row].detail_consultation!.patient.full_name,
                                                           gender: self.data[indexPath.row].detail_consultation!.patient.gender,
                                                           last_activity: nil,
                                                           map_lat: nil, map_lng: nil,
                                                           parent_id: nil,
                                                           parse: nil,
                                                           phone_number: self.data[indexPath.row].detail_consultation!.patient.phone_number,
                                                           profile_picture: self.data[indexPath.row].detail_consultation!.patient.image,
                                                           ref_id: nil,
                                                           ref_type: nil,
                                                           registered_at: nil,
                                                           status: nil,
                                                           updated_at: nil, uuid: self.data[indexPath.row].detail_consultation!.patient.uuid)
                        
                        let doctor = ConsultationUserModel(activated_at: nil,
                                                           activation_code: nil,
                                                           balance: nil,
                                                           banned_at: nil,
                                                           banned_reason: nil,
                                                           blocked_at: nil,
                                                           blocked_reason: nil,
                                                           created_at: nil,
                                                           device_id: nil,
                                                           email: self.data[indexPath.row].detail_consultation!.doctor.email,
                                                           email_verified_at: self.data[indexPath.row].detail_consultation!.doctor.email,
                                                           full_name: self.data[indexPath.row].detail_consultation!.doctor.full_name,
                                                           gender: self.data[indexPath.row].detail_consultation!.doctor.gender,
                                                           last_activity: nil,
                                                           map_lat: nil, map_lng: nil,
                                                           parent_id: nil,
                                                           parse: nil,
                                                           phone_number: self.data[indexPath.row].detail_consultation!.doctor.phone_number,
                                                           profile_picture: self.data[indexPath.row].detail_consultation!.doctor.profile_picture,
                                                           ref_id: nil,
                                                           ref_type: nil,
                                                           registered_at: nil,
                                                           status: nil,
                                                           updated_at: nil, uuid: self.data[indexPath.row].detail_consultation!.doctor.uuid)
                        
                        
                        
                        let cconsul = ConsultationPostModel(consultation_id: Int(self.data[indexPath.row].detail_consultation!.consultation_id), doctor: doctor, patient: patient)
                        
                        vc.currentConsultation = cconsul
                        vc.currentDoctor = consultation[0].doctor
                        vc.currentUser = consultation[0].patient
                        
                        
                        let nav = UINavigationController(navigationBarClass: UICustomNavigationBar.self, toolbarClass: nil)
                        nav.modalPresentationStyle = .fullScreen
                        nav.pushViewController(vc, animated: false)
                        self.present(nav, animated: true, completion: nil)
                        
//                        UserDefaults.standard.set(true, forKey: AppSettings.ON_CHAT)
//                        weak var pvc = self.presentingViewController

                    }
                
                
            })

            

        }
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("selected = >>\(selected) loading=> \(loading)")
        if loading{
            if data.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "loading", for: indexPath)
                return cell
            }else{
                if indexPath.row < data.count{
                    if data[indexPath.row].type_history == "2" {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "konsultasi", for: indexPath) as! historiescellkonsulTableViewCell
                        cell.row = indexPath.row
                        cell.backgroundColor = UIColor.clear
                        cell.namedokter.text = data[indexPath.row].name
                        cell.totalharga.text = currency(data[indexPath.row].total)
                        cell.waktu.text = getday(waktu: data[indexPath.row].transaction_date)
                        cell.delegate = self
                        if data[indexPath.row].status ==  "FINISHED" || data[indexPath.row].status ==  "SESI BERAKHIR"{
                            cell.status.text = " Berhasil"
                            cell.status.textColor = UIColor.init(rgb: 0x005377)
                        }else{
                            cell.status.text = " Ditolak"
                            cell.status.textColor = UIColor.init(rgb: 0xE75656)
                        }
                    
                      
                        if data[indexPath.row].rating > 0 {
                            cell.penilaian.isHidden = true
                        }else{
                            cell.penilaian.isHidden = false
                        }
                        
                        
                        if data[indexPath.row].detail_consultation?.doctor_note.next_schedule == "" {
                            cell.wobat.constant = 0
                        }else{
                            cell.wobat.constant = 36.5
                        }
                        
                        if data[indexPath.row].detail_consultation?.prescription.consultation_id == "" {
                            cell.wresep.constant = 0
                        }else{
                            cell.wresep.constant = 36.5
                        }
                        //
                        
                        if !(data[indexPath.row].detail_consultation?.spa ?? false) {
                            cell.wwaktu.constant = 0
                        }else{
                            cell.wwaktu.constant = 36.5
                            
                        }
                        
                        cell.layoutIfNeeded()
                        
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "pembelian", for: indexPath) as! historiescellobatTableViewCell
                        cell.row = indexPath.row
                        cell.namadokter.text = data[indexPath.row].detail_medicine[0].name
                        cell.backgroundColor = UIColor.clear
                        print("totaks")
                        print(data[indexPath.row].detail_medicine.count)
                        if data[indexPath.row].detail_medicine.count > 1{
                            cell.more.text = "\(data[indexPath.row].detail_medicine.count - 1) obat lainnya"
                        }else{
                            cell.more.isHidden = true
                        }
                        cell.statustext(status: data[indexPath.row].status)
                        cell.total.text = currency(data[indexPath.row].total)
                        cell.waktu.text = getday(waktu: data[indexPath.row].transaction_date)
                        
                        
//                        print(indexPath.row)
//                        print("status : " + data[indexPath.row].status)
//
//                        switch data[indexPath.row].status {
//                        case "Accepted":
//                            cell.status.textColor = UIColor.init(rgb: 0x005377)
//                            cell.status.text = "Diterima"
//                        case "Delivered":
//                            cell.status.textColor = UIColor.init(rgb: 0x70C900)
//                            cell.status.text = "Dikirim"
//                        case "Paid":
//                            cell.status.textColor = UIColor.init(rgb: 0xFFD600)
//                            cell.status.text = "Diproses"
//
//                        case "Rejected":
//                            cell.status.textColor = UIColor.init(rgb: 0xE75656)
//                            cell.status.text = "Ditolak"
//                        case "Cancel By System":
//                            cell.status.textColor = UIColor.init(rgb: 0xE75656)
//                            cell.status.text = "Pesanan gagal"
//
//                        case "Solved":
//                            cell.status.textColor = UIColor.init(rgb: 0x70C900)
//                            cell.status.text = "Dikirim"
//                        default:
//                            cell.status.textColor = UIColor.init(rgb: 0xE75656)
//                            cell.status.text = "Pesanan gagal"
//
//                        }
//
                        return cell
                    }
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "loading", for: indexPath)
                    return cell
                }
            }
            
        }else{
            print("pathrow")
            if data[indexPath.row].type_history == "2" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "konsultasi", for: indexPath) as! historiescellkonsulTableViewCell
                cell.row = indexPath.row
                cell.backgroundColor = UIColor.clear
                cell.namedokter.text = data[indexPath.row].name
                cell.totalharga.text = currency(data[indexPath.row].total)
                cell.waktu.text = getday(waktu: data[indexPath.row].transaction_date)
                cell.delegate = self
                if data[indexPath.row].status ==  "FINISHED" || data[indexPath.row].status ==  "SESI BERAKHIR"{
                    cell.status.text = " Berhasil"
                    cell.status.textColor = UIColor.init(rgb: 0x005377)
                }else{
                    cell.status.text = " Ditolak"
                    cell.status.textColor = UIColor.init(rgb: 0xE75656)
                }
            
                if data[indexPath.row].rating > 0 {
                    cell.penilaian.isHidden = true
                }else{
                    cell.penilaian.isHidden = false
                }
                
                
                if data[indexPath.row].detail_consultation?.doctor_note.next_schedule == "" {
                    cell.wobat.constant = 0
                }else{
                    cell.wobat.constant = 36.5
                }
                
                if data[indexPath.row].detail_consultation?.prescription.consultation_id == "" {
                    cell.wresep.constant = 0
                }else{
                    cell.wresep.constant = 36.5
                }
                //
                
                if !(data[indexPath.row].detail_consultation?.spa ?? false) {
                    cell.wwaktu.constant = 0
                }else{
                    cell.wwaktu.constant = 36.5
                    
                }
                
                cell.layoutIfNeeded()
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "pembelian", for: indexPath) as! historiescellobatTableViewCell
                cell.row = indexPath.row
                cell.namadokter.text = data[indexPath.row].detail_medicine[0].name
                cell.backgroundColor = UIColor.clear
                print("totaks")
                print(data[indexPath.row].detail_medicine.count)
                if data[indexPath.row].detail_medicine.count > 1{
                    cell.more.text = "\(data[indexPath.row].detail_medicine.count - 1) obat lainnya"
                }else{
                    cell.more.isHidden = true
                }
                
                cell.statustext(status: data[indexPath.row].status)
                cell.total.text = currency(data[indexPath.row].total)
                cell.waktu.text = getday(waktu: data[indexPath.row].transaction_date)
//                print(indexPath.row)
//                print("status : " + data[indexPath.row].status)
                
                
//                switch data[indexPath.row].status {
//                case "Accepted":
//                    cell.status.textColor = UIColor.init(rgb: 0x005377)
//                    cell.status.text = "Diterima"
//                case "Delivered":
//                    cell.status.textColor = UIColor.init(rgb: 0x70C900)
//                    cell.status.text = "Dikirim"
//                case "Paid":
//                    cell.status.textColor = UIColor.init(rgb: 0xFFD600)
//                    cell.status.text = "Diproses"
//
//                case "Rejected":
//                    cell.status.textColor = UIColor.init(rgb: 0xE75656)
//                    cell.status.text = "Ditolak"
//                case "Cancel By System":
//                    cell.status.textColor = UIColor.init(rgb: 0xE75656)
//                    cell.status.text = "Pesanan gagal"
//
//                case "Solved":
//                    cell.status.textColor = UIColor.init(rgb: 0x70C900)
//                    cell.status.text = "Dikirim"
//
//
//                default:
//                    cell.status.textColor = UIColor.init(rgb: 0xE75656)
//                    cell.status.text = "Pesanan gagal"
//                }
                
                return cell
            }
        }
        
        
        
    }
    
    
    
}


extension childhistoryViewController: historiescellkonsulTableViewCelldelegate,ratingViewControllerdelegate{
    func kembalirating() {
        getdata()
    }
    
    func chatulang(row: Int) {
        let vc = UIStoryboard(name: "Profiledokter", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "profiledoktermasterViewController") as? profiledoktermasterViewController
        vc?.data = data[row].detail_consultation!.doctor
        vc?.uuid = data[row].detail_consultation!.doctor.uuid
        present(vc!, animated: true, completion: nil)
    }
    
    func nilai(row: Int) {
        let vc = UIStoryboard(name: "rating", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "ratingViewController") as? ratingViewController
          vc?.id = data[row].detail_consultation!.consultation_id
          vc?.delegate = self
          self.present(vc!, animated: false, completion: nil)
    }
    
    
  
}

extension childhistoryViewController : historypembelianViewControllerdelegatetochild{
    func sendding(uuid: String, selected: Int) {
        //        if self.uuid != uuid && self.selected != selected{
        self.selected = nil
        self.uuid = ""
        self.selected = selected
        self.uuid = uuid
        //        }
        
    }
    
    func lokasi(long: Double?, lat: Double?, alamat: String) {
        self.long = long
        self.lat = lat
        self.alamat = alamat
    }
    
    func connectionfailed() {
        table.backgroundView = notconnection
        loading = false
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("scroll = > \(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y < CGFloat(50) {
            if (self.lastContentOffset > scrollView.contentOffset.y) {
                self.delegate.open()
            }
        }else{
            if (self.lastContentOffset - CGFloat(100) > scrollView.contentOffset.y) {
                self.delegate.open()
                
            }
        }
        if scrollView.contentOffset.y  > CGFloat(70){
            if (self.lastContentOffset < scrollView.contentOffset.y) {
                print("kebawah")
                self.delegate.close()
            }
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("end")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("ending")
        self.lastContentOffset = scrollView.contentOffset.y
        
        
    }
    
    
    
}

