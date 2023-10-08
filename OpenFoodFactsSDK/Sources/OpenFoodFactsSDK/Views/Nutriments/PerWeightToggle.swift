//
//  PerWeightToggle.swift
//
//
//  Created by Henadzi Rabkin on 09/10/2023.
//

import Foundation
import SwiftUI

struct PerWeightToggle: View {
    
    @EnvironmentObject var pageConfig: ProductPageConfig
    
    @Binding var dataFor: DataFor
    @State private var isRight = false
    
    public var body: some View {
        if pageConfig.isViewMode {
            ZStack(alignment: .center) {
                Text(dataFor.label()).underline()
            }.frame(width: .infinity)
        } else {
            HStack(alignment: .center, spacing: 10) {
                Button(action: {
                    isRight = false
                }) {
                    Text(DataFor.hundredG.label()).underline(!isRight)
                }
                Toggle("", isOn: $isRight).toggleStyle(ArrowToggleStyle())
                Button(action: {
                    isRight = true
                }) {
                    Text(DataFor.serving.label()).underline(isRight)
                }
                
            }.onChange(of: isRight) { newValue in
                dataFor = newValue ? .serving : .hundredG
            }.onAppear {
                isRight = (dataFor == .serving)
            }.foregroundColor(.primary)
        }
    }
}

struct ArrowToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            withAnimation {
                configuration.isOn.toggle()
            }
        }) {
            HStack {
                if configuration.isOn {
                    Image(systemName: "arrow.right")
                } else {
                    Image(systemName: "arrow.left")
                }
            }
        }
        .foregroundColor(.blue)
        .font(.system(size: 24, weight: .bold))
        .frame(width: 50, height: 40)
        .cornerRadius(20)
    }
}

#Preview {
    PerWeightToggle(dataFor: .constant(.hundredG))
}
