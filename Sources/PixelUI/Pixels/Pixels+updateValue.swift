//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-21.
//

import Foundation
import PixelKit

extension Pixels {
    
    static func updateValue<P, T>(pix: inout P,
                                  value: PixelMetadata,
                                  at keyPath: WritableKeyPath<P, T>) where P: PIX {
        guard let value = value as? T else { return }
        pix[keyPath: keyPath] = value
    }
    
    static func updateRawValue<P, T>(pix: inout P,
                                     value: PixelMetadata,
                                     at keyPath: WritableKeyPath<P, T>) where P: PIX, T: RawRepresentable {
        guard let rawValue = value as? T.RawValue else { return }
        guard let value = T(rawValue: rawValue) else { return }
        pix[keyPath: keyPath] = value
    }
}
