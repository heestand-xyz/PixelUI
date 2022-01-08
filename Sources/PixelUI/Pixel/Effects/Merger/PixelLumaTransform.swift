//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelLumaTransform: Pixel {
    
    typealias Pix = LumaTransformPIX
    
    public let pixType: PIXType = .effect(.merger(.lumaTransform))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case position
        case rotation
        case scale
        case size
        case lumaGamma
        case extend
    }
    
    internal init(offset position: CGPoint = .zero,
                  angle rotation: Angle = .zero,
                  scale: CGFloat = 1.0,
                  size: CGSize = CGSize(width: 1.0, height: 1.0),
                  lumaGamma: CGFloat = 1.0,
                  pixel leadingPixel: () -> Pixel,
                  withPixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())

        for key in Key.allCases {
            switch key {
            case .position:
                metadata[key.rawValue] = position
            case .rotation:
                metadata[key.rawValue] = rotation
            case .scale:
                metadata[key.rawValue] = scale
            case .size:
                metadata[key.rawValue] = size
            case .lumaGamma:
                metadata[key.rawValue] = lumaGamma
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .position:
            return Pixels.inZeroViewSpace(pix.position, size: size)
        case .rotation:
            return Pixels.asAngle(pix.rotation)
        case .scale:
            return pix.scale
        case .size:
            return pix.size
        case .lumaGamma:
            return pix.lumaGamma
        case .extend:
            return pix.extend.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .position:
                Pixels.updateValueInZeroPixelSpace(pix: &pix, value: value, size: size, at: \.position)
            case .rotation:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.rotation)
            case .scale:
                Pixels.updateValue(pix: &pix, value: value, at: \.scale)
            case .size:
                Pixels.updateValue(pix: &pix, value: value, at: \.size)
            case .lumaGamma:
                Pixels.updateValue(pix: &pix, value: value, at: \.lumaGamma)
            case .extend:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.extend)
            }
        }
    }
}

public extension Pixel {
    
    func pixelLumaOffset(x: CGFloat = 0.0, y: CGFloat = 0.0, lumaGamma: CGFloat = 1.0, pixel: () -> Pixel) -> PixelLumaTransform {
        PixelLumaTransform(offset: CGPoint(x: x, y: y), lumaGamma: lumaGamma, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaRotate(_ angle: Angle, lumaGamma: CGFloat = 1.0, pixel: () -> Pixel) -> PixelLumaTransform {
        PixelLumaTransform(angle: angle, lumaGamma: lumaGamma, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaScale(_ scale: CGFloat, lumaGamma: CGFloat = 1.0, pixel: () -> Pixel) -> PixelLumaTransform {
        PixelLumaTransform(scale: scale, lumaGamma: lumaGamma, pixel: { self }, withPixel: pixel)
    }
    
    func pixelLumaScale(x: CGFloat = 1.0, y: CGFloat = 1.0, lumaGamma: CGFloat = 1.0, pixel: () -> Pixel) -> PixelLumaTransform {
        PixelLumaTransform(size: CGSize(width: x, height: y), lumaGamma: lumaGamma, pixel: { self }, withPixel: pixel)
    }
}

extension PixelLumaTransform {
    
    func pixelExtend(_ extend: ExtendMode) -> Self {
        var pixel = self
        pixel.metadata[Key.extend.rawValue] = extend.rawValue
        return pixel
    }
}

struct PixelLumaTransform_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCircle(radius: 500)
                .pixelLumaOffset(x: 500) {
                    PixelGradient(axis: .vertical)
                }
        }
    }
}
