//
//  TimesView.swift
//  BlackMap
//
//  Created by Bronson van den Broeck on 2022/10/14.
//

import SwiftUI

struct TimesView: View {
    let time : Times
    
    
    var body: some View {
        HStack(spacing: 20){
            Image(systemName: time.avatar)
                .resizable()
                .aspectRatio( contentMode: .fit)
                .frame(width: 30)
                
            
            VStack(alignment: .leading, spacing: 10){
                Text(time.timeSlot)
                    .bold()
                    .font(.system(size: 20))
                Text(time.warning)
                    .foregroundColor(.red)
                    .font(.system(size: 20))
            }
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



struct TimesView_Previews: PreviewProvider {
    static var previews: some View {
        TimesView(time: Times(timeSlot: "12:00 - 14:00", avatar: "lock.slash", warning: "Power Outages"))
    }
}
