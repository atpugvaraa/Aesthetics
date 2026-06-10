//
//  NavigationBar.swift
//  cisum
//
//  Created by Aarav Gupta (github.com/atpugvaraa) on 18/03/25.
//

import SwiftUI

struct NavBarHeightPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct NavigationBar<Header: View, Drawer: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.navigationBarStyle) private var config
    @Environment(\.navigationBarSearchText) private var searchText
    @Environment(\.navigationBarSearchPrompt) private var searchPrompt
    @Environment(\.navigationBarSearchSubmit) private var searchSubmit

    let metrics = NavigationBarMetrics.current
    
    var scrollOffset: CGFloat
    var title: String
    var titleColor: Color
    var icon: String?
    @State var showTopRightButton: Bool
    var backAction: (() -> Void)?
    var usesCustomHeader: Bool
    var header: Header
    var drawer: Drawer

    init(
        scrollOffset: CGFloat,
        title: String,
        titleColor: Color,
        icon: String? = nil,
        showTopRightButton: Bool,
        backAction: (() -> Void)? = nil,
        @ViewBuilder drawer: () -> Drawer = { EmptyView() }
    ) where Header == EmptyView {
        self.scrollOffset = scrollOffset
        self.title = title
        self.titleColor = titleColor
        self.icon = icon
        self._showTopRightButton = State(initialValue: showTopRightButton)
        self.backAction = backAction
        self.usesCustomHeader = false
        self.header = EmptyView()
        self.drawer = drawer()
    }

    init(
        scrollOffset: CGFloat,
        title: String,
        titleColor: Color,
        icon: String? = nil,
        showTopRightButton: Bool,
        backAction: (() -> Void)? = nil,
        usesCustomHeader: Bool,
        @ViewBuilder header: () -> Header,
        @ViewBuilder drawer: () -> Drawer = { EmptyView() }
    ) {
        self.scrollOffset = scrollOffset
        self.title = title
        self.titleColor = titleColor
        self.icon = icon
        self._showTopRightButton = State(initialValue: showTopRightButton)
        self.backAction = backAction
        self.usesCustomHeader = usesCustomHeader
        self.header = header()
        self.drawer = drawer()
    }

    var body: some View {
        ZStack {
            Color.clear
                .frame(height: backAction != nil
                       ? metrics.barHeightCollapsed
                       : interpolation(start: metrics.barHeightExpanded, end: metrics.barHeightCollapsed))
                .edgesIgnoringSafeArea(.top)
            
            navigationBar
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    var navigationBar: some View {
        VStack(spacing: 8) {
            if usesCustomHeader {
                header
            } else {
                navigationTitle
            }
            
            if config.showSearchBar, backAction == nil, let searchText {
                SearchBar(text: searchText, prompt: searchPrompt) {
                    searchSubmit?()
                }
            }
            
            // Custom drawer — only on root views
            if backAction == nil {
                drawer
            }
        }
        .background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: NavBarHeightPreferenceKey.self, value: proxy.size.height)
            }
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.3), value: scrollOffset)
        .offset(y: backAction != nil
                ? metrics.barOffsetCollapsed
                : interpolation(start: metrics.barOffsetExpanded, end: metrics.barOffsetCollapsed))
    }

    var navigationTitle: some View {
        HStack {
            if let backAction {
                Button {
                    backAction()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(titleColor)
                }
                .padding(.trailing, 4)
            }
            
            Text(title)
                .font(
                    .system(
                        size: backAction != nil
                              ? metrics.titleSizeCollapsed
                              : interpolation(start: metrics.titleSizeExpanded, end: metrics.titleSizeCollapsed)
                    )
                )
                .fontWeight(.bold)
                .foregroundStyle(titleColor)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal)
    }

//    func topRightButton() -> some View {
//        ProfileButton(profileImageURL: profileImageURL, customActions: customActions, onAction: handleProfileAction)
//            .scaleEffect(interpolation(start: 0.9, end: 0.857, transitionOffset: 60))
//    }

//    private func handleProfileAction(_ action: ProfileMenuAction) {
//        switch action {
//        case .profile:
//            router.navigate(to: .profile)
//        case .settings:
//            router.navigate(to: .settings)
//        case .plugins:
//            router.navigate(to: .plugins)
//        }
//    }

    private func interpolation(start: CGFloat, end: CGFloat) -> CGFloat {
        let progress = min(max(scrollOffset / metrics.transitionOffset, 0), 1)
        return end + (start - end) * progress
    }
}
