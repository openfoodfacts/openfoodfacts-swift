//
//  SwiftUIView.swift
//  
//
//  Created by Henadzi Rabkin on 02/10/2023.
//

import SwiftUI

struct RoundedBackgroundCard: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(10).background(Color(UIColor.secondarySystemBackground)).cornerRadius(10)
    }
}
