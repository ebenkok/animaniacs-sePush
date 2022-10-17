//
//  ContentView.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/13.
//

import SwiftUI
import shared

struct ContentView: View {
    
    
    
    
    let statusVM: StatusViewModel
    @State private var isAnimating: Bool = false
    @State private var isShowingDetailView = false
    @StateObject var overlaySettings = MapLayerSettings()
    @ObservedObject var jsonProvider = GeoJSONHelper()
    @State var status = "Stage 2"
    
    var body: some View {
        
        TabView{
            MapContainerView(vm: ScheduleViewModel.init(apiClient: Dependencies.shared.eskomSeAPIClient))
                .tabItem{
                    Image(systemName: "map")
                    Text("Map")
                }
                    
                    
                    ScrollView{
                        Text("The Animatics")
                            .font(.title)
                            .padding(.top, 10)
                        Image("ppnj")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Text("Create by Eben Kok & Bronson Van Den Broeck")
                            .font(.caption)
                            .padding()
                        Text("Eskom Se Push Challenge")
                            .padding(.bottom, 10)
                            .font(.title)
                        
                        Text("BlackMap is an app to map the wards in the country to an EskomSePushID. BlackMap loads wards in the country from an included geoJSON file. Zones are overlayed onto the map and are interactive. Tapping on a zone highlights the zone, retrieves the EskomSePushID for the GPS Coordinates and retrievs the closest EskomSePushID via the API.Each Ward or polygon has a unique ID in the geoJson dataset. Once the EskomSePushID has been retrieved a mapping is created between the EskomSePushID and the Polygon ID. This will allow for users to obtain the schedule for a Ward.The geoJSON dataset is retrieved from https://gadm.org")
                            .font(.caption)
                            .padding()
                        
                        
                    }
                    .tabItem{
                        Image(systemName: "person")
                        Text("About")
                    }
                    
                    
                    
        }.onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }

        
        //        ZStack {
        //            NavigationView {
        //                ZStack {
        //                    VStack(spacing: 5) {
        //                        NavigationLink(destination: MapContainerView(vm: ScheduleViewModel(apiClient: Dependencies.shared.eskomSeAPIClient, stage: 2)), isActive: $isShowingDetailView) { EmptyView() }
        //
        //                        Button("Show Map") {
        //                            isShowingDetailView = true
        //                        }
        //
        //                        .fontWeight(.medium)
        //
        //                        Button("Get Status") {
        //                            Task {
        //                                await statusVM.getStatus()
        //                            }
        //                        }.foregroundColor(.red)
        //                    }
        //                    Circle()
        //                        .stroke(.white.opacity(0.2), lineWidth: 40)
        //                        .frame(width: 260, height: 260, alignment: .center)
        //                    Circle()
        //                        .stroke(.white.opacity(0.2), lineWidth: 80)
        //                        .frame(width: 260, height: 260, alignment: .center)
        //                }
        //                .blur(radius: isAnimating ? 0 : 10)
        //                .opacity(isAnimating ? 1 : 0)
        //                .scaleEffect(isAnimating ? 1 : 0)
        //                .animation(.easeOut(duration: 1), value: isAnimating)
        //                .onAppear {
        //                    isAnimating = true
        //
        //
        //                }
        //
        //
        //            }
        //            .navigationTitle("Navigation")
        //        }
        //
        //
        //
        //
        //
        //
        //
        //
    }
    
    
    //
    //struct ContentView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        ContentView(statusVM: StatusViewModel(apiClient: Dependencies.shared.eskomSeAPIClient))
    //    }
    //}
}
