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
    
    //bronson
    @State private var showModel = false
    
    
    var body: some View {
        NavigationView{
            //CHANGED ZSTACK TO AN VSTACK FOR THE SLIDE ANIMATION
            ZStack {
                MapView(landmarks: $landmarks, selectedLandmark: $selectedLandmark, polygons: $jsonProvider.overlays)
                
                    .edgesIgnoringSafeArea(.vertical)
                
                
                //bronson
                
                //            SliderView()
                
                //SliderView()
                
                
                HStack {
                    Button(action:{ showModel = true}) {
                        Text("click me")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 40)
                            .background(Color.black.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .offset(y: -300)
                    
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
                    .offset(y: -300)
                    
                    Button(action:{
                        DispatchQueue.global().async {
                            Task {
                                // BRONSON put your looked up value in here
                                //    let result = await scheduleVM.getSchedule(areaID: "eskde-10-fourwaysext10cityofjohannesburggauteng")
                            }
                        }
                    }) {
                        Text("Get Eskom Data")
                    }
                    .offset(y: -300)
                    
                }.padding(.top, 200)
                ModelView(isShowing: $showModel)
                
                //            VStack {
                //                Spacer()
                //                Button("Next")  {
                //                    self.selectNextLandmark()
                //                }
                //            }
            }.onAppear {
                //            DispatchQueue.global().async {
                //                Task {
                //                    scheduleVM.getStatus()
                //                }
                //
                //            }
            }
        }  
        .environmentObject(overlaySettings)
        .navigationTitle("Stage 2")
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
        MapContainerView(scheduleVM: ScheduleViewModel(apiClient: Dependencies.shared.eskomSeAPIClient))
    }
}
