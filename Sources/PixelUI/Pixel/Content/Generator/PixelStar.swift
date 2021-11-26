//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelStar: Pixel {
    
    typealias Pix = StarPIX
    
    public let pixType: PIXType = .content(.generator(.star))
    
    public var metadata: [String : PixelMetadata] = [:]
    
    public let pixelTree: PixelTree = .content
    
    enum Key: String, CaseIterable {
        case count
        case leadingRadius
        case trailingRadius
        case position
        case rotation
        case cornerRadius
        case color
        case backgroundColor
    }
    
    public init(count: Int,
                radius leadingRadius: CGFloat,
                innerRadius trailingRadius: CGFloat? = nil) {

        for key in Key.allCases {
            switch key {
            case .count:
                metadata[key.rawValue] = count
            case .leadingRadius:
                metadata[key.rawValue] = leadingRadius
            case .trailingRadius:
                metadata[key.rawValue] = trailingRadius ?? leadingRadius / 2
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }

        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .count:
            return pix.count
        case .leadingRadius:
            return Pixels.inViewSpace(pix.leadingRadius, size: size)
        case .trailingRadius:
            return Pixels.inViewSpace(pix.trailingRadius, size: size)
        case .position:
            return Pixels.inZeroViewSpace(pix.position, size: size)
        case .rotation:
            return Pixels.asAngle(pix.rotation)
        case .cornerRadius:
            return Pixels.inViewSpace(pix.cornerRadius, size: size)
        case .color:
            return pix.color
        case .backgroundColor:
            return pix.backgroundColor
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
            
            guard let key = Key(rawValue: key) else { continue }
        
            switch key {
            case .count:
                Pixels.updateValue(pix: &pix, value: value, at: \.count)
            case .leadingRadius:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.leadingRadius)
            case .trailingRadius:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.trailingRadius)
            case .position:
                Pixels.updateValueInZeroPixelSpace(pix: &pix, value: value, size: size, at: \.position)
            case .rotation:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.rotation)
            case .cornerRadius:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.cornerRadius)
            case .color:
                Pixels.updateValue(pix: &pix, value: value, at: \.color)
            case .backgroundColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.backgroundColor)
            }
        }
    }
}

public extension PixelStar {
    
    func pixelOffset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> Self {
        var pixel = self
        pixel.metadata[Key.position.rawValue] = CGPoint(x: x, y: y)
        return pixel
    }
    
    func pixelRotation(_ angle: Angle) -> Self {
        var pixel = self
        pixel.metadata[Key.rotation.rawValue] = angle
        return pixel
    }
    
    func pixelCornerRadius(_ value: CGFloat) -> Self {
        var pixel = self
        pixel.metadata[Key.cornerRadius.rawValue] = value
        return pixel
    }
    
    func pixelColor(_ color: Color) -> Self {
        var pixel = self
        pixel.metadata[Key.color.rawValue] = PixelColor(color)
        return pixel
    }
    
    func pixelBackgroundColor(_ color: Color) -> Self {
        var pixel = self
        pixel.metadata[Key.backgroundColor.rawValue] = PixelColor(color)
        return pixel
    }
}

struct PixelStar_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelStar(count: 5, radius: 50)
        }
    }
}
