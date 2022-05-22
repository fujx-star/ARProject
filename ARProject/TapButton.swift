//
//  TapButton.swift
//  ARProject
//
//  Created by fjx on 2022/5/22.
//

import SwiftUI

struct TapButton : View {
    
    @Binding var enableGesture: Bool
    @EnvironmentObject var arViewModel: ARViewModel
    
    var body : some View {
        if !enableGesture {
            Button(action: {
                enableGesture = true
                arViewModel.enable()
            }, label: {
                Text("启用点击添加")
            }).frame(width: 120, height: 40).font(.headline)
        }
        else {
            Button(action: {
                enableGesture = false
                arViewModel.disable()
            }, label: {
                Text("禁用点击添加")
            }).frame(width: 120, height: 40).font(.headline)
        }
    }
    
}
