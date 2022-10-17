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


class ScheduleViewModel {
    
    let apiClient: EskomSeAPIClient
    var stage: Int = 0
    
    init(apiClient: EskomSeAPIClient) {
        self.apiClient = apiClient
    }
    
    func getStatus () async -> Int {
        let result = try? await apiClient.getStatus()
        
        if let response = result?.data {
            self.stage = Int(response.status.eskom.stage)!
            return stage
        }
        
        return 0
    }
    
    func getSchedule(areaID: String) async -> LoadsheddingSlot {
        let result = try? await apiClient.getAreaInformation(areaId: areaID, testEvent: .current)
        
        if let response = result?.data {
            return makeSlot(areaInfo: response)
        }
        
        return LoadsheddingSlot (avatar: "house", level: "babla", area: "None", times: [Times(timeSlot: "nothing", avatar: "error", warning: "Not found")])
    }
        
    
    private func makeSlot(areaInfo: AreaInformationResponse) -> LoadsheddingSlot {
        var times = [Times]()
        if let currentDay = areaInfo.schedule.days.first {
            
            for time in currentDay.stages[stage-1] {
                let slot = Times(timeSlot: time, avatar: "lock.slash", warning: "Power Outages")
                times.append(slot)
            }
        }
        
        let slot = LoadsheddingSlot (avatar: "house", level: "Stage \(stage)", area: areaInfo.info.name, times: times)
        return slot
    }
    
}
