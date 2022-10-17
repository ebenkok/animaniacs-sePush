//
//  OutageMapView.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/13.
//

import SwiftUI
import MapKit
import shared

struct MapContainerView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State var landmarks: [Landmark] = [
        Landmark(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
        Landmark(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997))
    ]
    
    @ObservedObject var jsonProvider = GeoJSONHelper()
    
    @State var selectedLandmark: Landmark? = nil
    @StateObject var overlaySettings = MapLayerSettings()
    let scheduleVM: ScheduleViewModel
    
    @State var status = "Stage 2"
    //bronson
    @State private var showModel = false
    
   // @StateObject var selectedWard = MapArea()
    @State var schedule =  LoadsheddingSlot(avatar: "", level: "", area: "", times: [])
    
    init(vm: ScheduleViewModel) {
        scheduleVM = vm
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        
        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
//        UINavigationBar.appearance().backgroundColor = .white

    }
    
    
    var body: some View {
        NavigationView{
            //CHANGED ZSTACK TO AN VSTACK FOR THE SLIDE ANIMATION
            ZStack {
                MapView(landmarks: $landmarks, selectedLandmark: $selectedLandmark, polygons: $jsonProvider.overlays)
                    .edgesIgnoringSafeArea(.vertical)
                VStack {
                    Button(action:{
                        overlaySettings.overlaysVisible.toggle()
                        DispatchQueue.global().async {
                            if overlaySettings.overlaysVisible {
                                jsonProvider.loadGeoJson()
                            }
                        }
                    }) {
                        Image(systemName: overlaySettings.overlaysVisible ? "map.fill" : "map")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .offset(y: -400)
                }.padding(.top, 200)
                ModalView(slot: schedule, isShowing: $showModel)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("MapArea")), perform: { notification in
                
                if let ward = notification.userInfo?["publishWard"] as? Ward {
                    print(ward)
                    Task {
                        let result = await scheduleVM.getSchedule(areaID: ward.eskomSePushID)
                        schedule = result
                    }
                    
                    showModel = true
                }
            }
            )
            ModalView(slot: schedule, isShowing: $showModel)
        
            
        }
        .environmentObject(overlaySettings)
        .navigationTitle(status).font(.title).background(.ultraThinMaterial)
        .toolbar {
            ToolbarItem(placement:
                    .navigationBarTrailing) {
                        Menu {
                            
                            Button(action:{
                                overlaySettings.overlaysVisible.toggle()
                                DispatchQueue.global().async {
                                    if overlaySettings.overlaysVisible {
                                        jsonProvider.loadGeoJson()
                                    }
                                }
                            }) {
                                Image(systemName: overlaySettings.overlaysVisible ? "map.fill" : "map")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            Button(action:{}, label: {
                                Text("Johannesburg")
                            })
                            Button(action:{}, label: {
                                Text("Cape Town")
                            })
                            
                        }label: {
                            Label(title: {Text("add")}, icon: {Text("Province")})
                        }
                    }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func selectNextLandmark() {
        if let selectedLandmark = selectedLandmark, let currentIndex = landmarks.firstIndex(where: { $0 == selectedLandmark }), currentIndex + 1 < landmarks.endIndex {
            self.selectedLandmark = landmarks[currentIndex + 1]
        } else {
            selectedLandmark = landmarks.first
        }
    }
}

struct OutageMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapContainerView(vm: ScheduleViewModel(apiClient: Dependencies.shared.eskomSeAPIClient, stage: 2) )
    }
}
