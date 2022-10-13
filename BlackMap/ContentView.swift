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
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        
        Button("Get Status") {
            Task {
                await statusVM.getStatus()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(statusVM: StatusViewModel(apiClient: Dependencies.shared.eskomSeAPIClient))
    }
}
