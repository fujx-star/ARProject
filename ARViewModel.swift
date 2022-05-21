//
//  ARViewModel.swift
//  ARProject
//
//  Created by fjx on 2022/5/21.
//

import SwiftUI
import RealityKit
import ARKit

class ARViewModel: ObservableObject {
    var arView: ARView
    init() {
        arView = ARView()
    }
        
}
