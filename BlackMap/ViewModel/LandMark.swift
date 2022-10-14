//
//  LandMark.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/14.
//

import Foundation
import MapKit

struct Landmark: Equatable {
    static func == (lhs: Landmark, rhs: Landmark) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String = UUID().uuidString
    let name: String
    let location: CLLocationCoordinate2D
}

final class LandmarkAnnotation: NSObject, MKAnnotation {
    let id: String
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(landmark: Landmark) {
        self.id = landmark.id
        self.title = landmark.name
        self.coordinate = landmark.location
    }
}
