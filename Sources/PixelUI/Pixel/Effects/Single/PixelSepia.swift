//
//  Created by Anton Heestand on 2022-01-06.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelSepia: Pixel {
    
    typealias Pix = SepiaPIX
    
    public let pixType: PIXType = .effect(.single(.sepia))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case color
    }
    
    internal init(color: PixelColor,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .color:
                metadata[key.rawValue] = color
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .color:
            return pix.color
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .color:
                Pixels.updateValue(pix: &pix, value: value, at: \.color)
            }
        }
    }
}

public extension Pixel {
    
    func pixelSepia(_ color: Color) -> PixelSepia {
        PixelSepia(color: PixelColor(color), pixel: { self })
    }
}

struct PixelSepia_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelSepia(.orange)
        }
    }
}
