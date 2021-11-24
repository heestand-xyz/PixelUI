//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelBlur: Pixel {
    
    typealias Pix = BlurPIX
    
    static let maxSize: CGSize = Resolution._4K.size
    
    public let pixType: PIXType = .effect(.single(.blur))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case style
        case radius
        case angle
        case position
        case quality
    }
    
    internal init(style: Pix.BlurStyle = .default,
                  radius: CGFloat,
                  angle: Angle = .zero,
                  position: CGPoint = .zero,
                  quality: PIX.SampleQualityMode = .default,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .style:
                metadata[key.rawValue] = style.rawValue
            case .radius:
                metadata[key.rawValue] = radius
            case .angle:
                metadata[key.rawValue] = angle
            case .position:
                metadata[key.rawValue] = position
            case .quality:
                metadata[key.rawValue] = quality.rawValue
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
            return Pixels.inViewSpace(pix.radius, size: Self.maxSize)
        case .angle:
            return Pixels.asAngle(pix.angle)
        case .position:
            return Pixels.inViewZeroSpace(pix.position, size: size)
        case .quality:
            return pix.quality.rawValue
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
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: Self.maxSize, at: \.radius)
            case .angle:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.angle)
            case .position:
                Pixels.updateValueInPixelZeroSpace(pix: &pix, value: value, size: size, at: \.position)
            case .quality:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.quality)
            }
        }
    }
}

public extension Pixel {
    
    func pixelBlur(radius: CGFloat) -> PixelBlur {
        PixelBlur(style: .default, radius: radius, pixel: { self })
    }
    
    func pixelBoxBlur(radius: CGFloat) -> PixelBlur {
        PixelBlur(style: .box, radius: radius, pixel: { self })
    }
    
    func pixelAngleBlur(radius: CGFloat, angle: Angle) -> PixelBlur {
        PixelBlur(style: .angle, radius: radius, angle: angle, pixel: { self })
    }
    
    func pixelZoomBlur(radius: CGFloat, position: CGPoint = .zero) -> PixelBlur {
        PixelBlur(style: .zoom, radius: radius, position: position, pixel: { self })
    }
    
    func pixelRandomBlur(radius: CGFloat) -> PixelBlur {
        PixelBlur(style: .random, radius: radius, pixel: { self })
    }
}

struct PixelBlur_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCircle(radius: 100)
                .pixelBlur(radius: 0.1)
        }
    }
}
