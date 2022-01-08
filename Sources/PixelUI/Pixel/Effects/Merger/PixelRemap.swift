//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelRemap: Pixel {
    
    typealias Pix = RemapPIX
    
    public let pixType: PIXType = .effect(.merger(.remap))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    internal init(pixel leadingPixel: () -> Pixel,
                  withPixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? { nil }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {}
}

public extension Pixel {
    
    func pixelRemap(pixel: () -> Pixel) -> PixelRemap {
        PixelRemap(pixel: { self }, withPixel: pixel)
    }
}

struct PixelRemap_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCircle(radius: 100)
                .pixelRemap {
                    PixelBlends(mode: .add) {
                        PixelGradient(axis: .horizontal, colors: [.black, Color(red: 1.0, green: 0.0, blue: 0.0)])
                        PixelGradient(axis: .vertical, colors: [.black, Color(red: 0.0, green: 1.0, blue: 0.0)])
                    }
                    .pixelDisplace(100) {
                        PixelNoise()
                    }
                }
        }
    }
}
