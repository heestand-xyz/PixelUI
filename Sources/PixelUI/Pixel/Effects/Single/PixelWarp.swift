//
//  Created by Anton Heestand on 2022-01-06.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelWarp: Pixel {
    
    typealias Pix = WarpPIX
    
    public let pixType: PIXType = .effect(.single(.warp))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case style
        case position
        case radius
        case scale
        case rotation
    }
    
    internal init(style: WarpPIX.Style,
                  offset position: CGPoint,
                  radius: CGFloat,
                  scale: CGFloat,
                  angle rotation: Angle,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .style:
                metadata[key.rawValue] = style.rawValue
            case .position:
                metadata[key.rawValue] = position
            case .radius:
                metadata[key.rawValue] = radius
            case .scale:
                metadata[key.rawValue] = scale
            case .rotation:
                metadata[key.rawValue] = rotation
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .style:
            return pix.style.rawValue
        case .position:
            return Pixels.inZeroViewSpace(pix.position, size: size)
        case .radius:
            return Pixels.inViewSpace(pix.radius, size: size)
        case .scale:
            return pix.scale
        case .rotation:
            return Pixels.asAngle(pix.rotation)
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .style:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.style)
            case .position:
                Pixels.updateValueInZeroPixelSpace(pix: &pix, value: value, size: size, at: \.position)
            case .radius:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.radius)
            case .scale:
                Pixels.updateValue(pix: &pix, value: value, at: \.scale)
            case .rotation:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.rotation)
            }
        }
    }
}

public extension Pixel {
    
    func pixelWarp(as style: WarpPIX.Style, offset: CGPoint = .zero, radius: CGFloat, scale: CGFloat = 1.0, angle: Angle = .zero) -> PixelWarp {
        PixelWarp(style: style, offset: offset, radius: radius, scale: scale, angle: angle, pixel: { self })
    }
}

struct PixelWarp_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelWarp(as: .tunnel, radius: 100)
        }
    }
}
