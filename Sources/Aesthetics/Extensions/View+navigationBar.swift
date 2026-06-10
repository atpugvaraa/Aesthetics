//
//  View+navigationBar.swift
//  Aesthetics
//
//  Created by Aarav Gupta on 10/06/26.
//

import SwiftUI

public extension View {
    func navigationBarStyle(_ style: NavigationBarStyle) -> some View {
        self.environment(\.navigationBarStyle, style)
    }
    
    func navigationBarShowsSearchBar(_ shows: Bool) -> some View {
        self.transformEnvironment(\.navigationBarStyle) { style in
            style.showSearchBar = shows
        }
    }
    
    func navigationBarSearch(
        text: Binding<String>,
        prompt: String = "Search...",
        onSubmit: @escaping () -> Void = {}
    ) -> some View {
        self
            .environment(\.navigationBarSearchText, text)
            .environment(\.navigationBarSearchPrompt, prompt)
            .environment(\.navigationBarSearchSubmit, onSubmit)
    }
}
