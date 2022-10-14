//
//  GeoJSONHelper.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/14.
//

import Foundation
import MapKit

class GeoJSONHelper: ObservableObject {
    
    @Published var overlays = [MKOverlay]()
    
    func loadGeoJson() {
        guard let url = Bundle.main.url(forResource: "SampleGeoJSON", withExtension: "geojson") else {
            fatalError("unable to get geojson")
        }
        
        var geoJson = [MKGeoJSONObject]()
        
        
        do {
            let data = try Data(contentsOf: url)
            geoJson = try MKGeoJSONDecoder().decode(data)
        } catch {
            fatalError("Unable to decode JSON")
        }
        
        for item in geoJson {
            if let feature = item as? MKGeoJSONFeature {
                let geometry = feature.geometry.first
                let propData = feature.properties!
                
                if let polygon = geometry as? MKPolygon {
                    let polygonInfo = try? JSONDecoder.init().decode(PolygonInfo.self, from: propData)
                    //call render function to render our polygon shape
                    render(overlay: polygon, info: polygonInfo)
                }
                
                for geo in feature.geometry {
                    if let polygon = geo as? MKPolygon {
                        overlays.append(polygon)
                    }
                }
            }
        }
    }
    
    func render(overlay: MKOverlay, info: Any?) {
        if let polygonInfo = info as? PolygonInfo {
            overlayer.shared.changePolygon(newPolygon: polygonInfo)
        }
        let newMapOverlay = MapOverlayer(overlay: overlay, polygonInfo: overlayer.shared.polygonInfo)
        MapOverlays.shared.addOverlay(mapOverlayer: newMapOverlay)
        // self.mapView.addOverlay(overlay)
        // self.mapView.setVisibleMapRect(overlay.boundingMapRect, animated: true)
    }
    
}
struct PolygonInfo: Codable {
    var id, kode, jumlah: Int
    let latitude, longitude: Double
    let propinsi: String
    let sumber: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case kode = "kode"
        case propinsi = "Propinsi"
        case sumber = "SUMBER"
        case jumlah = "Jumlah"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}

struct MapOverlayer {
    var overlay : MKOverlay
    var polygonInfo : PolygonInfo
}

//Storing our Overlay Shape
class MapOverlays {
    private var overlayList = [MapOverlayer]()
    static var shared = MapOverlays()
    
    func addOverlay(mapOverlayer: MapOverlayer) {
        MapOverlays.shared.overlayList.append(mapOverlayer)
    }
    
    func returnOverlayList() -> [MapOverlayer] {
        return MapOverlays.shared.overlayList
    }
}

//Track the latest Shape Overlay
class overlayer {
    static var shared = overlayer(polygonInfo: PolygonInfo(id: 1, kode: 2, jumlah: 0, latitude: 0, longitude: 0, propinsi: "1", sumber: "2"))
    var polygonInfo : PolygonInfo
    
    init(polygonInfo: PolygonInfo){
        self.polygonInfo = polygonInfo
    }
    
    func changePolygon(newPolygon: PolygonInfo){
        self.polygonInfo = newPolygon
    }
}
