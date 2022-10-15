//
//  StagesView.swift
//  BlackMap
//
//  Created by Bronson van den Broeck on 2022/10/14.
//

import SwiftUI

struct StagesView: View {
   
    var body: some View {
        HStack(spacing: 20){
            Image(systemName: "house")
                .resizable()
                .aspectRatio( contentMode: .fit)
                .frame(width: 30)
                
            
            VStack(alignment: .leading, spacing: 10){
                Text("Stage 3")
                    .bold()
                    .font(.system(size: 20))
                Text("Mayersdal")
            }
            Spacer()
            
            
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StagesView_Previews: PreviewProvider {
    static var previews: some View {
        StagesView()
    }
}
