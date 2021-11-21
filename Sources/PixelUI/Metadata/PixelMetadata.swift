//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-17.
//

import Foundation
import CoreGraphics
import PixelKit

public protocol PixelMetadata {
    
//    var encoded: String { get }
    
    func isEqual(to value: PixelMetadata) -> Bool
    func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata
}

//extension String {
//
//    var decoded: PixelMetadata? {
//        let components = components(separatedBy: ":")
//        guard components.count >= 2 else { return nil }
//        switch components.first! {
//        case "int":
//            return Int(components.last!)
//        case "float":
//            guard let double = Double(components.last!) else { return nil }
//            return CGFloat(double)
//        case "string":
//            return components.dropFirst().joined(separator: ":")
//        default:
//            return nil
//        }
//    }
//}

extension Int: PixelMetadata {
    
//    public var encoded: String { "int:\(self)" }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? Int else { return self }
        return Int(round(Double(self) * (1.0 - fraction) + Double(value) * fraction))
    }
}

extension CGFloat: PixelMetadata {
    
//    public var encoded: String { "float:\(self)" }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? CGFloat else { return self }
        return self * (1.0 - fraction) + value * fraction
    }
}

extension String: PixelMetadata {
    
//    public var encoded: String { "string:\(self)" }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
    
    public func interpolate(at fraction: CGFloat, to value: PixelMetadata) -> PixelMetadata {
        guard let value = value as? String else { return self }
        return fraction == 0.0 ? self : value
    }
}
