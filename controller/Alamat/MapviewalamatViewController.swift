//
//  MapviewalamatViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 16/08/21.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces



protocol MapviewalamatViewControllerdelegate {
    func tambahdata(alamat:AlamatModel)
    func editdata(alamat:AlamatModel ,row:Int)
}
class MapviewalamatViewController: MYUIViewController,CLLocationManagerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var searchs: UITextField!
    @IBOutlet weak var viewtexts: UIView!
    @IBOutlet weak var viewsnotes: UIView!
    @IBOutlet weak var mapview: GMSMapView!
    let infoMarker = GMSMarker()
    @IBOutlet weak var detailaddress: UILabel!
    let locationManager = CLLocationManager()
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var terapkan: UIView!
    @IBOutlet weak var favoritcheck: UIImageView!
    var lat :Double?
    var long : Double?
    var selectedrow = 0
    var alamat = Address()
    @IBOutlet weak var viewnote: UIView!
    var alamatmodel : AlamatModel!
    var delegate :MapviewalamatViewControllerdelegate!
    var row = 0
    
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var headerlabel: UILabel!
    var tambah = true
    
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var viewtap: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewtap.isHidden = true
        mapview.delegate = self
        collection.delegate = self
        collection.dataSource = self
        terapkan.backgroundColor = Colors.basicvalue
        terapkan.layer.cornerRadius = terapkan.frame.height / 2
        viewtexts.layer.cornerRadius = viewtexts.frame.height / 2
        viewnote.layer.cornerRadius = 8
        terapkan.backgroundColor = Colors.basicvalue
        mapview.isMyLocationEnabled = true
        viewsnotes.layer.cornerRadius = 10
        headerlabel.text = tambah ? "Tambah alamat" : "Ubah alamat"
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        terapkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(send)))
//        views.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(diss)))
      
        note.returnKeyType = .done
        note.delegate = self

    }
    
    @IBAction func chnge(_ sender: Any) {
        autocompleteClicked()
    }
    
    
    @objc func diss(){
     
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                
        if textField == note{
            view.endEditing(true)
        }
        return true
    }
    
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    @objc func send(){
        print("\(lat)")
        print("\(long)")

        if lat != nil && long != nil {
            let type = selectedrow == 0 ? "Tambah alamat lainnya" : selectedrow == 1  ? "Alamat rumah" : "Alamat kantor"
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                    if self.tambah {
                        let data = AlamatModel(address: self.detailaddress.text!, address_type: type, id: "", map_lat: "\(self.lat!)", map_lng: "\(self.long!)", note: self.note.text ?? "", patient_id: "")
                        self.alamat.addaddress(data: data, token: token) {
                            self.delegate.tambahdata(alamat: data)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else{
                        print(self.lat)
                        self.alamatmodel.address = self.detailaddress.text!
                        self.alamatmodel.address_type = type
                        self.alamatmodel.map_lat = "\(self.lat!)"
                        self.alamatmodel.map_lng = "\(self.long!)"
                        self.alamatmodel.note = self.note.text ?? ""
                        
                        self.alamat.updateaddress(data: self.alamatmodel, uuid: UserDefaults.standard.string(forKey: AppSettings.uuid) ?? "", token: token) {
                            self.delegate.editdata(alamat: self.alamatmodel, row: self.row)

                            self.dismiss(animated: true, completion: nil)
                            
                        }
                    }
                }
            
        }else{
            Toast.show(message: "kordinat tidak diketahui. Pilih lokasi terlebih dahulu", controller: self)
        }
      
        
        
    }
    
    func autocompleteClicked() {
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self

      // Specify the place data types to return.
      let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
        UInt(GMSPlaceField.placeID.rawValue))!
      autocompleteController.placeFields = fields

      // Specify a filter.
      let filter = GMSAutocompleteFilter()
      filter.type = .address
      autocompleteController.autocompleteFilter = filter

      // Display the autocomplete view controller.
      present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (CLLocationManager.locationServicesEnabled()) {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if tambah{
            let dd = GMSCameraPosition.camera(withLatitude: locations[0].coordinate.latitude, longitude:locations[0].coordinate.longitude, zoom: 20.0)
            mapview.animate(to: dd)
            mapview.settings.myLocationButton = true
            mapview.isMyLocationEnabled = true
            let position = CLLocationCoordinate2DMake(locations[0].coordinate.latitude,locations[0].coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.map = mapview
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)) { (locstring, err) in
                if let _ = err {
                    return
                }
                let pm = locstring! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = locstring![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    self.detailaddress.text = addressString
                    print(addressString)
                }
                
                
            }
            
        }else{
            let dd = GMSCameraPosition.camera(withLatitude: Double(alamatmodel.map_lat) ?? 0.0, longitude:Double(alamatmodel.map_lng) ?? 0.0, zoom: 20.0)
            detailaddress.text = alamatmodel.address
            long = Double(alamatmodel.map_lng) ?? 0.0
            lat = Double(alamatmodel.map_lat) ?? 0.0

            note.text = alamatmodel.note
            mapview.animate(to: dd)
            mapview.settings.myLocationButton = true
            mapview.isMyLocationEnabled = true
            let position = CLLocationCoordinate2DMake(Double(alamatmodel.map_lat) ?? 0.0,Double(alamatmodel.map_lng) ?? 0.0)
            let marker = GMSMarker(position: position)
            marker.map = mapview
        }
        
        
        locationManager.stopUpdatingLocation()
        
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        mapview.clear()
        long = coordinate.longitude
        lat = coordinate.latitude
        let position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loc) { (locstring, err) in
            if let _ = err {
                return
            }
            let pm = locstring! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = locstring![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                self.detailaddress.text = addressString
                
                print(addressString)
            }
            
            
        }
        
        let marker = GMSMarker(position: position)
        marker.map = mapview
    }
    
}

extension MapviewalamatViewController: UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! celltypealamatCollectionViewCell
        
        if selectedrow == indexPath.row{
            cell.labels.textColor = .white
            cell.bg.backgroundColor = Colors.selectedtypealamat
            //            cell.layer.borderColor = color.selectedtypealamat().cgColor
            //            cell.layer.borderWidth = 1
        }else{
            cell.labels.textColor = Colors.basiclabel
            cell.bg.backgroundColor = .white
            cell.bg.layer.borderColor = Colors.basiclabel.cgColor
            cell.bg.layer.borderWidth = 1
        }
        cell.bg.layer.cornerRadius = 5
        self.view.layoutIfNeeded()
      
        
        
        switch indexPath.row {
        case 0:
            if selectedrow == 0{
                cell.image.image = UIImage(named: "alamat lain2 putih")
                cell.labels.text = "Tambah alamat lainnya"
            }else{
                cell.image.image = UIImage(named: "alamat lain2 abu")
                cell.labels.text = "Tambah alamat lainnya"
            }
            
            
            return cell
        case 1:
            if selectedrow == 1{
                cell.image.image = UIImage(named: "alamat home putih")
                cell.labels.text = "Alamat rumah"
            }else{
                cell.image.image = UIImage(named: "alamat home abu")
                cell.labels.text = "Alamat rumah"
            }
            
            return cell
            
            
        default:
            if selectedrow == 2{
                cell.image.image = UIImage(named: "alamat office putih")
                cell.labels.text = "Alamat kantor"
            }else{
                cell.image.image = UIImage(named: "alamat office abu")
                cell.labels.text = "Alamat kantor"
            }
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedrow = indexPath.row
        print("print uhuy")

        collection.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        var item =  ""
        switch indexPath.row {
        case 0:
            item = "Tambah alamat lainnya"
        case 1:
            item = "Alamat rumah"
        default :
            item = "Alamat kantor"
        }
        
        self.view.layoutIfNeeded()
        let tinggi = collection.frame.height
        
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)
        ])
        let luas = CGSize(width: itemSize.width + tinggi + CGFloat(40), height: CGFloat(30))
        return luas
    }
    
    
}

extension MapviewalamatViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        
        infoMarker.snippet = placeID
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapview.selectedMarker = infoMarker
        
    }
    
    
    
    
}

extension MapviewalamatViewController:GMSAutocompleteViewControllerDelegate{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      print("Place name: \(place.name)")
      print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        print("Place attributions: \(place.coordinate.longitude)")
        print("Place attributions: \(place.viewport?.northEast.latitude)")
      

        
        let placesClient = GMSPlacesClient()

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                        UInt(GMSPlaceField.coordinate.rawValue) |
                                                    
          UInt(GMSPlaceField.placeID.rawValue))!

        placesClient.fetchPlace(fromPlaceID: place.placeID!, placeFields: fields, sessionToken: nil, callback: {
          (places: GMSPlace?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }
            self.dismissKeyboard()
          if let places = places {
         
            self.searchs.text = places.name ?? ""
            print("The selected place is: \(places.coordinate)")
            
            
            let dd = GMSCameraPosition.camera(withLatitude: places.coordinate.latitude + 0.0006, longitude: places.coordinate.longitude - 0.0006, zoom: 18.0)
            self.mapview.animate(to: dd)
          }
        })
        
      dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
      // TODO: handle the error.
      print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
      dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
