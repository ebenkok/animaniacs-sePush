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
    @State var managerDelegate = MapLocationDelegate()
    @Binding var polygons: [MKOverlay]
    
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
        //print($polygons)
//        let poly = $polygons {
//            poly.
//        }
        for item in polygons {
            uiView.addOverlay(item)
         //   uiView.setVisibleMapRect(item.boundingMapRect, animated: true)
        }
        //uiView.addOverlays(polygons)
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
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            //MARK: -Checking and type casting MKOverlay into Polygon
            if let polygon = overlay as? MKPolygon {
                
                let renderer = MKPolygonRenderer(polygon: polygon)
                
                //MARK: -Custom shape fillColor based on latest renderer data
//                if overlayer.shared.polygonInfo.jumlah == 0 {
//                    renderer.fillColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.5)
//                }
//                else if overlayer.shared.polygonInfo.jumlah > 0 && overlayer.shared.polygonInfo.jumlah < 100 {
//                    renderer.fillColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 0.5)
//                }
//                
//                else if overlayer.shared.polygonInfo.jumlah > 99 && overlayer.shared.polygonInfo.jumlah < 300 {
//                    renderer.fillColor = UIColor(red: 255/255, green: 174/255, blue: 66/255, alpha: 0.5)
//                }
//                
//                else if overlayer.shared.polygonInfo.jumlah > 300 {
//                    renderer.fillColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5)
//                }
                
//                renderer.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.3)
                renderer.strokeColor = .red
                renderer.lineWidth = 1.5
                
                //MARK: -Custom title and subtitle to store detail information
                renderer.polygon.title = overlayer.shared.polygonInfo.name4
                renderer.polygon.subtitle = "\(overlayer.shared.polygonInfo.country)-\(overlayer.shared.polygonInfo.name1)-\(overlayer.shared.polygonInfo.name2)-\(overlayer.shared.polygonInfo.name3)-\(overlayer.shared.polygonInfo.name4)"
                return renderer
            }
            //        else if let multiPolygon = overlay as? MKMultiPolygon { ... }
            //        else if let tileOverlay = overlay as? MKTileOverlay { ... }
            
            if let tileOverlay = overlay as? MKTileOverlay {
                return MKTileOverlayRenderer(tileOverlay: tileOverlay)
            } else {
                return MKOverlayRenderer(overlay: overlay)
            }
        }
        
    }
    
    
}
