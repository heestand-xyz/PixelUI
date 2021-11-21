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
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case blendMode
    }
    
    public init(mode blendMode: RenderKit.BlendMode,
                @PixelBuilder pixels: () -> [Pixel]) {

        pixelTree = .multiEffect(pixels())
        
        for key in Key.allCases {
            switch key {
            case .blendMode:
                metadata[key.rawValue] = blendMode.rawValue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }

        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .blendMode:
            return pix.blendMode.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
            
            guard let key = Key(rawValue: key) else { continue }
        
            switch key {
            case .blendMode:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.blendMode)
            }
        }
    }
}

struct PixelBlends_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelBlends(mode: .average) {
                PixelCircle(radius: 100)
                PixelPolygon(count: 3, radius: 100)
            }
        }
    }
}
