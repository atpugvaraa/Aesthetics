//
//  NavigationBarStyle.swift
//  cisum
//
//  Created by Aarav Gupta (github.com/atpugvaraa) on 13/05/25.
//

import SwiftUI

public struct NavigationBarStyle: Sendable {
    /// Define the style options
    public enum StyleType: Sendable {
        case standard
        case search
    }

    // Core properties that define your style
    var styleType: StyleType
    var backgroundColor: Color
    var titleColor: Color
    var iconColor: Color
    var showSearchBar: Bool

    /// Predefined styles as static properties
    public static let standard = NavigationBarStyle(
        styleType: .standard,
        backgroundColor: .clear,
        titleColor: .primary,
        iconColor: .primary,
        showSearchBar: false
    )

    public static let search = NavigationBarStyle(
        styleType: .search,
        backgroundColor: .clear,
        titleColor: .primary,
        iconColor: .primary,
        showSearchBar: true
    )
    
    public init(
        styleType: StyleType = .standard,
        backgroundColor: Color = .clear,
        titleColor: Color = .primary,
        iconColor: Color = .primary,
        showSearchBar: Bool = false
    ) {
        self.styleType = styleType
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.iconColor = iconColor
        self.showSearchBar = showSearchBar
    }
}
