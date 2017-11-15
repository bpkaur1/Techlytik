//
//  Places.swift
//  MapKit Starter
//
//  Created by Pranjal Satija on 10/25/16.
//  Copyright © 2016 Pranjal Satija. All rights reserved.
//

import MapKit

@objc class Place: NSObject {
    
    /*{
    "device_id" = "100 01-01-043-09W5 02";
    "device_lat" = "52.68515100";
    "device_lng" = "-115.17118700";
    "field_id" = 2;
    "field_name" = "Crimson Lake";
    "operator_run_no" = 1;
    }*/
    
    var title: String? //device_id
    var subtitle: String?  //field_name
    var coordinate: CLLocationCoordinate2D //lat,long
    var field_id:Int?
    var operator_run_no:Int?
    
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
//    static func getPlaces() -> [Place] {
//        guard let path = Bundle.main.path(forResource: "Places", ofType: "plist"),
//            let array = NSArray(contentsOfFile: path) else { return [] }
//        
//        var places = [Place]()
//        
//        for item in array {
//            let dictionary = item as? [String : Any]
//            let title = dictionary?["title"] as? String
//            let subtitle = dictionary?["description"] as? String
//            let latitude = dictionary?["latitude"] as? Double ?? 0, longitude = dictionary?["longitude"] as? Double ?? 0
//            
//            let place = Place(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
//            places.append(place)
//        }
//        
//        return places as [Place]
//    }
}

extension Place: MKAnnotation { }
