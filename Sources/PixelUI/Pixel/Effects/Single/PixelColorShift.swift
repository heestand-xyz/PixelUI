//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelColorShift: Pixel {
    
    typealias Pix = ColorShiftPIX
    
    public let pixType: PIXType = .effect(.single(.colorShift))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case hue
        case saturation
        case tintColor
    }
    
    internal init(hue: CGFloat = 0.0,
                  saturation: CGFloat = 1.0,
                  tintColor: Color = .white,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .hue:
                metadata[key.rawValue] = hue
            case .saturation:
                metadata[key.rawValue] = saturation
            case .tintColor:
                metadata[key.rawValue] = PixelColor(tintColor)
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .hue:
            return pix.hue
        case .saturation:
            return pix.saturation
        case .tintColor:
            return pix.tintColor
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .hue:
                Pixels.updateValue(pix: &pix, value: value, at: \.hue)
            case .saturation:
                Pixels.updateValue(pix: &pix, value: value, at: \.saturation)
            case .tintColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.tintColor)
            }
        }
    }
}

public extension Pixel {
    
    func pixelHue(_ hue: CGFloat) -> PixelColorShift {
        PixelColorShift(hue: hue, pixel: { self })
    }
    
    func pixelSaturation(_ saturation: CGFloat) -> PixelColorShift {
        PixelColorShift(saturation: saturation, pixel: { self })
    }
    
    func pixelMonochrome() -> PixelColorShift {
        PixelColorShift(saturation: 0.0, pixel: { self })
    }
    
    func pixelTint(_ color: Color) -> PixelColorShift {
        PixelColorShift(tintColor: color, pixel: { self })
    }
}

struct PixelColorShift_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelImage("kite")
                .pixelMonochrome()
        }
    }
}
