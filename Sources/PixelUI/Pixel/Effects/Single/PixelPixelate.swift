//
//  Created by Anton Heestand on 2022-01-06.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelPixelate: Pixel {
    
    typealias Pix = PixelatePIX
    
    public let pixType: PIXType = .effect(.single(.pixelate))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case style
        case position
        case radius
    }
    
    internal init(style: PixelatePIX.Style,
                  position: CGPoint,
                  radius: CGFloat,
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
            return pix.radius
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
                Pixels.updateValue(pix: &pix, value: value, at: \.radius)
            }
        }
    }
}

public extension Pixel {
    
    func pixelPixelate(style: PixelatePIX.Style = .pixel, position: CGPoint = .zero, radius: CGFloat = 10) -> PixelPixelate {
        PixelPixelate(style: style, position: position, radius: radius, pixel: { self })
    }
}

struct PixelPixelate_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelPixelate()
        }
    }
}
