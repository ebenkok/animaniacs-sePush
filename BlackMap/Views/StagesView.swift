//
//  StagesView.swift
//  BlackMap
//
//  Created by Bronson van den Broeck on 2022/10/14.
//

import SwiftUI

struct StagesView: View {
    var slot : LoadsheddingSlot
    var body: some View {
        VStack {
            HStack(spacing: 20){
                Image(systemName: slot.avatar)
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .frame(width: 30)
                    
                
                VStack(alignment: .leading, spacing: 10){
                    Text( slot.level)
                        .bold()
                        .font(.system(size: 20))
                    Text(slot.area)
                }
                Spacer()
                
                
            }
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.015))
            .cornerRadius(20)
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            ForEach(slot.times, id: \.timeSlot) { item in
                TimesView(time: item)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.015))
                    .cornerRadius(20)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
            }
        }
    }
}

struct LoadsheddingSlot {
    let avatar : String
    let level : String
    let area : String
    let times : [Times]
}

struct Times {
    let timeSlot : String
    let avatar : String
    let warning : String
}

class ObservedLoadsheddingSlot: ObservableObject {
    @Published var slot =  LoadsheddingSlot(avatar: "", level: "", area: "", times: [])
}

struct StagesView_Previews: PreviewProvider {
    static var previews: some View {
        StagesView(slot: LoadsheddingSlot(avatar: "house", level: "Stage 3", area: "Mayersdal", times: [Times(timeSlot: "11:00-12:00", avatar: "lock.slash", warning: "power outages")]))
    }
}


