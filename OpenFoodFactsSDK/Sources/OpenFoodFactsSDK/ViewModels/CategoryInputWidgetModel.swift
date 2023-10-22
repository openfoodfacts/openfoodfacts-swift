//
//  CategoryInputWidgetModel.swift
//
//
//  Created by Henadzi Rabkin on 10/10/2023.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class CategoryInputWidgetModel: ObservableObject {
    
    @Published var suggestions = [String]()
    @Published var apiError: Error?
    @Published var newCategory: String = ""
    @Published var editing: Bool = false
    @Published var showSuggestions: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        $newCategory
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] newText in
                guard let strongSelf = self else { return }
                Task {
                    await strongSelf.fetchSuggestions(query: newText)
                }
            }
            .store(in: &cancellables)
    }
    
    // TODO: take into account language and country code
    func fetchSuggestions(query: String) async {
        do {
            suggestions = try await OpenFoodAPIClient.shared.getSuggestions(query: query, country: OFFConfig.shared.country, language: OFFConfig.shared.uiLanguage)
            print(suggestions)
        } catch {
            self.apiError = error
        }
    }
}
