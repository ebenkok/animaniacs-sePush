//
//  StatusViewModel.swift
//  BlackMap
//
//  Created by Eben Kok on 2022/10/13.
//

import Foundation
import shared

struct StatusViewModel {
    let apiClient: EskomSeAPIClient
    
    func getStatus () async {
        let result = try? await apiClient.getStatus()
        
        if let response = result?.data {
            print(response)
           
        }
    }
    
}
