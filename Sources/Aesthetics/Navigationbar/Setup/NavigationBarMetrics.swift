//
//  NavigationBarMetrics.swift
//  Aesthetics
//
//  Created by Aarav Gupta on 10/06/26.
//

import SwiftUI
import UIKit

public struct NavigationBarMetrics: Sendable {
    public let screenWidth: CGFloat
    public let screenHeight: CGFloat
    public let size: ScreenSize
    
    // Title — scales with screen width
    public var titleSizeExpanded: CGFloat {
        max(28, round(screenWidth * 0.085))
    }
    
    public var titleSizeCollapsed: CGFloat {
        round(screenWidth * 0.07)   // ~28 on 393pt
    }
    
    // Content top margin — space the nav bar needs
    public var contentMarginTop: CGFloat {
        round(screenHeight * 0.12)
    }

    public var contentMarginTopWithSearch: CGFloat {
        round(screenHeight * 0.14)  // was contentMarginTop + 50 — ~157 on 874pt
    }
    
    // Bar heights
    public var barHeightExpanded: CGFloat {
        round(screenHeight * 0.18)  // ~186 on 844pt, ~205 on 932pt
    }
    
    public var barHeightCollapsed: CGFloat {
        round(screenHeight * 0.15)  // ~127 on 844pt, ~140 on 932pt
    }
    
    // Bar offset — how far up the bar sits
    public var barOffsetExpanded: CGFloat {
        round(screenHeight * -0.012)  // was -0.035 — gentler, keeps title below Dynamic Island
    }

    public var barOffsetCollapsed: CGFloat {
        round(screenHeight * -0.03)   // was -0.05
    }
    
    // Transition — scroll distance to complete the animation
    public var transitionOffset: CGFloat {
        round(screenHeight * 0.065)   // ~55 on 844pt
    }
    
    // Blur
    public var blurRadius: CGFloat {
        round(screenWidth * 0.026)    // ~10 on 393pt
    }
    
    public var maskHeight: CGFloat {
        round(screenHeight * 0.12)    // ~127 on 844pt
    }
    
    public static var current: NavigationBarMetrics {
        let bounds = UIScreen.main.bounds
        return NavigationBarMetrics(
            screenWidth: bounds.width,
            screenHeight: bounds.height,
            size: .current
        )
    }
}
