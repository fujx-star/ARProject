//
//  ModelPicker.swift
//  ARProject
//
//  Created by fjx on 2022/5/22.
//

import SwiftUI

struct ModelPicker : View{
    
    @Binding var placementEnabled: Bool
    @Binding var selectedModel: String?
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack(spacing: 30) {
//                点击按钮时，将当前已选择的模型存在selectedModel中
                ForEach(0..<models.count) {
                    index in
                    Button(action: {
                        placementEnabled = true
                        selectedModel = models[index]
                    }, label: {
                        Image(uiImage: UIImage(named: models[index])!).resizable().frame(height:100).aspectRatio(1/1, contentMode: .fill).background(Color.white)
                    }).buttonStyle(PlainButtonStyle())
                }
            }
        }.padding(20).background(Color.black.opacity(0.5))
    }
    
}
