import Foundation
import SwiftUI

public struct EditProductPage: View {
    
    @StateObject private var cache = OrderedNutrientsCache()
    
    var barcode: String = ""
    @State private var productName = ""
    @State private var brand = ""
    @State private var categories: [String] = []
    @State private var weight = ""
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10, content: {
                ProductCode(barcodeString: self.barcode).scaleEffect(1.8, anchor: .top)
                Spacer().frame(height: 60)
                
                VStack(alignment: .leading, spacing: 10, content: {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Basic details").font(.title3)
                    }
                    TextField("Product name", text: $productName)
                    TextField("Brand name", text: $brand)
                    TextField("Product weight with units - 100g", text: $weight)
                }).modifier(RoundedBackgroundCard())
                
                Spacer().frame(height: 10)
                
                VStack(alignment: .leading, spacing: 10, content: {
                    HStack {
                        Image(systemName: "fork.knife")
                        Text("Categories").font(.title3)
                    }
                    ExpandableText(text: "Indicate only the most specific category. Parent categories will be automatically added." + "\n\n" + "Examples: Sardines in olive oil, Orange juice from concentrate")
                    CategoryInputWidget(categories: $categories)
                }).modifier(RoundedBackgroundCard())
                
                Spacer().frame(height: 10)
                
                VStack(alignment: .leading, spacing: 10, content: {
                    HStack {
                        Image(systemName: "leaf")
                        Text("Nutrition facts").font(.title3)
                    }
                    List {
                        if let nutrientsData = cache.orderedNutrients {
                            ForEach(nutrientsData.nutrients.filter { $0.important }, id: \.id) { nutrient in
                                HStack {
                                    Text(nutrient.nname())
                                    Text(nutrient.nunit())
                                }
                            }
                        }
                    }
                }).modifier(RoundedBackgroundCard())
                
                Spacer()
            })
            .padding(20)
        }
        .onAppear() {
            Task {
                await cache.getCache()
            }
        }
    }
}

#Preview {
    EditProductPage(barcode: "5701377101134")
}
