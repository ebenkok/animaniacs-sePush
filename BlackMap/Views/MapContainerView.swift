//
//  OutageMapView.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/13.
//

import SwiftUI
import MapKit


// MARK: - MapView start
struct MapView: UIViewRepresentable {
    @Binding var landmarks: [Landmark]
    @Binding var selectedLandmark: Landmark?
    @State var manager = CLLocationManager()
    @State var managerDelegate = locationDelegate()
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        manager.delegate = managerDelegate
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        map.showsUserLocation = true
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateAnnotations(from: uiView)
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
            let newAnnotations = landmarks.map { LandmarkAnnotation(landmark: $0) }
            mapView.addAnnotations(newAnnotations)
            if let selectedAnnotation = newAnnotations.first(where: { $0.id == selectedLandmark?.id }) {
                mapView.selectAnnotation(selectedAnnotation, animated: true)
            }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var control: MapView

        init(_ control: MapView) {
            self.control = control
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let coordinates = view.annotation?.coordinate else { return }
            let span = mapView.region.span
            let region = MKCoordinateRegion(center: coordinates, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        
    }
}

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

// MARK: - MapView - End

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

class locationDelegate: NSObject,ObservableObject,CLLocationManagerDelegate{
    
    @Published var pins : [Pin] = []
    //@Published var publishedError: Error? = nil
    // Checking authorization status...
    
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
        pins.append(Pin(location:locations.last!))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
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
