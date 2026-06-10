//
//  NavigationBarSearchKey.swift
//  Aesthetics
//
//  Created by Aarav Gupta on 10/06/26.
//

import SwiftUI

struct NavigationBarSearchTextKey: EnvironmentKey {
    static let defaultValue: Binding<String>? = nil
}

struct NavigationBarSearchPromptKey: EnvironmentKey {
    static let defaultValue: String = "Search..."
}

struct NavigationBarSearchSubmitKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var navigationBarSearchText: Binding<String>? {
        get { self[NavigationBarSearchTextKey.self] }
        set { self[NavigationBarSearchTextKey.self] = newValue }
    }
    
    var navigationBarSearchPrompt: String {
        get { self[NavigationBarSearchPromptKey.self] }
        set { self[NavigationBarSearchPromptKey.self] = newValue }
    }
    
    var navigationBarSearchSubmit: (() -> Void)? {
        get { self[NavigationBarSearchSubmitKey.self] }
        set { self[NavigationBarSearchSubmitKey.self] = newValue }
    }
}
