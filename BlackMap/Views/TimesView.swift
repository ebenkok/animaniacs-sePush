//
//  TimesView.swift
//  BlackMap
//
//  Created by Bronson van den Broeck on 2022/10/14.
//

import SwiftUI

struct TimesView: View {
    var body: some View {
        HStack(spacing: 20){
            Image(systemName: "lock.slash")
                .resizable()
                .aspectRatio( contentMode: .fit)
                .frame(width: 30)
                
            
            VStack(alignment: .leading, spacing: 10){
                Text("12:00 - 14:00")
                    .bold()
                    .font(.system(size: 20))
                Text("Power Outages")
                    .foregroundColor(.red)
            }
            Spacer()
            
            
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct TimesView_Previews: PreviewProvider {
    static var previews: some View {
        TimesView()
    }
}
