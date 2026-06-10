//
//  ScreenSize.swift
//  Aesthetics
//
//  Created by Aarav Gupta on 10/06/26.
//

import UIKit

public enum ScreenSize: Sendable {
    case compact    // 320pt — SE 4-inch, iPod touch
    case small      // 360pt — 12/13 mini
    case medium     // 375pt — SE 4.7", X, XS, 11 Pro
    case standard   // 390-402pt — 12-16, 16e, 17, 17 Pro, 15/16 Pro
    case large      // 414-420pt — 11, XR, 8+, 11 Pro Max, Air
    case xlarge     // 428-440pt — 13-16 Plus/Pro Max, 17 Pro Max
    
    public static var current: ScreenSize {
        let width = UIScreen.main.bounds.width
        switch width {
        case ..<340:  return .compact    // 320pt
        case ..<370:  return .small      // 360pt
        case ..<385:  return .medium     // 375pt
        case ..<410:  return .standard   // 390-402pt
        case ..<425:  return .large      // 414-420pt
        default:      return .xlarge     // 428-440pt
        }
    }
    
    // The actual widths from HIG, useful for proportional calculations
    public var referenceWidth: CGFloat {
        switch self {
        case .compact:  return 320
        case .small:    return 360
        case .medium:   return 375
        case .standard: return 393
        case .large:    return 414
        case .xlarge:   return 430
        }
    }
}
