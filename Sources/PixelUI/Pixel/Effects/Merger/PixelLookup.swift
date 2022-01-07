//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelLookup: Pixel {
    
    typealias Pix = LookupPIX
    
    public let pixType: PIXType = .effect(.merger(.lookup))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case axis
        case holdEdge
    }
    
    internal init(axis: LookupPIX.Axis,
                  pixel leadingPixel: () -> Pixel,
                  withPixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())

        for key in Key.allCases {
            switch key {
            case .axis:
                metadata[key.rawValue] = axis.rawValue
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .axis:
            return pix.axis.rawValue
        case .holdEdge:
            return pix.holdEdge
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .axis:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.axis)
            case .holdEdge:
                Pixels.updateValue(pix: &pix, value: value, at: \.holdEdge)
            }
        }
    }
}

public extension Pixel {
    
    func pixelLookup(axis: LookupPIX.Axis, pixel: () -> Pixel) -> PixelLookup {
        PixelLookup(axis: axis, pixel: { self }, withPixel: pixel)
    }
}

struct PixelLookup_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCircle(radius: 100)
                .pixelBlur(radius: 50)
                .pixelLookup(axis: .vertical) {
                    PixelGradient(axis: .vertical, colorStops: [
                        PixelColorStop(at: 0.0, color: .red),
                        PixelColorStop(at: 0.5, color: .orange),
                        PixelColorStop(at: 1.0, color: .yellow),
                    ])
                }
        }
    }
}
