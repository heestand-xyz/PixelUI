//
//  Created by Anton Heestand on 2022-01-06.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelSharpen: Pixel {
    
    typealias Pix = SharpenPIX
    
    public let pixType: PIXType = .effect(.single(.sharpen))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case contrast
    }
    
    internal init(contrast: CGFloat,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .contrast:
                metadata[key.rawValue] = contrast
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .contrast:
            return pix.contrast
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .contrast:
                Pixels.updateValue(pix: &pix, value: value, at: \.contrast)
            }
        }
    }
}

public extension Pixel {
    
    func pixelSharpen(contrast: CGFloat) -> PixelSharpen {
        PixelSharpen(contrast: contrast, pixel: { self })
    }
}

struct PixelSharpen_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelSharpen(contrast: 10.0)
        }
    }
}
