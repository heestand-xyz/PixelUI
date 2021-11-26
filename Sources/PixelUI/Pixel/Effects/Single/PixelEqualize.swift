//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelEqualize: Pixel {
    
    typealias Pix = EqualizePIX
    
    public let pixType: PIXType = .effect(.single(.equalize))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case includeAlpha
    }
    
    internal init(includeAlpha: Bool = false,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .includeAlpha:
                metadata[key.rawValue] = includeAlpha
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .includeAlpha:
            return pix.includeAlpha
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .includeAlpha:
                Pixels.updateValue(pix: &pix, value: value, at: \.includeAlpha)
            }
        }
    }
}

public extension Pixel {
    
    func pixelEqualize(includeAlpha: Bool = false) -> PixelEqualize {
        PixelEqualize(includeAlpha: includeAlpha, pixel: { self })
    }
}

struct PixelEqualize_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelEqualize()
        }
    }
}
