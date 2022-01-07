//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelLumaLevels: Pixel {
    
    typealias Pix = LumaLevelsPIX
    
    public let pixType: PIXType = .effect(.merger(.lumaLevels))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case brightness
        case darkness
        case contrast
        case gamma
        case inverted
        case smooth
        case opacity
        case offset
        case lumaGamma
    }
    
    internal init(brightness: CGFloat = 1.0,
                  darkness: CGFloat = 0.0,
                  contrast: CGFloat = 0.0,
                  gamma: CGFloat = 1.0,
                  inverted: Bool = false,
                  smooth: Bool = false,
                  opacity: CGFloat = 1.0,
                  offset: CGFloat = 0.0,
                  lumaGamma: CGFloat = 1.0,
                  pixel leadingPixel: () -> Pixel,
                  withPixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())

        for key in Key.allCases {
            switch key {
            case .brightness:
                metadata[key.rawValue] = brightness
            case .darkness:
                metadata[key.rawValue] = darkness
            case .contrast:
                metadata[key.rawValue] = contrast
            case .gamma:
                metadata[key.rawValue] = gamma
            case .inverted:
                metadata[key.rawValue] = inverted
            case .smooth:
                metadata[key.rawValue] = smooth
            case .opacity:
                metadata[key.rawValue] = opacity
            case .offset:
                metadata[key.rawValue] = offset
            case .lumaGamma:
                metadata[key.rawValue] = lumaGamma
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .brightness:
            return pix.brightness
        case .darkness:
            return pix.darkness
        case .contrast:
            return pix.contrast
        case .gamma:
            return pix.gamma
        case .inverted:
            return pix.inverted
        case .smooth:
            return pix.smooth
        case .opacity:
            return pix.opacity
        case .offset:
            return pix.offset
        case .lumaGamma:
            return pix.lumaGamma
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .brightness:
                Pixels.updateValue(pix: &pix, value: value, at: \.brightness)
            case .darkness:
                Pixels.updateValue(pix: &pix, value: value, at: \.darkness)
            case .contrast:
                Pixels.updateValue(pix: &pix, value: value, at: \.contrast)
            case .gamma:
                Pixels.updateValue(pix: &pix, value: value, at: \.gamma)
            case .inverted:
                Pixels.updateValue(pix: &pix, value: value, at: \.inverted)
            case .smooth:
                Pixels.updateValue(pix: &pix, value: value, at: \.smooth)
            case .opacity:
                Pixels.updateValue(pix: &pix, value: value, at: \.opacity)
            case .offset:
                Pixels.updateValue(pix: &pix, value: value, at: \.offset)
            case .lumaGamma:
                Pixels.updateValue(pix: &pix, value: value, at: \.lumaGamma)
            }
        }
    }
}

public extension Pixel {
    
    func pixelLumaBrightness(_ brightness: CGFloat, pixel: () -> Pixel) -> PixelLumaLevels {
        PixelLumaLevels(brightness: brightness, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaDarkness(_ darkness: CGFloat, pixel: () -> Pixel) -> PixelLumaLevels {
        PixelLumaLevels(darkness: darkness, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaContrast(_ contrast: CGFloat, pixel: () -> Pixel) -> PixelLumaLevels {
        PixelLumaLevels(contrast: contrast, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaGamma(_ gamma: CGFloat, pixel: () -> Pixel) -> PixelLumaLevels {
        PixelLumaLevels(gamma: gamma, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaInverted(pixel: () -> Pixel) -> PixelLumaLevels {
        PixelLumaLevels(inverted: true, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaSmooth(pixel: () -> Pixel) -> PixelLumaLevels {
        PixelLumaLevels(smooth: true, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaOpacity(_ opacity: CGFloat, pixel: () -> Pixel) -> PixelLumaLevels {
        PixelLumaLevels(opacity: opacity, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaExposureOffset(_ offset: CGFloat, pixel: () -> Pixel) -> PixelLumaLevels {
        PixelLumaLevels(offset: offset, pixel: { self }, withPixel: pixel)
    }
}

struct PixelLumaLevels_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelLumaInverted {
                    PixelGradient(axis: .vertical)
                }
        }
    }
}
