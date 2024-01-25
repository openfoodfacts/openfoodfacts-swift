//
//  SwiftUIView.swift
//  
//
//  Created by Henadzi Rabkin on 01/10/2023.
//

import SwiftUI

struct ExpandableText: View {
    
    @State private var expanded: Bool = false
    @State private var textHeight: CGFloat = .zero
    
    var text: String = ""
    
    private var lineHeight: CGFloat {
        return UIFont.preferredFont(forTextStyle: .caption1).lineHeight
    }
    
    private var shouldShowButton: Bool {
        return textHeight > lineHeight * 2
    }
    
    var body: some View {
        HStack(alignment: .top, content: {
            
            if expanded {
                Text(text)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption)
                    .background(GeometryReader {
                        geometry in
                        Color.clear.onAppear {
                            self.textHeight = geometry.size.height
                        }
                    })
            } else {
                Text(text)
                    .font(.caption)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(GeometryReader {
                        geometry in
                        Color.clear.onAppear {
                            self.textHeight = geometry.size.height
                        }
                    })
            }
            Spacer()
            if shouldShowButton {
                Button(action: {
                    withAnimation {
                        expanded.toggle()
                    }
                }) {
                    Image(systemName: expanded ? "chevron.up.circle" : "info.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.padding(.top, 5)
            }
        })
   }
}

#Preview {
    ExpandableText(text: "This is the content that is either hidden or shown. You can place any text or components here. This is the content that is either hidden or shown. You can place any text or components here.")
}
