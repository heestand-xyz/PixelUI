//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import SwiftUI
import CoreGraphicsExtensions
import PixelKit
import Resolution
import PixelColor

public struct PixelArc: Pixel {
    
    typealias Pix = ArcPIX
    
    public let pixType: PIXType = .content(.generator(.arc))
    
    public let pixelTree: PixelTree = .content
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case radius
        case position
        case angleFrom
        case angleTo
        case angleOffset
        case color
        case backgroundColor
        case edgeRadius
        case edgeColor
    }
    
    public init(radius: CGFloat,
                leadingAngle angleFrom: Angle,
                tralingAngle angleTo: Angle) {

        for key in Key.allCases {
            switch key {
            case .radius:
                metadata[key.rawValue] = radius
            case .angleFrom:
                metadata[key.rawValue] = angleFrom
            case .angleTo:
                metadata[key.rawValue] = angleTo
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .radius:
            return Pixels.inViewSpace(pix.radius, size: size)
        case .position:
            return Pixels.inViewZeroSpace(pix.position, size: size)
        case .angleFrom:
            return Pixels.asAngle(pix.angleFrom)
        case .angleTo:
            return Pixels.asAngle(pix.angleTo)
        case .angleOffset:
            return Pixels.asAngle(pix.angleOffset)
        case .color:
            return pix.color
        case .backgroundColor:
            return pix.backgroundColor
        case .edgeRadius:
            return Pixels.inViewSpace(pix.edgeRadius, size: size)
        case .edgeColor:
            return pix.edgeColor
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .radius:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.radius)
            case .position:
                Pixels.updateValueInPixelZeroSpace(pix: &pix, value: value, size: size, at: \.position)
            case .angleFrom:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.angleFrom)
            case .angleTo:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.angleTo)
            case .angleOffset:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.angleOffset)
            case .color:
                Pixels.updateValue(pix: &pix, value: value, at: \.color)
            case .backgroundColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.backgroundColor)
            case .edgeRadius:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.edgeRadius)
            case .edgeColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.edgeColor)
            }
        }
    }
}

public extension PixelArc {
    
    func pixelOffset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> Self {
        var pixel = self
        pixel.metadata[Key.position.rawValue] = CGPoint(x: x, y: y)
        return pixel
    }
    
    func pixelRotation(_ angle: Angle) -> Self {
        var pixel = self
        pixel.metadata[Key.angleOffset.rawValue] = angle
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
    
    func pixelEdge(radius: CGFloat, color: Color) -> Self {
        var pixel = self
        pixel.metadata[Key.edgeRadius.rawValue] = radius
        pixel.metadata[Key.edgeColor.rawValue] = PixelColor(color)
        return pixel
    }
}

struct PixelArc_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelArc(radius: 50, leadingAngle: .zero, tralingAngle: Angle(degrees: 90))
        }
    }
}
