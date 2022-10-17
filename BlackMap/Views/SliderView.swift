//
//  SliderView.swift
//  BlackMap
//
//  Created by Bronson van den Broeck on 2022/10/15.
//

import SwiftUI

struct SliderView: View {
    @State var sliderValue: Double = 0
    
    var body: some View {
        ZStack{
            VStack{
                Text("Schedule Time")
                    .font(.title)
                    .padding(.bottom, 1)
                Slider(value: $sliderValue, in: 0...12, step: 1.0)
                HStack{
                    Text("Current")
                    Spacer()
                    Text(
                    String(format: "+%.2f", sliderValue)
                    )   
                }
            }.padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(20)
                .padding(.horizontal, 30)
                .padding(.top, 20)
        }
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView()
    }
}
