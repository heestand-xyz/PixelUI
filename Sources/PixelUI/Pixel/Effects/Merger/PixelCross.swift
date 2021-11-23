//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelCross: Pixel {
    
    typealias Pix = CrossPIX
    
    public let pixType: PIXType = .effect(.merger(.cross))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case fraction
    }
    
    public init(at fraction: CGFloat,
                pixel leadingPixel: () -> Pixel,
                displacePixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())
        
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

struct PixelCross_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCross(at: 0.5) {
                PixelCircle(radius: 100)
            } displacePixel: {
                PixelStar(count: 5, radius: 100)
            }
        }
    }
}
