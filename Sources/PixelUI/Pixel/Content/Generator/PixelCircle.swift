//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelCircle: Pixel {
    
    typealias Pix = CirclePIX
    
    public let pixType: PIXType = .content(.generator(.circle))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case radius
        case position
        case color
        case backgroundColor
        case edgeRadius
        case edgeColor
    }
    
    public init(radius: CGFloat) {

        pixelTree = .content
        
        for key in Key.allCases {
            switch key {
            case .radius:
                metadata[key.rawValue] = radius
            case .position, .color, .backgroundColor, .edgeRadius, .edgeColor:
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
            return Pixels.inViewSpace(pix.position, size: size)
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
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.position)
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

public extension PixelCircle {
    
    func pixelOffset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> Self {
        var pixel = self
        pixel.metadata[Key.position.rawValue] = CGPoint(x: x, y: y)
        return pixel
    }
    
    func pixelColor(_ color: PixelColor) -> Self {
        var pixel = self
        pixel.metadata[Key.color.rawValue] = color
        return pixel
    }
    
    func pixelBackgroundColor(_ color: PixelColor) -> Self {
        var pixel = self
        pixel.metadata[Key.backgroundColor.rawValue] = color
        return pixel
    }
    
    func pixelEdge(radius: CGFloat, color: PixelColor) -> Self {
        var pixel = self
        pixel.metadata[Key.edgeRadius.rawValue] = radius
        pixel.metadata[Key.edgeColor.rawValue] = color
        return pixel
    }
}

struct PixelCircle_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelCircle(radius: 0.25)
        }
    }
}
