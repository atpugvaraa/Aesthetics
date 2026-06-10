//
//  NavigationBarView.swift
//  cisum
//
//  Created by Aarav Gupta (github.com/atpugvaraa) on 18/03/25.
//

import SwiftUI

public struct NavigationBarView<Header: View, Drawer: View, Content: View>: View {
    @Environment(\.navigationBarStyle) var config

    var title: String
    var titleColor: Color
    var icon: String?
    var showTopRightButton: Bool
    var backAction: (() -> Void)?
    var backgroundColor: Color
    var usesCustomHeader: Bool
    var header: Header
    var drawer: Drawer
    var content: Content
    let metrics = NavigationBarMetrics.current

    @Binding var scrollOffset: CGFloat
    @State private var drawerHeight: CGFloat = 0
    @State private var navBarHeight: CGFloat = 0

    public init(
        title: String,
        titleColor: Color = .primary,
        scrollOffset: Binding<CGFloat>,
        icon: String? = nil,
        showTopRightButton: Bool = false,
        backAction: (() -> Void)? = nil,
        backgroundColor: Color = .clear,
        @ViewBuilder drawer: () -> Drawer = { EmptyView() },
        @ViewBuilder content: () -> Content
    ) where Header == EmptyView {
        self.title = title
        self.titleColor = titleColor
        self._scrollOffset = scrollOffset
        self.icon = icon
        self.showTopRightButton = showTopRightButton
        self.backAction = backAction
        self.backgroundColor = backgroundColor
        self.usesCustomHeader = false
        self.header = EmptyView()
        self.drawer = drawer()
        self.content = content()
    }

    public init(
        title: String = "",
        titleColor: Color = .primary,
        scrollOffset: Binding<CGFloat>,
        icon: String? = nil,
        showTopRightButton: Bool = false,
        backAction: (() -> Void)? = nil,
        backgroundColor: Color = .clear,
        @ViewBuilder header: () -> Header,
        @ViewBuilder drawer: () -> Drawer = { EmptyView() },
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.titleColor = titleColor
        self._scrollOffset = scrollOffset
        self.icon = icon
        self.showTopRightButton = showTopRightButton
        self.backAction = backAction
        self.backgroundColor = backgroundColor
        self.usesCustomHeader = true
        self.header = header()
        self.drawer = drawer()
        self.content = content()
    }

    public var body: some View {
        GeometryReader { geo in
            let safeAreaTop = geo.safeAreaInsets.top

            let wrappedContent = Group {
                NavigationStack {
                    ScrollView {
                        VStack {
                            Color.clear
                                .frame(height: max(0, topMargin(safeAreaTop: safeAreaTop)))

                            ScrollOffsetBackground { offset in
                                if backAction == nil {
                                    scrollOffset = offset - topMargin(safeAreaTop: safeAreaTop) + safeAreaTop
                                } else {
                                    scrollOffset =
                                        offset - safeAreaTop
                                        - topMargin(safeAreaTop: safeAreaTop)
                                }
                            }
                            .frame(height: 0)

                            content
                                .frame(width: geo.size.width)
                                .frame(
                                    minHeight: max(
                                        0,
                                        geo.size.height
                                            - topMargin(safeAreaTop: safeAreaTop)))
                        }
                    }
                    .scrollIndicators(.hidden)
                    .navigationBarHidden(true)
                    .background(backgroundColor.ignoresSafeArea())
                }
                .navigationBarBackButtonHidden()
            }

            wrappedContent
                .variableBlur(
                    radius: metrics.blurRadius,
                    maskHeight: dynamicMaskHeight(safeAreaTop: safeAreaTop),
                    opacity: opacity
                )
                .ignoresSafeArea()
                .overlay {
                    NavigationBar(
                        scrollOffset: scrollOffset,
                        title: title,
                        titleColor: titleColor,
                        icon: icon,
                        showTopRightButton: showTopRightButton,
                        backAction: backAction,
                        usesCustomHeader: usesCustomHeader,
                        header: { header },
                        drawer: {
                            drawer
                                .background(
                                    GeometryReader { proxy in
                                        Color.clear
                                            .onAppear { drawerHeight = proxy.size.height }
                                            .onChange(of: proxy.size.height) { _, new in
                                                drawerHeight = new
                                            }
                                    }
                                )
                        }
                    )
                    .onPreferenceChange(NavBarHeightPreferenceKey.self) { height in
                        navBarHeight = height
                    }
                }
        }
    }

    var opacity: CGFloat {
        let progress = min(max(scrollOffset / metrics.transitionOffset, 0), 1)
        return 1 - progress
    }

    func topMargin(safeAreaTop: CGFloat) -> CGFloat {
        if navBarHeight > 0 {
            let offset = backAction != nil ? metrics.barOffsetCollapsed : metrics.barOffsetExpanded

            // Tighten padding: remove safeAreaTop from the padding so content moves up
            // and actually sits behind the blur, rather than being pushed below it.
            return navBarHeight + offset
        }

        // Fallback for initial render before preference fires
        let base = (config.showSearchBar && backAction == nil) ? metrics.contentMarginTopWithSearch : metrics.contentMarginTop
        return backAction == nil ? base + drawerHeight : base
    }

    func dynamicMaskHeight(safeAreaTop: CGFloat) -> CGFloat {
        // Keep safeAreaTop here so the mask is long enough to overlap the content.
        // This ensures the blur extends into the top of the content, creating a smooth fade.
        if navBarHeight > 0 {
            let offset = backAction != nil ? metrics.barOffsetCollapsed : metrics.barOffsetExpanded
            return safeAreaTop + navBarHeight + offset
        }
        
        return safeAreaTop + topMargin(safeAreaTop: safeAreaTop)
    }
}
