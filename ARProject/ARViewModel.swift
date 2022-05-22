//
//  ARViewModel.swift
//  ARProject
//
//  Created by fjx on 2022/5/21.
//

import SwiftUI
import RealityKit
import ARKit

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = true
        coachingOverlay.goal = .anyPlane
        self.addSubview(coachingOverlay)
    }
}

extension ARView {
    
    func initTapGesture() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(handleTap(recognizer: )))
        self.addGestureRecognizer(tapGestureRecognizer)
        return tapGestureRecognizer
    }
    
    func enableTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func disableTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        self.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer)
    {
        let tapLocation = recognizer.location(in: self)
        let results = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
        if let firstResult = results.first {
            let position = simd_make_float3(firstResult.worldTransform.columns.3)
            placeModel(at:position)
        }
    }
    
    func placeModel(at position: SIMD3<Float>) {
        let modelEntity = try!ModelEntity.loadModel(named: appModel)
        modelEntity.generateCollisionShapes(recursive: true)
        self.installGestures([.translation,.rotation,.scale],for:modelEntity)
        let anchorEntity = AnchorEntity(world: position)
        anchorEntity.addChild(modelEntity)
        self.scene.addAnchor(anchorEntity)
    }
}


class ARViewModel: ObservableObject {
    var arView: ARView
    var tapGestureRecognizer: UITapGestureRecognizer
    init() {
        arView = ARView()
        arView.addCoaching()
        tapGestureRecognizer = arView.initTapGesture()
    }
    func enable() {
        arView.enableTapGesture(tapGestureRecognizer: tapGestureRecognizer)
    }
    func disable() {
        arView.disableTapGesture(tapGestureRecognizer: tapGestureRecognizer)
    }
        
}
