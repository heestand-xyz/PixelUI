//
//  Created by Anton Heestand on 2021-11-21.
//

import Foundation
import SwiftUI

extension Pixels {
    
    static func asAngle(_ value: CGFloat) -> Angle {
        Angle(degrees: value * 360)
    }
}

extension Pixels {
    
    static func inViewSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        value * size.height
    }
    
    static func inViewZeroSpace(_ value: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: value.x * size.height,
                y: -value.y * size.height)
    }
    
    static func inViewSpace(_ value: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: value.x * size.height + size.width / 2,
                y: -value.y * size.height + size.height / 2)
    }
    
    static func inViewSpace(_ value: CGSize, size: CGSize) -> CGSize {
        CGSize(width: value.width * size.height,
               height: value.height * size.height)
    }
}

extension Pixels {
    
    static func inPixelSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        value / size.height
    }
    
    static func inPixelZeroSpace(_ value: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: value.x / size.height,
                y: -value.y / size.height)
    }
    
    static func inPixelSpace(_ value: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: (value.x - size.width / 2) / size.height,
                y: -(value.y - size.height / 2) / size.height)
    }
    
    static func inPixelSpace(_ value: CGSize, size: CGSize) -> CGSize {
        CGSize(width: value.width / size.height,
               height: value.height / size.height)
    }
}
