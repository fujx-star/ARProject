//
//  ContentView.swift
//  ARProject
//
//  Created by fjx on 2022/5/20.
//

import SwiftUI
import RealityKit
import ARKit

var appModel: String = "PegasusTrail"
var models : [String] = ["PegasusTrail","AirForce","cup_saucer_set","gramophone","teapot","toy_biplane","toy_car","wateringcan"]

struct ContentView : View {
    
    @State var currentModel: String?
    @StateObject var arViewModel = ARViewModel()
    @State var selectedModel: String?
    @State var placementEnabled: Bool = false
    @State var enableGesture: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ARViewContainer(currentModel: $currentModel, enableGesture: $enableGesture)
            
            VStack {
                
                TapButton(enableGesture: $enableGesture)
                
                if placementEnabled {
                    MarkButton(placementEnabled: $placementEnabled, selectedModel: $selectedModel, currentModel: $currentModel)
                }
                else {
                    ModelPicker(placementEnabled: $placementEnabled, selectedModel: $selectedModel)
                }
                
            }
            
        }.environmentObject(arViewModel)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
