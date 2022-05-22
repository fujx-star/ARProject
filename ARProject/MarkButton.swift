//
//  MarkButton.swift
//  ARProject
//
//  Created by fjx on 2022/5/22.
//

import SwiftUI

struct MarkButton: View {
    
    @Binding var placementEnabled: Bool
    @Binding var selectedModel: String?
    @Binding var currentModel: String?
    
    var body: some View {
        HStack {
            
//            无论点击了哪个按钮，下一次的渲染中应该显示模型选择框，因此placementEnabled都置为false
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
