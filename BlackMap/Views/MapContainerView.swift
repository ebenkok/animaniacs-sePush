//
//  OutageMapView.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/13.
//

import SwiftUI
import MapKit

struct MapContainerView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State var landmarks: [Landmark] = [
        Landmark(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
        Landmark(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997))
        ]

    
    @State var selectedLandmark: Landmark? = nil
    
    var body: some View {
        ZStack {
            MapView(landmarks: $landmarks, selectedLandmark: $selectedLandmark)
                    .edgesIgnoringSafeArea(.vertical)
            VStack {
                Spacer()
                Button("Next") {
                    self.selectNextLandmark()
                }
            }
        }
    }
    
    private func selectNextLandmark() {
        if let selectedLandmark = selectedLandmark, let currentIndex = landmarks.firstIndex(where: { $0 == selectedLandmark }), currentIndex + 1 < landmarks.endIndex {
            self.selectedLandmark = landmarks[currentIndex + 1]
        } else {
            selectedLandmark = landmarks.first
        }
    }
}



// Map pins for update
struct Pin : Identifiable {
    var id = UUID().uuidString
    var location : CLLocation
}


struct OutageMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapContainerView()
    }
}
