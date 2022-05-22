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

//extension ARView {
//    func enableTapGesture() {
//        let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action:  #selector(handleTap(recognizer: )))
//        self.addGestureRecognizer(tapGestureRecongnizer)
//    }
//    @objc func handleTap(recognizer: UITapGestureRecognizer){let tapLocation = recognizer.location(in: self)
//        let results = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
//        if let firstResult = results.first {
//            let position = simd_make_float3(firstResult.worldTransform.columns.3)
//            placeCube(at:position)
//    }
//}


class ARViewModel: ObservableObject {
    var arView: ARView
    init() {
        arView = ARView()
        arView.addCoaching()
//        arView.set
    }
        
}
