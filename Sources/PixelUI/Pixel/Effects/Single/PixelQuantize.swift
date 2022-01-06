//
//  Created by Anton Heestand on 2022-01-06.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelQuantize: Pixel {
    
    typealias Pix = QuantizePIX
    
    public let pixType: PIXType = .effect(.single(.quantize))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case fraction
    }
    
    internal init(fraction: CGFloat,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .fraction:
                metadata[key.rawValue] = fraction
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .fraction:
            return pix.fraction
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .fraction:
                Pixels.updateValue(pix: &pix, value: value, at: \.fraction)
            }
        }
    }
}

public extension Pixel {
    
    /// Fraction is between `0.0` and `1.0`
    /// A higher value will result in lower quality image.
    func pixelQuantize(_ fraction: CGFloat) -> PixelQuantize {
        PixelQuantize(fraction: fraction, pixel: { self })
    }
}

struct PixelQuantize_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelQuantize(0.125)
        }
    }
}
