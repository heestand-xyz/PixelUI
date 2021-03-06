//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelTransform: Pixel {
    
    typealias Pix = TransformPIX
    
    public let pixType: PIXType = .effect(.single(.transform))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case position
        case rotation
        case scale
        case size
        case extend
    }
    
    internal init(offset position: CGPoint = .zero,
                  angle rotation: Angle = .zero,
                  scale: CGFloat = 1.0,
                  size: CGSize = CGSize(width: 1.0, height: 1.0),
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
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
            case .extend:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.extend)
            }
        }
    }
}

public extension Pixel {
    
    func pixelOffset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> PixelTransform {
        PixelTransform(offset: CGPoint(x: x, y: y), pixel: { self })
    }
    
    func pixelRotate(_ angle: Angle) -> PixelTransform {
        PixelTransform(angle: angle, pixel: { self })
    }
    
    func pixelScale(_ scale: CGFloat) -> PixelTransform {
        PixelTransform(scale: scale, pixel: { self })
    }
    
    func pixelScale(x: CGFloat = 1.0, y: CGFloat = 1.0) -> PixelTransform {
        PixelTransform(size: CGSize(width: x, height: y), pixel: { self })
    }
}

extension PixelTransform {
    
    func pixelExtend(_ extend: ExtendMode) -> Self {
        var pixel = self
        pixel.metadata[Key.extend.rawValue] = extend.rawValue
        return pixel
    }
}

struct PixelTransform_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelOffset(x: 100)
        }
    }
}
