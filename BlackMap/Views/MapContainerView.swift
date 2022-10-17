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
    var scheduleVM: ScheduleViewModel
    
    @State var status = 0
    //bronson
    @State private var showModel = false
    
    // @StateObject var selectedWard = MapArea()
    @State var schedule =  LoadsheddingSlot(avatar: "", level: "", area: "", times: [])
    
    init(vm: ScheduleViewModel) {
        scheduleVM = vm
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
    }
    
    
    var body: some View {
        NavigationView {
            //CHANGED ZSTACK TO AN VSTACK FOR THE SLIDE ANIMATION
            
            ZStack {
               
                MapView(landmarks: $landmarks, selectedLandmark: $selectedLandmark, polygons: $jsonProvider.overlays)
                    .edgesIgnoringSafeArea(.bottom)
                ModalView(slot: schedule, isShowing: $showModel)
            }.safeAreaInset(edge: .top, content: {
                HStack (alignment: .center){
                    Text("Loadshedding: Stage \(status)")
                        .font(.subheadline)
                        .foregroundColor(status > 0 ? .red : .black)
                        
                    Spacer()
                    Menu {
                        Button(action:{
                            if !overlaySettings.overlaysVisible {
                                overlaySettings.overlaysVisible.toggle()
                            }
                            DispatchQueue.global().async {
                                if overlaySettings.overlaysVisible {
                                    jsonProvider.loadGeoJson(province: .Gauteng)
                                }
                            }
                        }, label: {
                            Label("Gauteng", systemImage: "building.2.crop.circle.fill")
                        })
                        Button(action:{
                            if !overlaySettings.overlaysVisible {
                                overlaySettings.overlaysVisible.toggle()
                            }
                            DispatchQueue.global().async {
                                if overlaySettings.overlaysVisible {
                                    jsonProvider.loadGeoJson(province: .WesternCape)
                                }
                            }
                        }, label: {
                            Label("Western Cape", systemImage: "water.waves")
                        })
                        
                        Button(action:{
                            overlaySettings.overlaysVisible.toggle()
                        }, label: {
                            Label("None", systemImage: "xmark.circle")
                        })
                        
                    } label: {
                        Image(systemName: "square.3.layers.3d").resizable().frame(width: 20, height: 20)
                        
                    }
                }.padding(.horizontal)
            })
            .onAppear {
                Task {
                    let stageDetail = await scheduleVM.getStatus()
                    status = stageDetail
                }
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
            })
        }
        .environmentObject(overlaySettings)
        .navigationTitle("Stage \(status)").font(.title).background(.ultraThinMaterial)
        .toolbar {
            ToolbarItem(placement:
                    .navigationBarTrailing) {
                        Menu {
                            
                            Button(action:{
                                if !overlaySettings.overlaysVisible {
                                    overlaySettings.overlaysVisible.toggle()
                                }
                                DispatchQueue.global().async {
                                    if overlaySettings.overlaysVisible {
                                        jsonProvider.loadGeoJson(province: .Gauteng)
                                    }
                                }
                            }, label: {
                                Label("Gauteng", systemImage: "building.2.crop.circle.fill")
                            })
                            Button(action:{
                                if !overlaySettings.overlaysVisible {
                                    overlaySettings.overlaysVisible.toggle()
                                }
                                DispatchQueue.global().async {
                                    if overlaySettings.overlaysVisible {
                                        jsonProvider.loadGeoJson(province: .WesternCape)
                                    }
                                }
                            }, label: {
                                
                                
                                Label("Western Cape", systemImage: "water.waves")
                            })
                            
                            Button(action:{
                                overlaySettings.overlaysVisible.toggle()
                            }, label: {
                                Label("None", systemImage: "xmark.circle")
                            })
                            
                        }label: {
                            Label("Layers", systemImage: "square.3.layers.3d")
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
        MapContainerView(vm: ScheduleViewModel(apiClient: Dependencies.shared.eskomSeAPIClient) )
    }
}
