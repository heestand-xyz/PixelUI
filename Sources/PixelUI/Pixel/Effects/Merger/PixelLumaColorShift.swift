//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelLumaColorShift: Pixel {
    
    typealias Pix = LumaColorShiftPIX
    
    public let pixType: PIXType = .effect(.merger(.lumaColorShift))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case hue
        case saturation
        case tintColor
        case lumaGamma
    }
    
    internal init(hue: CGFloat = 0.0,
                  saturation: CGFloat = 1.0,
                  tintColor: Color = .white,
                  lumaGamma: CGFloat = 1.0,
                  pixel leadingPixel: () -> Pixel,
                  withPixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())

        for key in Key.allCases {
            switch key {
            case .hue:
                metadata[key.rawValue] = hue
            case .saturation:
                metadata[key.rawValue] = saturation
            case .tintColor:
                metadata[key.rawValue] = PixelColor(tintColor)
            case .lumaGamma:
                metadata[key.rawValue] = lumaGamma
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
        case .lumaGamma:
            return pix.lumaGamma
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
            case .lumaGamma:
                Pixels.updateValue(pix: &pix, value: value, at: \.lumaGamma)
            }
        }
    }
}

public extension Pixel {
    
    func pixelLumaHue(_ hue: CGFloat, lumaGamma: CGFloat = 1.0, pixel: () -> Pixel) -> PixelLumaColorShift {
        PixelLumaColorShift(hue: hue, lumaGamma: lumaGamma, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaSaturation(_ saturation: CGFloat, lumaGamma: CGFloat = 1.0, pixel: () -> Pixel) -> PixelLumaColorShift {
        PixelLumaColorShift(saturation: saturation, lumaGamma: lumaGamma, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaMonochrome(lumaGamma: CGFloat = 1.0, pixel: () -> Pixel) -> PixelLumaColorShift {
        PixelLumaColorShift(saturation: 0.0, lumaGamma: lumaGamma, pixel: { self }, withPixel: pixel)
    }
}

struct PixelLumaColorShift_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelLumaHue(2.0) {
                    PixelGradient(axis: .vertical)
                }
        }
    }
}
