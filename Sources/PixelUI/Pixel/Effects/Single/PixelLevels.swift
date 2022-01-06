//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelLevels: Pixel {
    
    typealias Pix = LevelsPIX
    
    public let pixType: PIXType = .effect(.single(.levels))
    
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
    }
    
    internal init(brightness: CGFloat = 1.0,
                  darkness: CGFloat = 0.0,
                  contrast: CGFloat = 0.0,
                  gamma: CGFloat = 1.0,
                  inverted: Bool = false,
                  smooth: Bool = false,
                  opacity: CGFloat = 1.0,
                  offset: CGFloat = 0.0,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
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
            }
        }
    }
}

public extension Pixel {
    
    func pixelBrightness(_ brightness: CGFloat) -> PixelLevels {
        PixelLevels(brightness: brightness, pixel: { self })
    }
    
    func pixelDarkness(_ darkness: CGFloat) -> PixelLevels {
        PixelLevels(darkness: darkness, pixel: { self })
    }
    
    func pixelContrast(_ contrast: CGFloat) -> PixelLevels {
        PixelLevels(contrast: contrast, pixel: { self })
    }
    
    func pixelGamma(_ gamma: CGFloat) -> PixelLevels {
        PixelLevels(gamma: gamma, pixel: { self })
    }
    
    func pixelInverted() -> PixelLevels {
        PixelLevels(inverted: true, pixel: { self })
    }
    
    func pixelSmooth() -> PixelLevels {
        PixelLevels(smooth: true, pixel: { self })
    }
    
    func pixelOpacity(_ opacity: CGFloat) -> PixelLevels {
        PixelLevels(opacity: opacity, pixel: { self })
    }
    
    func pixelExposureOffset(_ offset: CGFloat) -> PixelLevels {
        PixelLevels(offset: offset, pixel: { self })
    }
}

struct PixelLevels_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelInverted()
        }
    }
}
