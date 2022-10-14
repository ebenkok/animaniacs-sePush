//
//  MapPin.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/14.
//

import Foundation
import MapKit

// Map pins for update
struct MapPin : Identifiable {
    var id = UUID().uuidString
    var location : CLLocation
}

