//
//  OutageMapView.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/13.
//

import SwiftUI
import MapKit

struct OutageMapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

        var body: some View {
            Map(coordinateRegion: $region)
        }
}

struct OutageMapView_Previews: PreviewProvider {
    static var previews: some View {
        OutageMapView()
    }
}
