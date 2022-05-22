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
    @State var selectedModel: String?
    @State var currentModel: String?
    @State var placementEnabled: Bool = false
    var models: [String] = ["PegasusTrail","wateringcan"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ARViewContainer(currentModel: $currentModel)
            
            if placementEnabled {
                PlacementButtonView(placementEnabled: $placementEnabled, selectedModel: $selectedModel, currentModel: $currentModel)
            }
            else {
                ModelPicker(placementEnabled: $placementEnabled, selectedModel: $selectedModel, models: models)
            }
            
        }.environmentObject(arViewModel)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var arViewModel: ARViewModel
    @Binding var currentModel: String?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = arViewModel.arView
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        config.environmentTexturing = .automatic
        config.isLightEstimationEnabled = true
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
            modelEntity.generateCollisionShapes(recursive: true)
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
            arViewModel.arView.installGestures([.translation,.rotation,.scale],for:modelEntity)
            arViewModel.arView.scene.addAnchor(anchorEntity)
//            每次更新UIView后将当前模型置为空
            DispatchQueue.main.async {
                currentModel = nil
            }
        }
        
    }
    
}

struct ModelPicker : View{
    
    @Binding var placementEnabled: Bool
    @Binding var selectedModel: String?
    var models: [String]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack(spacing: 30) {
//                点击按钮时，将当前已选择的模型存在selectedModel中
                ForEach(0..<self.models.count) {
                    index in
                    Button(action: {
                        placementEnabled = true
                        selectedModel = models[index]
                    }, label: {
                        Image(uiImage: UIImage(named: models[index])!).resizable().frame(height:80).aspectRatio(1/1, contentMode: .fill).background(Color.white)
                    }).buttonStyle(PlainButtonStyle())
                }
            }
        }.padding(20).background(Color.black.opacity(0.5))
    }
    
}

struct PlacementButtonView: View {
    
    @Binding var placementEnabled: Bool
    @Binding var selectedModel: String?
    @Binding var currentModel: String?
    
    var body: some View {
        HStack {
            
//            无论点击了哪个按钮，下一次的渲染中应该显示模型选择框，因此placementEnabled
            Button(action: {
                placementEnabled = false
                selectedModel = nil
            }, label: {
                Image(systemName: "xmark").frame(width: 60, height: 60).font(.title).background(Color.white.opacity(0.75)).cornerRadius(30).padding(20)
            })
            
//            点击了对勾按钮后，将当前模型置为选择的模型
            Button(action: {
                currentModel = selectedModel
                placementEnabled = false
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
