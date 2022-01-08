//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelBlend: Pixel {
    
    typealias Pix = BlendPIX
    
    public let pixType: PIXType = .effect(.merger(.blend))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case blendMode
        case bypassTransform
        case position
        case rotation
        case scale
        case size
    }
    
    public init(mode blendMode: RenderKit.BlendMode,
                pixel leadingPixel: () -> Pixel,
                withPixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())
        
        for key in Key.allCases {
            switch key {
            case .blendMode:
                metadata[key.rawValue] = blendMode.rawValue
            case .bypassTransform:
                metadata[key.rawValue] = true
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .blendMode:
            return pix.blendMode.rawValue
        case .bypassTransform:
            return pix.bypassTransform
        case .position:
            return Pixels.inZeroViewSpace(pix.position, size: size)
        case .rotation:
            return Pixels.asAngle(pix.rotation)
        case .scale:
            return pix.scale
        case .size:
            return pix.size
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .blendMode:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.blendMode)
            case .bypassTransform:
                Pixels.updateValue(pix: &pix, value: value, at: \.bypassTransform)
            case .position:
                Pixels.updateValueInZeroPixelSpace(pix: &pix, value: value, size: size, at: \.position)
            case .rotation:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.rotation)
            case .scale:
                Pixels.updateValue(pix: &pix, value: value, at: \.scale)
            case .size:
                Pixels.updateValue(pix: &pix, value: value, at: \.size)
            }
        }
    }
}

public extension PixelBlend {
    
    func pixelBlendOffset(_ offset: CGPoint) -> Self {
        var pixel = self
        pixel.metadata[Key.bypassTransform.rawValue] = false
        pixel.metadata[Key.position.rawValue] = offset
        return pixel
    }
    
    func pixelBlendRotate(_ angle: Angle) -> Self {
        var pixel = self
        pixel.metadata[Key.bypassTransform.rawValue] = false
        pixel.metadata[Key.rotation.rawValue] = angle
        return pixel
    }
    
    func pixelBlendScale(_ scale: CGFloat) -> Self {
        var pixel = self
        pixel.metadata[Key.bypassTransform.rawValue] = false
        pixel.metadata[Key.scale.rawValue] = scale
        return pixel
    }
    
    func pixelBlendScale(x: CGFloat = 1.0, y: CGFloat = 1.0) -> Self {
        var pixel = self
        pixel.metadata[Key.bypassTransform.rawValue] = false
        pixel.metadata[Key.size.rawValue] = CGSize(width: x, height: y)
        return pixel
    }
}

struct PixelBlend_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelBlend(mode: .add) {
                PixelCircle(radius: 100)
            } withPixel: {
                PixelStar(count: 5, radius: 150)
            }
        }
    }
}
