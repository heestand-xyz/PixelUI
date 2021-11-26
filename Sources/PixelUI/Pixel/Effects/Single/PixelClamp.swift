//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelClamp: Pixel {
    
    typealias Pix = ClampPIX
    
    public let pixType: PIXType = .effect(.single(.clamp))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case low
        case high
        case clampAlpha
    }
    
    internal init(low: CGFloat = 0.0,
                  high: CGFloat = 1.0,
                  clampAlpha: Bool = false,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .low:
                metadata[key.rawValue] = low
            case .high:
                metadata[key.rawValue] = high
            case .clampAlpha:
                metadata[key.rawValue] = clampAlpha
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .low:
            return pix.low
        case .high:
            return pix.high
        case .clampAlpha:
            return pix.clampAlpha
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .low:
                Pixels.updateValue(pix: &pix, value: value, at: \.low)
            case .high:
                Pixels.updateValue(pix: &pix, value: value, at: \.high)
            case .clampAlpha:
                Pixels.updateValue(pix: &pix, value: value, at: \.clampAlpha)
            }
        }
    }
}

public extension Pixel {
    
    func pixelClamp(low: CGFloat = 0.0,
                    high: CGFloat = 1.0) -> PixelClamp {
        PixelClamp(low: low, high: high, pixel: { self })
    }
    
    func pixelClampWithAlpha(low: CGFloat = 0.0,
                             high: CGFloat = 1.0) -> PixelClamp {
        PixelClamp(low: low, high: high, clampAlpha: true, pixel: { self })
    }
}

struct PixelClamp_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCircle(radius: 100)
                .pixelBlur(radius: 100)
                .pixelClamp(low: 0.25, high: 0.75)
        }
    }
}
