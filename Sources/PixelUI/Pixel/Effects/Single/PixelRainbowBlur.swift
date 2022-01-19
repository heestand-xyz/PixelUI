//
//  Created by Anton Heestand on 2022-01-06.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelRainbowBlur: Pixel {
    
    typealias Pix = RainbowBlurPIX
    
    public let pixType: PIXType = .effect(.single(.rainbowBlur))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case style
        case radius
        case quality
        case angle
        case position
        case light
    }
    
    internal init(style: RainbowBlurPIX.Style,
                  radius: CGFloat,
                  quality: PIX.SampleQualityMode,
                  angle: CGFloat = 0.0,
                  offset position: CGPoint = .zero,
                  light: CGFloat = 1.0,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
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
                Pixels.updateValue(pix: &pix, value: value, at: \.angle)
            case .position:
                Pixels.updateValueInZeroPixelSpace(pix: &pix, value: value, size: size, at: \.position)
            case .light:
                Pixels.updateValue(pix: &pix, value: value, at: \.light)
            }
        }
    }
}

public extension Pixel {
    
    func pixelRainbowBlurCircle(radius: CGFloat, quality: PIX.SampleQualityMode = .high, light: CGFloat = 1.0) -> PixelRainbowBlur {
        PixelRainbowBlur(style: .circle, radius: radius, quality: quality, light: light, pixel: { self })
    }
    
    func pixelRainbowBlurAngle(radius: CGFloat, angle: CGFloat, quality: PIX.SampleQualityMode = .high, light: CGFloat = 1.0) -> PixelRainbowBlur {
        PixelRainbowBlur(style: .angle, radius: radius, quality: quality, angle: angle, light: light, pixel: { self })
    }
    
    func pixelRainbowBlurZoom(radius: CGFloat, offset: CGPoint = .zero, quality: PIX.SampleQualityMode = .high, light: CGFloat = 1.0) -> PixelRainbowBlur {
        PixelRainbowBlur(style: .zoom, radius: radius, quality: quality, offset: offset, light: light, pixel: { self })
    }
}

struct PixelRainbowBlur_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelRainbowBlurZoom(radius: 100)
        }
    }
}
