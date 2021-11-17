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
    var asString: String { get }
}

extension Int: PixelMetadata {
    public var asString: String { "\(self)" }
}

extension CGFloat: PixelMetadata {
    public var asString: String { "\(self)" }
}

extension String: PixelMetadata {
    public var asString: String { "\(self)" }
}
