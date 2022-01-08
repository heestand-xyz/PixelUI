//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelLumaRainbowBlur: Pixel {
    
    typealias Pix = LumaRainbowBlurPIX
    
    public let pixType: PIXType = .effect(.merger(.lumaRainbowBlur))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case style
        case radius
        case quality
        case angle
        case position
        case light
        case lumaGamma
    }
    
    internal init(style: LumaRainbowBlurPIX.RainbowLumaBlurStyle,
                  radius: CGFloat,
                  quality: PIX.SampleQualityMode = .high,
                  angle: Angle = .zero,
                  offset position: CGPoint = .zero,
                  light: CGFloat = 1.0,
                  lumaGamma: CGFloat = 1.0,
                  pixel leadingPixel: () -> Pixel,
                  withPixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())

        for key in Key.allCases {
            switch key {
            case .style:
                metadata[key.rawValue] = style.rawValue
            case .radius:
                metadata[key.rawValue] = radius
            case .quality:
                metadata[key.rawValue] = quality.rawValue
            case .angle:
                metadata[key.rawValue] = angle
            case .position:
                metadata[key.rawValue] = position
            case .light:
                metadata[key.rawValue] = light
            case .lumaGamma:
                metadata[key.rawValue] = lumaGamma
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .style:
            return pix.style.rawValue
        case .radius:
            return Pixels.inViewSpace(pix.radius, size: size)
        case .quality:
            return pix.quality.rawValue
        case .angle:
            return Pixels.asAngle(pix.angle)
        case .position:
            return Pixels.inZeroViewSpace(pix.position, size: size)
        case .light:
            return pix.light
        case .lumaGamma:
            return pix.lumaGamma
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .style:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.style)
            case .radius:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.radius)
            case .quality:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.quality)
            case .angle:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.angle)
            case .position:
                Pixels.updateValueInZeroPixelSpace(pix: &pix, value: value, size: size, at: \.position)
            case .light:
                Pixels.updateValue(pix: &pix, value: value, at: \.light)
            case .lumaGamma:
                Pixels.updateValue(pix: &pix, value: value, at: \.lumaGamma)
            }
        }
    }
}

public extension Pixel {
    
    func pixelLumaRainbowBlurCircle(radius: CGFloat, light: CGFloat = 1.0, lumaGamma: CGFloat = 1.0, pixel: () -> Pixel) -> PixelLumaRainbowBlur {
        PixelLumaRainbowBlur(style: .circle, radius: radius, light: light, lumaGamma: lumaGamma, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaRainbowBlurAngle(radius: CGFloat, angle: Angle, light: CGFloat = 1.0, lumaGamma: CGFloat = 1.0, pixel: () -> Pixel) -> PixelLumaRainbowBlur {
        PixelLumaRainbowBlur(style: .angle, radius: radius, angle: angle, light: light, lumaGamma: lumaGamma, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaRainbowBlurZoom(radius: CGFloat, offset: CGPoint = .zero, light: CGFloat = 1.0, lumaGamma: CGFloat = 1.0, pixel: () -> Pixel) -> PixelLumaRainbowBlur {
        PixelLumaRainbowBlur(style: .zoom, radius: radius, offset: offset, light: light, lumaGamma: lumaGamma, pixel: { self }, withPixel: pixel)
    }
}

struct PixelLumaRainbowBlur_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCircle(radius: 500)
                .pixelLumaRainbowBlurCircle(radius: 100) {
                    PixelGradient(axis: .vertical)
                }
        }
    }
}
