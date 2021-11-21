//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelBlur: Pixel {
    
    public let pixType: PIXType = .effect(.single(.blur))
    
    public var pixelTree: PixelTree
    
    public let metadata: [String : PixelMetadata]
    
    enum Key: String {
        case style
        case radius
    }
    
    init(style: BlurPIX.BlurStyle = .default,
         radius: CGFloat,
         pixel: () -> (Pixel)) {
        metadata = [
            Key.style.rawValue : style.rawValue,
            Key.radius.rawValue : radius,
        ]
        pixelTree = .singleEffect(pixel())
    }
    
    public func value(at key: String, pix: PIX) -> PixelMetadata? {
        
        guard let pix = pix as? BlurPIX else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .style:
            return pix.style.rawValue
        case .radius:
            return pix.radius
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX) {
        
        guard let pix = pix as? BlurPIX else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .style:
                guard let rawValue = value as? String else { continue }
                guard let value = BlurPIX.BlurStyle(rawValue: rawValue) else { continue }
                pix.style = value
            case .radius:
                guard let value = value as? CGFloat else { continue }
                pix.radius = value
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
    
    func pixelAngleBlur(radius: CGFloat) -> PixelBlur {
        PixelBlur(style: .angle, radius: radius, pixel: { self })
    }
    
    func pixelZoomBlur(radius: CGFloat) -> PixelBlur {
        PixelBlur(style: .zoom, radius: radius, pixel: { self })
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
