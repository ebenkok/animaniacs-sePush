//
//  BlackMapApp.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/13.
//

import SwiftUI
import shared

@main
struct BlackMapApp: App {
    
    init() {
            _ = DI(
                host:"developer.sepush.co.za",
                accessTokenProvider: AccessTokenProviderImplementation() as! AccessTokenProvider ,
                enableHttpLogging: true
            )
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView(statusVM: StatusViewModel(apiClient: Dependencies.shared.eskomSeAPIClient))
        }
    }
}
