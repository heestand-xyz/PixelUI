//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelDisplace: Pixel {
    
    typealias Pix = DisplacePIX
    
    public let pixType: PIXType = .effect(.merger(.displace))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case distance
        case origin
        case extend
    }
    
    internal init(distance: CGFloat,
                  origin: CGFloat = 0.5,
                  pixel leadingPixel: () -> Pixel,
                  withPixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())
        
        for key in Key.allCases {
            switch key {
            case .distance:
                metadata[key.rawValue] = distance
            case .origin:
                metadata[key.rawValue] = origin
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .distance:
            return Pixels.inViewSpace(pix.distance, size: size)
        case .origin:
            return pix.origin
        case .extend:
            return pix.extend.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .distance:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.distance)
            case .origin:
                Pixels.updateValue(pix: &pix, value: value, at: \.origin)
            case .extend:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.extend)
            }
        }
    }
}

public extension Pixel {
    
    func pixelDisplace(_ distance: CGFloat, origin: CGFloat = 0.5, pixel: () -> Pixel) -> PixelDisplace {
        PixelDisplace(distance: distance, origin: origin, pixel: { self }, withPixel: pixel)
    }
}

public extension PixelDisplace {
    
    func pixelExtend(_ extend: ExtendMode) -> Self {
        var pixel = self
        pixel.metadata[Key.extend.rawValue] = extend.rawValue
        return pixel
    }
}

struct PixelDisplace_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCircle(radius: 100)
                .pixelDisplace(100) {
                    PixelNoise()
                }
        }
    }
}
