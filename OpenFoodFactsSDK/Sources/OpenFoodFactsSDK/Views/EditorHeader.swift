//
//  EditorHeader.swift
//
//
//  Created by Henadzi Rabkin on 09/10/2023.
//

import Foundation
import SwiftUI

struct EditorHeader: View {
    
    var title: String
    var systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
            Text(title).font(.title3)
        }
    }
}
