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
}

extension CGFloat: PixelMetadata {
    
//    public var encoded: String { "float:\(self)" }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
}

extension String: PixelMetadata {
    
//    public var encoded: String { "string:\(self)" }
    
    public func isEqual(to value: PixelMetadata) -> Bool {
        guard let value = value as? Self else { return false }
        return self == value
    }
}
