//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import SwiftUI
import Resolution
import RenderKit
import PixelKit

public struct PixelBlends: Pixel {
    
    typealias Pix = BlendsPIX
    
    public var pixType: PIXType = .effect(.multi(.blends))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata]
    
    enum Key: String {
        case blendMode
    }
    
    public init(mode blendMode: RenderKit.BlendMode,
                @PixelBuilder pixels: () -> [Pixel]) {
        metadata = [
            Key.blendMode.rawValue : blendMode.rawValue,
        ]
        pixelTree = .multiEffect(pixels())
    }
    
    public func value(at key: String, pix: PIX) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }

        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .blendMode:
            return pix.blendMode.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX) {
        
        guard let pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
            
            guard let key = Key(rawValue: key) else { continue }
        
            switch key {
            case .blendMode:
                guard let rawValue = value as? String else { continue }
                guard let value = RenderKit.BlendMode(rawValue: rawValue) else { continue }
                pix.blendMode = value
            }
        }
    }
}

struct PixelBlends_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelBlends(mode: .average) {
                PixelCircle()
                PixelPolygon(count: 3)
            }
        }
    }
}
