//
//  ContentView.swift
//  ARProject
//
//  Created by fjx on 2022/5/20.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    @StateObject var arViewModel = ARViewModel()
    @State var isPlacementEnable: Bool = false
    @State var selectedModel: String?
    @State var currentModel: String?
    var models: [String] = ["PegasusTrail","wateringcan"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(currentModel: $currentModel)
            if isPlacementEnable {
                PlacementButtonView(isPlacementEnabled: $isPlacementEnable, selectedModel: $selectedModel, currentModel: $currentModel)
            }
            else {
                ModelPicker(isPlacementEnabled: $isPlacementEnable, selectedModel: $selectedModel, models: models)
            }
            
        }.environmentObject(arViewModel)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var arViewModel: ARViewModel
    @Binding var currentModel: String?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        arView.session.run(config)
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelName = currentModel {
            let fileName = modelName + ".usdz"
            let modelEntity = try!ModelEntity.loadModel(named: fileName)
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
            arViewModel.arView.scene.addAnchor(anchorEntity)
            DispatchQueue.main.async {
                currentModel = nil
            }
        }
        
    }
    
}

struct ModelPicker : View{
    
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?
    var models: [String]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 30) {
                ForEach(0..<self.models.count) {
                    index in
                    Button(action: {
                        print("DEBUG: click model button\(self.models[index])")
                        isPlacementEnabled = true
                        selectedModel = models[index]
                    }, label: {
                        Image(uiImage: UIImage(named: models[index])!).resizable().frame(height:80).aspectRatio(1/1, contentMode: .fill).background(Color.white).cornerRadius(12)
                    }).buttonStyle(PlainButtonStyle())
                }
            }
        }.padding(20).background(Color.black.opacity(0.5))
    }
    
}

struct PlacementButtonView: View {
    
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?
    @Binding var currentModel: String?
    
    var body: some View {
        HStack {
            Button(action: {
                print("DEBUG: click cancel")
                isPlacementEnabled = false
                selectedModel = nil
            }, label: {
                Image(systemName: "xmark").frame(width: 60, height: 60).font(.title).background(Color.white.opacity(0.75)).cornerRadius(30).padding(20)
            })
            Button(action: {
                print("DEBUG: click confirm")
                currentModel = selectedModel
                isPlacementEnabled = false
                selectedModel = nil
            }, label: {
                Image(systemName: "checkmark").frame(width: 60, height: 60).font(.title).background(Color.white.opacity(0.75)).cornerRadius(30).padding(20)
            })
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
