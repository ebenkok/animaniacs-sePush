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
    
    var tempOverlay = [MKOverlay]()
    
    func loadGeoJson() {
        guard let url = Bundle.main.url(forResource: "gadm41_ZAF_4", withExtension: "json") else {
            fatalError("unable to get geojson")
        }
        
        var geoJson = [MKGeoJSONObject]()
        
        
        do {
            let data = try Data(contentsOf: url)
            geoJson = try MKGeoJSONDecoder().decode(data)
        } catch {
            fatalError("Unable to decode JSON")
        }
        
        var i = 0
        for item in geoJson {
            i += 1
            if let feature = item as? MKGeoJSONFeature {
                let geometry = feature.geometry.first
                let propData = feature.properties!
                
                if let polygon = geometry as? MKPolygon {
                    let polygonInfo = try? JSONDecoder.init().decode(PolygonInfo.self, from: propData)
                    //call render function to render our polygon shape
                    render(overlay: polygon, info: polygonInfo)
                }
                
                if let polygon = geometry as? MKMultiPolygon {
                    for poly in polygon.polygons {
                        let polygonInfo = try? JSONDecoder.init().decode(PolygonInfo.self, from: propData)
                        //call render function to render our polygon shape
                        render(overlay: poly, info: polygonInfo)
                    }
                }
                
                
                
                for multipolygon in feature.geometry {
                    if let multi = multipolygon as? MKMultiPolygon {
                        for polygon in multi.polygons {
                            if let polygon = polygon as? MKPolygon {
                                tempOverlay.append(polygon)
                            }
                        }
                    }
                }
            }
    //        if i == 800 {
                DispatchQueue.main.async {
                    self.overlays = self.tempOverlay
                }
                //break
      //      }
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
//    var id, kode, jumlah: Int
//    let latitude, longitude: Double
//    let propinsi: String
//    let sumber: String
    let country: String
    let name1: String
    let name2: String
    let name3: String
    let name4: String

    enum CodingKeys: String, CodingKey {
        //case id = "ID"
//        case kode = "kode"
        case country = "COUNTRY"
        case name1 = "NAME_1"
        case name2 = "NAME_2"
        case name3 = "NAME_3"
        case name4 = "NAME_4"
//        case propinsi = "Propinsi"
//        case sumber = "SUMBER"
//        case jumlah = "Jumlah"
//        case latitude = "latitude"
//        case longitude = "longitude"
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
    static var shared = overlayer(polygonInfo: PolygonInfo(country: "SA", name1: "asda", name2: "1212", name3: "2323", name4: "3232"))
    var polygonInfo : PolygonInfo
    
    init(polygonInfo: PolygonInfo){
        self.polygonInfo = polygonInfo
    }
    
    func changePolygon(newPolygon: PolygonInfo){
        self.polygonInfo = newPolygon
    }
}
