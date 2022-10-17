//
//  GeoJSONHelper.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/14.
//

import Foundation
import MapKit

enum Provinces: String {
    case Gauteng = "Gauteng"
    case Limpopo = "Limpopo"
    case WesternCape = "WesternCape"
    case FreeState = "FreeState"
    case EasternCape = "EasternCape"
    case KwazuluNatal = "KwaZuluNatal"
    case NorthWest = "NorthWest"
    case NothernCape = "NorthernCape"
    case Mpumalanga = "Mpumalanga"
}


class GeoJSONHelper: ObservableObject {
    
    
    
    @Published var overlays = [MKOverlay]()
    
    var tempOverlay = [MKOverlay]()
    
    func loadGeoJson(province: Provinces) {
        tempOverlay.removeAll()
        print(MapOverlays.shared.returnOverlayList().count)
        MapOverlays.shared.clearAll()
        guard let url = Bundle.main.url(forResource: province.rawValue, withExtension: "geojson") else {
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
                        if let polygonInfo = try? JSONDecoder.init().decode(PolygonInfo.self, from: propData) {
                            //call render function to render our polygon shape
                            print("---------")
                            print(polygonInfo)
                            poly.title = "\(polygonInfo.country)-\(polygonInfo.name1)-\(polygonInfo.name2)-\(polygonInfo.name3)-\(polygonInfo.name4)"
                            poly.subtitle = "\(polygonInfo.id)"
                            render(overlay: poly, info: polygonInfo)
                        }
                        
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
            DispatchQueue.main.async {
                self.overlays = self.tempOverlay
            }
            
        }
    }
    
    func render(overlay: MKOverlay, info: Any?) {
        if let polygonInfo = info as? PolygonInfo {
            overlayer.shared.changePolygon(newPolygon: polygonInfo)
        }
        
        let newMapOverlay = MapOverlayer(overlay: overlay, polygonInfo: overlayer.shared.polygonInfo)
        MapOverlays.shared.addOverlay(mapOverlayer: newMapOverlay)
        
    }
    
}
struct PolygonInfo: Codable {
    let country: String
    let name1: String
    let name2: String
    let name3: String
    let name4: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case country = "COUNTRY"
        case name1 = "NAME_1"
        case name2 = "NAME_2"
        case name3 = "NAME_3"
        case name4 = "NAME_4"
        case id = "GID_4"
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
    
    func clearAll() {
        MapOverlays.shared.overlayList.removeAll()
    }
    
    func returnOverlayList() -> [MapOverlayer] {
        return MapOverlays.shared.overlayList
    }
}

//Track the latest Shape Overlay
class overlayer {
    static var shared = overlayer(polygonInfo: PolygonInfo(country: "SA", name1: "asda", name2: "1212", name3: "2323", name4: "3232", id: "asdad"))
    var polygonInfo : PolygonInfo
    
    init(polygonInfo: PolygonInfo){
        self.polygonInfo = polygonInfo
    }
    
    func changePolygon(newPolygon: PolygonInfo){
        self.polygonInfo = newPolygon
    }
}
