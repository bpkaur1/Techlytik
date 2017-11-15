
//
//  MapviewController.swift
//  Techlytik
//
//  Created by mac new on 7/14/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
import MapKit
//import MBProgressHUD

class MapviewController: UIViewController
{
    
    let DISTANCE_IN_METERS = 12000.0;
    
    //MARK: IBOutlets
    @IBOutlet weak var listMapview: MKMapView!
    @IBOutlet weak var pinBtn: UIButton!
    
    //MARK: Gloabl variables
    let locationManager = CLLocationManager()
    var places:[Place]?
    var myLoader = URActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = Array.init()
         self.navigationItem.title = "MAP"
       
        // Add Add & Search Button on navigation
//        let adBarButtons = NavigationBarButtonActions()
//        adBarButtons.AddBarButtons(navCont: self.navigationController!, navItem: self.navigationItem)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        requestLocationAccess()
        listMapview.showsUserLocation = true
        downloadDevicePlaces();
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func downloadDevicePlaces(){
         myLoader.showActivityIndicator(uiView: APPWINDOW!)
//        MBProgressHUD.showAdded(to: self.view, animated:true)
        
        let jsonString = NSString(format: "{\"Key\": \"device_registration\",\"Return\": [{\"table\": \"device_registration\",\"fields\": [\"device_lat\",\"device_lng\",\"device_id\",\"operator_run_no\"]},{\"table\": \"organizatoins_fields\",\"fields\": [\"field_name\",\"field_id\"]}],\"conditions\": {\"organizatoins_fields.company_id\": \"%@\"},\"SearchType\": \"contains\",\"G\": false,\"L\": 0,\"GBY\": {\"table\": \"device_registration\",\"fields\": [\"device_lat\",\"device_lng\",\"device_id\",\"operator_run_no\"]},\"join\": {\"joinType\": \"INNER\",\"joinStatement\": [{\"table\": \"organizatoins_fields\",\"on\": [{\"parentTableField\": \"field_id\",\"childTableField\": \"field_id\"}]}]}}", "4")
        
        let jsonParameters = NSMutableDictionary(dictionary: convertToDictionary(text: jsonString as String)!)
        
        let url = URL(string: TKConstants.BASE_URL + TKConstants.MAPS_CALL)! //change the url
        
        let token:NSString = UserDefaults.standard.object(forKey: TKConstants.TK_TOKEN_CONSTANT) as! NSString
        
        let dataManager = TKDataManager()
        dataManager.downloadDataFromUrl(url: url as NSURL, jsonParameters: jsonParameters, token:token, httpMethod: "POST", viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
            
            if success {
                
                UserDefaults.standard.set(token, forKey: TKConstants.TK_TOKEN_CONSTANT)
                
                if let dataArray:Array<Dictionary<String, Any>> = jsonDictionary.object(forKey: "data") as? Array<Dictionary<String, Any>>{
                    for var dict:Dictionary in dataArray{
                        
                        let device_id:String = dict["device_id"] as! String
                        let lat:Double = Double(dict["device_lat"] as! String)!
                        let lon:Double = Double(dict["device_lng"] as! String)!
                        let field_id:Int = dict["field_id"] as! Int
                        
                        let field_name:String = dict["field_name"] as! String
                        let operator_run_no:Int = Int(dict["operator_run_no"] as! String)!
                        
                        
                        let p:Place = Place.init(title: device_id, subtitle: field_name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                        p.field_id = field_id
                        p.operator_run_no = operator_run_no
                        self.places?.append(p);
                    }
                }
                print(self.places!)
                
                
                DispatchQueue.main.async {
                    self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                    MBProgressHUD.hide(for: self.view, animated:true)
                    self.displayPlaces(places: self.places!)
                }
                
            }else{
                DispatchQueue.main.async {
                    self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                    MBProgressHUD.hide(for: self.view, animated:true)
                    
                    let alert = UIAlertController(title: "Error!", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        
    }
    
    func displayPlaces(places:[Place]){
        addAnnotations()
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func addAnnotations() {
        listMapview?.delegate = self
        listMapview?.addAnnotations(places!)
        
        if (places?.count)! > 0 {
            let p:Place = places![0]
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(p.coordinate,
                                                                      DISTANCE_IN_METERS * 2.0, DISTANCE_IN_METERS * 2.0)
            listMapview.setRegion(coordinateRegion, animated: true)
        }
    }
    
    @IBAction func pinBtnTpd(_ sender: Any) {
        _ = self.performSegue(withIdentifier: "configSegueFromMap", sender: self)
    }
}


extension MapviewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {

            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "greyPin.")
            annotationView.canShowCallout = true
            let calloutButton = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = calloutButton
            annotationView.sizeToFit()

            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        
        
        
        
        let anotherViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfigurationViewController") as! ConfigurationViewController
        if let p = view.annotation as? Place
        {
            UserDefaults.standard.set(p.title, forKey: TKConstants.TK_SELECTED_DEVICE_ID)
            
        }
        self.navigationController?.pushViewController(anotherViewController, animated: true)
        
    }
    
}
