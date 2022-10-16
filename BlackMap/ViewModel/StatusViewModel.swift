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


struct ScheduleViewModel {
    let apiClient: EskomSeAPIClient
   
    func getSchedule(areaID: String) async -> String {
        let result = try? await apiClient.getAreaInformation(areaId: areaID, testEvent: .current)
        
        if let response = result?.data {
            
            return "working"
        }
        
        return "not parsed"
    }
}
