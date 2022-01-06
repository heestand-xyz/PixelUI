//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelMorph: Pixel {
    
    typealias Pix = MorphPIX
    
    public let pixType: PIXType = .effect(.single(.morph))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case style
        case width
        case height
    }
    
    internal init(style: MorphPIX.Style = .maximum,
                  width: Int = 1,
                  height: Int = 1,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .style:
                metadata[key.rawValue] = style.rawValue
            case .width:
                metadata[key.rawValue] = width
            case .height:
                metadata[key.rawValue] = height
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .style:
            return pix.style.rawValue
        case .width:
            return pix.width
        case .height:
            return pix.height
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .style:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.style)
            case .width:
                Pixels.updateValue(pix: &pix, value: value, at: \.width)
            case .height:
                Pixels.updateValue(pix: &pix, value: value, at: \.height)
            }
        }
    }
}

public extension Pixel {
    
    func pixelMorphMinimum(width: Int, height: Int) -> PixelMorph {
        PixelMorph(style: .minimum, width: width, height: height, pixel: { self })
    }
    
    func pixelMorphMaximum(width: Int, height: Int) -> PixelMorph {
        PixelMorph(style: .maximum, width: width, height: height, pixel: { self })
    }
}

struct PixelMorph_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelMorphMaximum(width: 10, height: 10)
        }
    }
}
