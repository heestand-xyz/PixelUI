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
    
    public let pixType: PIXType = .effect(.single(.blur))
    
    public var pixelTree: PixelTree
    
    public let metadata: [String : PixelMetadata]
    
    enum Key: String {
        case style
        case radius
        case angle
        case position
        case quality
    }
    
    init(style: Pix.BlurStyle = .default,
         radius: CGFloat,
         angle: Angle = .zero,
         position: CGPoint = .zero,
         quality: PIX.SampleQualityMode = .default,
         pixel: () -> (Pixel)) {
        metadata = [
            Key.style.rawValue : style.rawValue,
            Key.radius.rawValue : radius,
            Key.angle.rawValue : angle,
            Key.position.rawValue : position,
            Key.quality.rawValue : quality.rawValue,
        ]
        pixelTree = .singleEffect(pixel())
    }
    
    public func value(at key: String, pix: PIX) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .style:
            return pix.style.rawValue
        case .radius:
            return pix.radius
        case .angle:
            return Angle(degrees: pix.angle * 360)
        case .position:
            return pix.position
        case .quality:
            return pix.quality.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX) {
        
        guard let pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .style:
                guard let rawValue = value as? String else { continue }
                guard let value = Pix.BlurStyle(rawValue: rawValue) else { continue }
                pix.style = value
            case .radius:
                guard let value = value as? CGFloat else { continue }
                pix.radius = value
            case .angle:
                guard let value = value as? Angle else { continue }
                pix.angle = value.degrees / 360
            case .position:
                guard let value = value as? CGPoint else { continue }
                pix.position = value
            case .quality:
                guard let rawValue = value as? Int else { continue }
                guard let value = PIX.SampleQualityMode(rawValue: rawValue) else { continue }
                pix.quality = value
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
        Pixels(resolution: ._1024) {
            PixelCircle()
                .pixelBlur(radius: 0.1)
        }
    }
}
