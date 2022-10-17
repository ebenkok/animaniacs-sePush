//
//  MapLocationDelegate.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/14.
//

import Foundation
import MapKit

class MapLocationDelegate: NSObject,ObservableObject,CLLocationManagerDelegate{
    
    @Published var pins : [MapPin] = []
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .authorizedWhenInUse{
            print("Authorized")
            manager.startUpdatingLocation()
        } else {
            print("not authorized")
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        pins.append(MapPin(location:locations.last!))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    

}
