//
//  Created by Anton Heestand on 2021-11-21.
//

import Foundation
import PixelKit
import SwiftUI

extension Pixels {
    
    static func updateValue<P, T>(pix: inout P,
                                  value: PixelMetadata,
                                  at keyPath: WritableKeyPath<P, T>) where P: PIX {
        guard let value = value as? T else { return }
        pix[keyPath: keyPath] = value
    }
    
    static func updateValueAngle<P>(pix: inout P,
                                    value: PixelMetadata,
                                    at keyPath: WritableKeyPath<P, CGFloat>) where P: PIX {
        guard let value = value as? Angle else { return }
        pix[keyPath: keyPath] = CGFloat(value.degrees) / 360
    }
    
    static func updateValueInPixelSpace<P>(pix: inout P,
                                           value: PixelMetadata,
                                           size: CGSize,
                                           at keyPath: WritableKeyPath<P, CGFloat>) where P: PIX {
        if let value = value as? CGFloat {
            pix[keyPath: keyPath] = inPixelSpace(value, size: size)
        }
    }
    
    static func updateValueInPixelSpace<P>(pix: inout P,
                                           value: PixelMetadata,
                                           size: CGSize,
                                           at keyPath: WritableKeyPath<P, CGPoint>) where P: PIX {
        if let value = value as? CGPoint {
            pix[keyPath: keyPath] = inPixelSpace(value, size: size)
        }
    }
    
    static func updateValueInPixelSpace<P>(pix: inout P,
                                           value: PixelMetadata,
                                           size: CGSize,
                                           at keyPath: WritableKeyPath<P, CGSize>) where P: PIX {
        if let value = value as? CGSize {
            pix[keyPath: keyPath] = inPixelSpace(value, size: size)
        }
    }
    
    static func updateRawValue<P, T>(pix: inout P,
                                     value: PixelMetadata,
                                     at keyPath: WritableKeyPath<P, T>) where P: PIX, T: RawRepresentable {
        guard let rawValue = value as? T.RawValue else { return }
        guard let value = T(rawValue: rawValue) else { return }
        pix[keyPath: keyPath] = value
    }
}
