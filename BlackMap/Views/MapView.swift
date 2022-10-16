 //
//  MapView.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/14.
//
import SwiftUI
import MapKit
import shared


// MARK: - MapView start
struct MapView: UIViewRepresentable {
    @Binding var landmarks: [Landmark]
    @Binding var selectedLandmark: Landmark?
    @State var manager = CLLocationManager()
    @State var managerDelegate = MapLocationDelegate()
    @Binding var polygons: [MKOverlay]
    @EnvironmentObject var mapData: GeoJSONHelper
    
    let map = MKMapView()
    
    let mapWriter = MappingWriter()
    
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
        for item in polygons {
            uiView.addOverlay(item)
        }
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
    
    final class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView
        
        
        var gRecognizer = UITapGestureRecognizer()
        var coordinate = CLLocationCoordinate2D()
        
        init(_ control: MapView) {
            self.parent = control
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
            
            for overlay: MKOverlay in self.parent.map.overlays {
                if let polygon = overlay as? MKPolygon {
                    if let renderer = parent.map.renderer(for: polygon) as? MKPolygonRenderer {
                        //let renderer = MKPolygonRenderer(polygon: polygon)
                        let mapPoint = MKMapPoint(coordinate)
                        let rendererPoint = renderer.point(for: mapPoint)
                        
                        if renderer.path.contains(rendererPoint) {
                            renderer.invalidatePath()
                            renderer.fillColor = .yellow
                            print("Tap inside polygon")
                            print("Polygon \(polygon.title ?? "no value") has been tapped")
                            print("Polygon \(polygon.subtitle ?? "no value") has been tapped")
                            print("Coordinates: lon:\(coordinate.longitude), lat:\(coordinate.latitude)")
                            if let id = polygon.subtitle {
                                //let polyIndex = self.parent.map.overlays.index{ $0 === polygon }!
                                let ward = Ward(polygonID: id, coordinates: WardCoordinate(longitude: "\(coordinate.longitude)", latitude: "\(coordinate.latitude)"), eskomSePushID: "")
                                Task {
                                    await parent.mapWriter.addWardItem(ward: ward)
                                }
                            }
                            break
                            
                        }
                    }
                }
            }
        }
    }
    
    
}


class MappingWriter {
    
    let api: EskomSeAPIClient = Dependencies.shared.eskomSeAPIClient
    
    var zones: [Ward] = [Ward]()
    
    init() {
//        guard let url = Bundle.main.url(forResource: "WardMapping", withExtension: "json") else {
//            fatalError("unable to get geojson")
//        }
        let filename = "mappedData.json"
        let url = getDocumentsDirectory().appendingPathComponent(filename)
       // let base = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
       // let pathComponent = url.appendingPathComponent(filename)
       // let filePath = pathComponent.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            var wardMapping = [Ward]()
            do {
                let fileURL = "file://\(url.path)"
                let data = try Data(contentsOf:  URL(string: fileURL)!)
                wardMapping = try JSONDecoder().decode([Ward].self, from: data)
                zones = wardMapping
                //Foundation.URL    "/Users/eben@glucode.com/Library/Developer/CoreSimulator/Devices/547B99F1-61A7-45B4-8E3B-432D51858950/data/Containers/Data/Application/766DC9B8-A137-48AA-8107-78E1DD789740/Documents/mappedData.json"    
            } catch {
                fatalError("Unable to decode JSON")
            }
            print(wardMapping)
        }
    }
    
    func fileExists(filename: String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent(filename) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                return fileManager.fileExists(atPath: filePath)
            }
        return false
    }
    
    func addWardItem(ward: Ward) async {
        if !zones.contains { $0.polygonID == ward.polygonID } {
            
            let result = try? await api.getAreasNearby(lat: Double(ward.coordinates.latitude)!, lon: Double(ward.coordinates.longitude)!)
            
            if let result = result, let resultData = result.data, let firstArea = resultData.areas.first {
                
                print("Id: \(firstArea.id)")
                //let parsed = try JSONDecoder().decode(SharedNetworkResponse<SharedAreasNearbyResponse.self>, from: response)
                let newWard = Ward(polygonID: ward.polygonID, coordinates: ward.coordinates, eskomSePushID: firstArea.id)
                addAndPersist(ward: newWard)
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let p2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return URL(string: p2)!
    }
    
    private func addAndPersist(ward: Ward) {
        zones.append(ward)
        persist()
    }
    
    private func persist() {
        //        guard let url = Bundle.main.url(forResource: "WardMapping", withExtension: "json") else {
        //            fatalError("unable to get geojson")
        //        }
        //        do {
        //            let jsonData = try JSONEncoder().encode(zones)
        //            try jsonData.write(to: url)
        //
        //        } catch {
        //            fatalError("Unable to write to file:\(error)")
        //        }
        
        let filename = "mappedData.json"
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        let base = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

        let fileURL = "file://\(url.path)"
        let theURL = URL(string: fileURL)!
        
//        let pathComponent = url.appendingPathComponent(filename)
//        let filePath = pathComponent.path
//        let fileManager = FileManager.default
        
        //
        //let url = getDocumentsDirectory().appendingPathComponent("mappedData.json")
        do {
            let jsonData = try JSONEncoder().encode(zones)
            try jsonData.write(to: theURL)
            
        } catch {
            fatalError("Unable to write to file:\(error)")
        }
    
        
    }
    
    
    private func contains(polygonID: String) -> Bool {
        let zones = zones.filter { $0.polygonID == polygonID }
        return zones.count > 0
    }
    
}

struct Ward: Codable {
    let polygonID: String
    let coordinates: WardCoordinate
    var eskomSePushID: String
    
    mutating func update(eskomID: String) {
        self.eskomSePushID = eskomID
    }
}

struct WardCoordinate: Codable {
    let longitude: String
    let latitude: String
}
