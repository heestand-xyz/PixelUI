//
//  Created by Anton Heestand on 2021-11-21.
//

import Foundation
import SwiftUI

extension Pixels {
    
    static func asAngle(_ value: CGFloat) -> Angle {
        Angle(degrees: value * 360)
    }
    
    static func asRotation(_ value: Angle) -> CGFloat {
        CGFloat(value.degrees) / 360
    }
}

extension Pixels {
    
    static func inViewSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        value * size.height
    }
    
    static func inZeroViewSpace(_ value: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: value.x * size.height,
                y: -value.y * size.height)
    }
    
    static func inNormalizedViewSpace(_ value: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: value.x * size.width,
                y: (1.0 - value.y) * size.height)
    }
    
    static func inNormalizedLeftViewSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        value * size.width
    }
    
    static func inNormalizedRightViewSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        (1.0 - value) * size.width
    }
    
    static func inNormalizedBottomViewSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        value * size.height
    }
    
    static func inNormalizedTopViewSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        (1.0 - value) * size.height
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
    
    static func inZeroPixelSpace(_ value: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: value.x / size.height,
                y: -value.y / size.height)
    }
    
    static func inNormalizedPixelSpace(_ value: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: value.x / size.width,
                y: 1.0 - (value.y / size.height))
    }
    
    static func inNormalizedLeftPixelSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        value / size.width
    }
    
    static func inNormalizedRightPixelSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        1.0 - (value / size.width)
    }
    
    static func inNormalizedBottomPixelSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        value / size.height
    }
    
    static func inNormalizedTopPixelSpace(_ value: CGFloat, size: CGSize) -> CGFloat {
        1.0 - (value / size.height)
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
