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
    
   // var tapCoordinates: Binding<CGPoint>
    //    var polygonID: Binding<String> = ""
    
    @EnvironmentObject var mapData: GeoJSONHelper
    
    let map = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        
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
        
        //map.convert($tapCoordinates, toCoordinateFrom: <#T##UIView?#>)
        //return MapView.Coordinator(self, tapCoordinatesBinding: tapCoordinates, polygonTitle: polygonID)
           
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView

        
        //var polygonTitle: Binding<String>
                var gRecognizer = UITapGestureRecognizer()
                
                //var tapCoordinatesBinding: Binding<CLLocationCoordinate2D>
                var coordinate = CLLocationCoordinate2D()
        
        //init(_ control: MapView, tapCoordinates: Binding<CLLocationCoordinate2D>, polygonTitle: Binding<String>) {
        init(_ control: MapView) {
            self.parent = control
            //self.tapCoordinatesBinding = tapCoordinates
            //self.polygonTitle = polygonTitle
            super.init()
            
            self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
                        self.gRecognizer.delegate = self
            self.parent.map.addGestureRecognizer(gRecognizer)
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
                if overlayer.shared.polygonInfo.name1 == "Gauteng" { //36, 76, 179
                    renderer.fillColor = UIColor(red: 199/255, green: 38/255, blue: 84/255, alpha: 0.5)
                    renderer.strokeColor = UIColor(red: 199/255, green: 38/255, blue: 40/255, alpha: 0.5)
                }
                
                
                if overlayer.shared.polygonInfo.name1 == "WesternCape" { //36, 76, 179
                    renderer.fillColor = UIColor(red: 36/255, green: 76/255, blue: 179/255, alpha: 0.5)
                    renderer.strokeColor = UIColor(red: 38/255, green: 36/255, blue: 179/255, alpha: 0.5)
                }
                
                renderer.lineWidth = 1.5
                
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
        
        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
                   // position on the screen, CGPoint
            let location = gRecognizer.location(in: self.parent.map)
                   // position on the map, CLLocationCoordinate2D
                   coordinate = self.parent.map.convert(location, toCoordinateFrom: self.parent.map)
                   //tapCoordinatesBinding.wrappedValue = coordinate
//
                   for overlay: MKOverlay in self.parent.map.overlays {
                       if let polygon = overlay as? MKPolygon {
                           let renderer = MKPolygonRenderer(polygon: polygon)
                           let mapPoint = MKMapPoint(coordinate)
                           let rendererPoint = renderer.point(for: mapPoint)
                           if renderer.path.contains(rendererPoint) {
                               print("Tap inside polygon")
                               print("Polygon \(polygon.title ?? "no value") has been tapped")
                               print("Polygon \(polygon.subtitle ?? "no value") has been tapped")
//                               polygonTitle.wrappedValue = polygon.title!
                           }
                       }
                   }
               }
        
    }
    
    
}
