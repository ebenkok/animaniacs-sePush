//
//  OutageMapView.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/13.
//

import SwiftUI
import MapKit

struct ContainerView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    // @State var tracking: MapUserTrackingMode= = .follow
    @State var manager = CLLocationManager()
    @State var managerDelegate = locationDelegate()
    @State var mapDelegate = BlackMapDelegate()
    
    var body: some View {
        VStack {
            OutageMapView()
        }.edgesIgnoringSafeArea(.all)
            .onAppear {
                
                //manager.delegate = managerDelegate
                manager.requestWhenInUseAuthorization()
                manager.startUpdatingLocation()
                
            }
    }
    
}

struct OutageMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
                                                   mapView.delegate = context.coordinator
        
       // mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = true
        
        //uiView.setCenter(currentLocation, animated: true)
        uiView.userTrackingMode = .follow
    }
    
    
    //    func makeCoordinator() -> MapViewCoordinator{
    //         MapViewCoordinator(self)
    //    }
    //
    //    func makeUIView(context: Context) -> MKMapView {
    //        MKMapView(frame: .zero)
    //    }
    //
    //    func updateUIView(_ uiView: MKMapView, context: Context) {
    //        uiView.delegate = context.coordinator
    //    }
    //
    //    typealias UIViewType = UIView
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var mapViewController: OutageMapView
        
        init(_ control: OutageMapView) {
            self.mapViewController = control
        }
        
        func mapView(_ mapView: MKMapView, viewFor
                     annotation: MKAnnotation) -> MKAnnotationView?{
            //Custom View for Annotation
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
            annotationView.canShowCallout = true
            //Your custom image icon
            annotationView.image = UIImage(named: "locationPin")
            return annotationView
        }
    }
    
}



struct OutageMapView_Previews: PreviewProvider {
    static var previews: some View {
        OutageMapView()
    }
}

class BlackMapDelegate: NSObject, MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        print("selected annotation")
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
