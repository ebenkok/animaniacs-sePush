//
//  MapView.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/14.
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
