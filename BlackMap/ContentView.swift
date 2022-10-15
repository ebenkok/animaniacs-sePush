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
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    VStack(spacing: 5) {
                        NavigationLink(destination: MapContainerView(scheduleVM: ScheduleViewModel(apiClient: Dependencies.shared.eskomSeAPIClient)), isActive: $isShowingDetailView) { EmptyView() }
                        
                        Button("Show Map") {
                            isShowingDetailView = true
                        }
                        
                        .fontWeight(.medium)
                        
                        Button("Get Status") {
                            Task {
                                await statusVM.getStatus()
                            }
                        }.foregroundColor(.red)
                    }
                    Circle()
                        .stroke(.white.opacity(0.2), lineWidth: 40)
                        .frame(width: 260, height: 260, alignment: .center)
                    Circle()
                        .stroke(.white.opacity(0.2), lineWidth: 80)
                        .frame(width: 260, height: 260, alignment: .center)
                }
                .blur(radius: isAnimating ? 0 : 10)
                .opacity(isAnimating ? 1 : 0)
                .scaleEffect(isAnimating ? 1 : 0)
                .animation(.easeOut(duration: 1), value: isAnimating)
                .onAppear {
                    isAnimating = true
                    
                    
                }
                
                
            }
            .navigationTitle("Navigation")
        }
        
        
        
        
        
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(statusVM: StatusViewModel(apiClient: Dependencies.shared.eskomSeAPIClient))
    }
}
