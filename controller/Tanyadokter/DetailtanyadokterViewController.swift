//
//  DetailtanyadokterViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 08/07/21.
//

import UIKit
import Kingfisher

class DetailtanyadokterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var navi: UIView!
    @IBOutlet weak var viewsearch: UIView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var collfilter: UICollectionView!
    @IBOutlet weak var filter: UIImageView!
    @IBOutlet var notconnection: UIView!
    @IBOutlet var notfound: UIView!
    @IBOutlet weak var headerlabel: UILabel!
    var header = ""
    @IBOutlet weak var back: UIImageView!
    var token = ""
    var id = ""
    var lastContentOffset : CGFloat = 0.0
    var filterselected : [String] = []
    var loading = false
    @IBOutlet var funcspesial: Specialist!
    @IBOutlet weak var tables: UITableView!
    var data : [Newdetailtanyadokter]?
    var nextpage:String?
    var getdata = false
    var datafilter  :filterdokter?
    var actions = false
    var isform = false

    //tinggi
    @IBOutlet weak var tinggiviewsearch: NSLayoutConstraint!
    @IBOutlet weak var tinggifiltercollection: NSLayoutConstraint!
    var facilityid : String?
    var list : [listformmodel] = []
//    var valueform : [valuesonform] = []
    
    
    @IBOutlet weak var viewtool: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        headerlabel.text = header
        headerlabel.textColor = Colors.headerlabel
        tables.delegate = self
        tables.dataSource = self
        collfilter.delegate = self
        collfilter.dataSource = self
        collfilter.backgroundColor = Colors.backgroundmaster
        tables.bounces = false
        print("isform = > \(isform)" )

        
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backacc)))
        shadownavigation.shadownav(view: navi)
        self.view.backgroundColor = Colors.backgroundmaster
        self.tables.backgroundColor = Colors.backgroundmaster
        tinggifiltercollection.constant = 0
        tinggiviewsearch.constant = CGFloat(65)
        viewsearch.layer.cornerRadius = viewsearch.frame.height / 2
        viewsearch.layer.borderWidth = 1
        viewsearch.layer.borderColor = UIColor.init(rgb: 0xdfdfdf).cgColor
        
        viewsearch.layer.masksToBounds = false
        viewsearch.layer.shadowColor = UIColor.black.cgColor
        viewsearch.layer.shadowOpacity = 0.2
        viewsearch.layer.shadowRadius = 3
        viewsearch.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        search.returnKeyType = UIReturnKeyType.done
        search.delegate = self
        
//        self.view.layoutIfNeeded()
//        tinggiheader.constant = CGFloat(self.view.frame.width / 8 )
        
        self.view.layoutIfNeeded()
//        layoutopen()
        if CheckInternet.Connection(){
            loading = true
            getdata = true
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){

                  
                    self.funcspesial.getfilter(token: token) { ( data ) in
                        
                        if data != nil {
                            
                            self.datafilter = data!
                            print("uuu")
                            for index in data!.experince{
                                print(index.value)
                            }
                           
                            
                        }
                    }
                    self.getdatadokter()
                   
                }
            
        }else{
            tables.backgroundView = notconnection
        }
        
        filter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filteracc)))
        
        
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "logout"){
            dismiss(animated: false, completion: nil)
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func done(_ sender: Any) {
        
        if self.actions{
            getdatadokter()
        }
      
        
    }
    
    func getdatadokter(){
        if CheckInternet.Connection(){
            data = nil
            loading = true
            getdata = true
            self.tables.reloadData()

            self.funcspesial.specialist1(token: self.token, id: self.id, filter: self.datafilter, search: search.text ?? "", facilityid: self.facilityid ) { (data) in
                
                self.tables.backgroundView = nil
                self.getdata = false
                if data != nil {
                    self.data = data!.data
                    if data!.nextpage == ""{
                        self.nextpage = nil
                        self.loading = false
                    }else{
                        self.loading = true
                        self.nextpage = data!.nextpage
                    }
                    self.tables.backgroundView = nil
                    self.tables.reloadData()
                }else{
                    self.loading = false
                    self.getdata = false
                    self.tables.backgroundView = self.notfound
                    self.tables.reloadData()
                    
                }
                self.actions = true
            }

        }else{
            tables.backgroundView = notconnection
        }
        
        
        
        
    }
    
    
    func layoutopen(){
//        print("layoutopen")
        self.view.layoutIfNeeded()
        collfilter.isHidden = true

        if filterselected.count > 0{
            
            tinggifiltercollection.constant = CGFloat(45)
            tinggiviewsearch.constant = CGFloat(115)
            collfilter.isHidden = false

        }else{
            tinggifiltercollection.constant = CGFloat(0)
            tinggiviewsearch.constant = CGFloat(65)
            collfilter.isHidden = true
        }


        self.view.layoutIfNeeded()

    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        print(loading)
       
//        if data != nil{
//            print("reload")
//            let index = IndexPath(item: indexPath.row, section: 0)
//            tableView.reloadRows(at: [index], with: .none)
//        }
//
        if loading && data != nil {
            let rows = nextpage == nil ? data!.count - 2 : data!.count
            
            
            if indexPath.row == rows  && !getdata{
                self.tables.isScrollEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.add()
                }
            }
        }
        
    }
    
    
    @objc func backacc(){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func add(){
        self.getdata = true
        self.funcspesial.specialistwithurl(token: self.token, url: self.nextpage!, filter: datafilter) { (data) in
            self.getdata = false
            if data != nil {
//                self.tables.isScrollEnabled = false
//                self.tables.beginUpdates()
                
                for index in data!.data{
                    self.tables.beginUpdates()
                    self.data!.append(index)
                    self.tables.insertRows(at: [IndexPath(row: self.data!.count-1, section: 0)], with: .bottom)
                    self.tables.endUpdates()

                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  
                    
                    self.tables.isScrollEnabled = true
                    if data!.nextpage == ""{
                        self.nextpage = nil
                        self.loading = false
                        self.tables.beginUpdates()
                        self.tables.deleteRows(at: [IndexPath(row: self.data!.count, section: 0)], with: .automatic)
                        self.tables.endUpdates()
                    }else{
                        self.loading = true
                        self.nextpage = data!.nextpage
                        
                    }
                    self.tables.backgroundView = nil
                }
                
            }else{
                self.tables.isScrollEnabled = true
            }
        }
    }
    
}
extension DetailtanyadokterViewController :UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterselected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! selectedfilterCollectionViewCell
        cell.layoutIfNeeded()
        cell.layer.cornerRadius = 15
        cell.name.text = filterselected[indexPath.row]
        cell.backgroundColor  = .clear
        
        return cell
    }
    
    
    
    
}


extension DetailtanyadokterViewController :DetailtanyadoktercellTableViewCellacc, UITableViewDelegate,UITableViewDataSource,transaksichatmasterViewControllerdelegate,filerdokterViewControllerdelegate{
    func kirimdatavalues(data: [listformmodel]) {
        self.list = data
    }
    
   
    
    func sendfilter(data: filterdokter) {
        filterselected.removeAll()
        for index in data.experince{
            if index.check{
                filterselected.append(index.name)
            }
        }
        for index in data.rates{
            if index.check{
                filterselected.append(index.name)
            }
        }
        datafilter = data
        //reload data
        collfilter.reloadData()
//        layoutopen()
        self.getdatadokter()
        UIView.animate(withDuration : 0.5){
            if self.filterselected.count > 0{
                self.tinggifiltercollection.constant = CGFloat(50)
                self.tinggiviewsearch.constant = CGFloat(115)
        }else{
            self.tinggifiltercollection.constant = 0
            self.tinggiviewsearch.constant = CGFloat(65)
        }
            self.view.layoutIfNeeded()
        }
      
       
        
        
    }
    
    func scrollenable(){
        
    }
    
    
    func close() {
        
    }
    
    func kirimdata(mdata: [ModelProfile], detaildokter: Detaildokter) {
        
    }
    
    
    
    
    func klikfoto(row: Int) {
        let vc = UIStoryboard(name: "Profiledokter", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "profiledoktermasterViewController") as? profiledoktermasterViewController
        //
        vc?.header = header
        vc?.uuid = data![row].uuid
        vc?.list = list
        vc?.isform = isform
//        vc?.valueform = valueform
        vc?.facilityid = facilityid
        
        present(vc!, animated: true, completion: nil)
    }
    
    func chat(row: Int) {
        if  data![row].status_docter == "Online"{
            let vc = UIStoryboard(name: "Chat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "transaksichatmasterViewController") as? transaksichatmasterViewController
            vc?.header = header
            vc?.list = list
            vc?.isform = isform

//            vc?.valueform = valueform
            ///
//            vc?.detaildokter = Newdetailtanyadokter
            vc?.facilityid = facilityid
            vc?.id = id
            vc?.uuid = data![row].uuid
            vc?.delegate = self
            present(vc!, animated: true, completion: nil)
        }
     
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if loading{
            return data == nil ? 1  : nextpage  == nil ? data!.count : data!.count + 1
        }else{
            return data == nil ? 0 : data!.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loading{
            if data == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "loading", for: indexPath) as! DetailtanyadoktercellTableViewCell
                
                cell.photo.layer.cornerRadius = cell.photo.frame.height / 2
                cell.backgroundColor = .clear
                cell.backgroundview.layer.shadowColor = UIColor.black.cgColor
                cell.backgroundview.layer.cornerRadius = 10
                cell.backgroundview.layer.shadowOffset = CGSize.zero
                cell.backgroundview.layer.shadowRadius = 3
                cell.backgroundview.layer.shadowOpacity = 0.3
                
                return cell
            }else{
                if indexPath.row ==  data!.count{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "loading", for: indexPath) as! DetailtanyadoktercellTableViewCell
                    
                    cell.photo.layer.cornerRadius = cell.photo.frame.height / 2
                    cell.backgroundColor = .clear
                    cell.backgroundview.layer.shadowColor = UIColor.black.cgColor
                    cell.backgroundview.layer.cornerRadius = 10
                    cell.backgroundview.layer.shadowOffset = CGSize.zero
                    cell.backgroundview.layer.shadowRadius = 3
                    cell.backgroundview.layer.shadowOpacity = 0.3
                    
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailtanyadoktercellTableViewCell
                    cell.isdata = true
                    let index = data![indexPath.row]
                    self.view.layoutIfNeeded()
                    cell.backgroundColor = .clear
                    cell.chatbutton.layer.cornerRadius  = 10
                    cell.row = indexPath.row
                    cell.delegate = self
                    let url = URL(string: data![indexPath.row].profile_picture)
                    
                    cell.photo.kf.setImage(with: url)
                    cell.photo.layer.cornerRadius = cell.photo.frame.height / 2
                    cell.quality.text = index.rating
                    cell.oldwork.text = index.experience
                    cell.name.text = index.full_name
                    cell.specialist.text = index.specialist
                    cell.available.text = index.description
                    cell.price.text = "Rp.\(index.rates)"
                    cell.status.layer.cornerRadius = cell.status.frame.height / 2
                    cell.chatcolor = index.color
                    cell.statuscolor = index.statuscolor
                 
                    cell.chatbutton.backgroundColor = index.color
                    cell.status.backgroundColor = index.statuscolor
       
                    cell.backgroundview.layer.shadowColor = UIColor.black.cgColor
                    cell.backgroundview.layer.cornerRadius = 10
                    cell.backgroundview.layer.shadowOffset = CGSize.zero
                    cell.backgroundview.layer.shadowRadius = 3
                    cell.backgroundview.layer.shadowOpacity = 0.3
                    cell.isdata = true
                    
                    return cell
                }
                
            }
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailtanyadoktercellTableViewCell
            cell.isdata = true
            let index = data![indexPath.row]
            self.view.layoutIfNeeded()
            cell.backgroundColor = .clear
            cell.chatbutton.layer.cornerRadius  = 10
            cell.row = indexPath.row
            cell.delegate = self
            let url = URL(string: data![indexPath.row].profile_picture)
            
            cell.photo.kf.setImage(with: url)
            cell.photo.layer.cornerRadius = cell.photo.frame.height / 2
            cell.quality.text = index.rating
            cell.oldwork.text = index.experience
            cell.name.text = index.full_name
            cell.specialist.text = index.specialist
            cell.available.text = index.description
            cell.price.text = "Rp.\(index.rates)"
            cell.status.layer.cornerRadius = cell.status.frame.height / 2
            cell.chatcolor = index.color
            cell.statuscolor = index.statuscolor
         
            cell.chatbutton.backgroundColor = index.color
            cell.status.backgroundColor = index.statuscolor

            cell.backgroundview.layer.shadowColor = UIColor.black.cgColor
            cell.backgroundview.layer.cornerRadius = 10
            cell.backgroundview.layer.shadowOffset = CGSize.zero
            cell.backgroundview.layer.shadowRadius = 3
            cell.backgroundview.layer.shadowOpacity = 0.3
            cell.isdata = true
            
            return cell
        }
        
    }
    
    
    @objc func filteracc(){
        if datafilter != nil {
            let vc = UIStoryboard(name: "Tanyadokter", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "filerdokterViewController") as? filerdokterViewController
            vc?.datafilter = datafilter
            vc?.delegate = self
            present(vc!, animated: false, completion: nil)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scroll = > \(scrollView.contentOffset.y)")


                if scrollView.contentOffset.y == 0.0{
                    UIView.animate(withDuration : 0.5){
                   
                        if self.filterselected.count > 0{
                            self.tinggifiltercollection.constant = CGFloat(45)
                            self.tinggiviewsearch.constant = CGFloat(115)
                        }else{
                            self.tinggifiltercollection.constant = CGFloat(0)
                            self.tinggiviewsearch.constant = CGFloat(65)
                        }
                        

                        
                        self.view.layoutIfNeeded()
                    }
                }

        if scrollView.contentOffset.y < CGFloat(65) {
            if (self.lastContentOffset > scrollView.contentOffset.y) {
                viewtool.isHidden = false
                UIView.animate(withDuration : 0.5){
               
                    if self.filterselected.count > 0{
                        self.tinggifiltercollection.constant = CGFloat(45)
                        self.tinggiviewsearch.constant = CGFloat(115)
                    }else{
                        self.tinggifiltercollection.constant = CGFloat(0)
                        self.tinggiviewsearch.constant = CGFloat(65)
                    }
                    

                    
                    self.view.layoutIfNeeded()
                }
            }
        }else{
            if (self.lastContentOffset - CGFloat(65) > scrollView.contentOffset.y) {
                viewtool.isHidden = false
                UIView.animate(withDuration : 0.5){
                    if self.filterselected.count > 0{
                        self.tinggifiltercollection.constant = CGFloat(45)
                        self.tinggiviewsearch.constant = CGFloat(115)
                    }else{
                        self.tinggifiltercollection.constant = CGFloat(0)
                        self.tinggiviewsearch.constant = CGFloat(65)
                    }
                    
                    self.view.layoutIfNeeded()
                }
            }
        }

        if scrollView.contentOffset.y  > CGFloat(70){
            if (self.lastContentOffset + CGFloat(10) < scrollView.contentOffset.y) {
//                print("kebawah")
                UIView.animate(withDuration : 0.5){

                    self.tinggifiltercollection.constant = CGFloat(0)
                    self.tinggiviewsearch.constant = CGFloat(0)
                    
                    self.view.layoutIfNeeded()

                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.56) {
//                    self.viewtool.isHidden = true
//                }
            }
        }

        //
        //        self.lastContentOffset = scrollView.contentOffset.y
        //        print("the last => \(lastContentOffset)")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print("ending")
        self.lastContentOffset = scrollView.contentOffset.y
    

        
        
    }
    
    
    
}
