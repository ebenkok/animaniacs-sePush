//
//  ModelView.swift
//  BlackMap
//
//  Created by Bronson van den Broeck on 2022/10/14.
//

import SwiftUI
import shared

struct ModalView: View {
    
    var slot: LoadsheddingSlot
    @Binding var isShowing: Bool
    @State private var isDragging = false
    
    @State private var curHeight: CGFloat = 400
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 700
    
    let startOpacity: Double = 0.4
    let endOpacity: Double = 0.8
    
    var dragPercentage: Double {
        let res = Double((curHeight - minHeight) / (maxHeight - minHeight))
        return max(0, min(1, res))
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            if isShowing {
                Color.black
                    .opacity(startOpacity + (endOpacity - startOpacity) * dragPercentage)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                mainView
                    .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut)
    }
    
    var mainView: some View {
        
        
        VStack {
            //handle
            ZStack{
                Capsule()
                    .frame(width: 40, height: 6)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.000001))
            .gesture(dragGesture)
            VStack(alignment: .center){
                Text(slot.area)
                    .font(.title)
                    .autocapitalization(UITextAutocapitalizationType.words)
                
                Button(action:{}) {
                    Text("Power on")
                        .foregroundColor(.white)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 110)
                        .background(Color.green.opacity(30))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                ScrollView {
                    VStack {
                        StagesView(slot: slot)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom, 35)
            
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background(
            //rounded corners hack
            ZStack{
                RoundedRectangle(cornerRadius: 30)
                Rectangle()
                    .frame(height: curHeight / 2)
            }
                .foregroundColor(.white)
        )
        .animation(isDragging ? nil : .easeInOut(duration: 0.45))
        .onDisappear{ curHeight = minHeight }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged {val in
                if !isDragging {
                    isDragging = true
                }
                let dragAmount = val.translation.height - prevDragTranslation.height
                if curHeight > maxHeight || curHeight < minHeight {
                    curHeight -= dragAmount / 6
                } else {
                    curHeight -= dragAmount
                }
                prevDragTranslation = val.translation
            }
            .onEnded {val in
                prevDragTranslation = .zero
                isDragging = false
                if curHeight > maxHeight {
                    curHeight = maxHeight
                } else if curHeight < minHeight {
                    curHeight = minHeight
                }
            }
    }
    
}

struct ModelView_Previews: PreviewProvider {
    static var previews: some View {
        MapContainerView(vm: ScheduleViewModel(apiClient: Dependencies.shared.eskomSeAPIClient))
    }
}
