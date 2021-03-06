//
//  Created by Anton Heestand on 2021-11-17.
//

import Foundation
import CoreGraphics
import SwiftUI
import PixelKit
import PixelColor

public protocol PixelMetadata {
        
    var resolutionUpdate: Bool { get }
    
    func isEqual(to value: PixelMetadata) -> Bool
    func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata
}

extension Bool: PixelMetadata {
    
    public var resolutionUpdate: Bool { false }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        return fraction == 0.0 ? self : value
    }
}

extension Int: PixelMetadata {
    
    public var resolutionUpdate: Bool { false }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        return Int(round(Double(self) * (1.0 - fraction) + Double(value) * fraction))
    }
}

extension CGFloat: PixelMetadata {
    
    public var resolutionUpdate: Bool { true }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        return self * (1.0 - fraction) + value * fraction
    }
}

extension Angle: PixelMetadata {
    
    public var resolutionUpdate: Bool { false }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        #warning("Negative Angle Interpolation")
        return Angle(radians: radians * (1.0 - fraction) + value.radians * fraction)
    }
}

extension CGPoint: PixelMetadata {
    
    public var resolutionUpdate: Bool { true }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        return CGPoint(x: x * (1.0 - fraction) + value.x * fraction,
                       y: y * (1.0 - fraction) + value.y * fraction)
    }
}

extension CGSize: PixelMetadata {
    
    public var resolutionUpdate: Bool { true }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        return CGSize(width: width * (1.0 - fraction) + value.width * fraction,
                      height: height * (1.0 - fraction) + value.height * fraction)
    }
}

extension PixelColor: PixelMetadata {
    
    public var resolutionUpdate: Bool { false }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        return PixelColor(red: red * (1.0 - fraction) + value.red * fraction,
                          green: green * (1.0 - fraction) + value.green * fraction,
                          blue: blue * (1.0 - fraction) + value.blue * fraction,
                          alpha: alpha * (1.0 - fraction) + value.alpha * fraction)
    }
}


extension String: PixelMetadata {
    
    public var resolutionUpdate: Bool { false }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        return fraction == 0.0 ? self : value
    }
}

extension PixelVariable: PixelMetadata {
    
    public var resolutionUpdate: Bool { true }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self.name == value.name && self.value == value.value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        return PixelVariable(name: fraction == 0.0 ? self.name : value.name,
                             value: self.value * (1.0 - fraction) + value.value * fraction)
    }
}

extension FutureImage: PixelMetadata {
    
    public var resolutionUpdate: Bool { false }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard value is Self else { return false }
        #warning("New image will not update")
        return true
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        return fraction == 0.0 ? self : value
    }
}

extension FutureView: PixelMetadata {
    
    public var resolutionUpdate: Bool { false }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard value is Self else { return false }
        #warning("New view will not update")
        return true
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Self else { return self }
        return fraction == 0.0 ? self : value
    }
}

