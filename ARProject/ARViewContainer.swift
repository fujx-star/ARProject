//
//  ARViewContainer.swift
//  ARProject
//
//  Created by fjx on 2022/5/22.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var arViewModel: ARViewModel
    @Binding var currentModel: String?
    @Binding var enableGesture: Bool
    
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
            arViewModel.arView.installGestures([.translation,.rotation,.scale],for:modelEntity)
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
            arViewModel.arView.scene.addAnchor(anchorEntity)
//            每次更新UIView后将当前模型置为空，根据手势变量启用和禁用点击添加
            DispatchQueue.main.async {
                currentModel = nil
                appModel = fileName
            }
        }
        
    }
    
}
