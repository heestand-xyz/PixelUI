//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelRectangle: Pixel {
    
    typealias Pix = RectanglePIX
    
    public let pixType: PIXType = .content(.generator(.rectangle))
    
    public let pixelTree: PixelTree = .content
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case size
        case position
        case cornerRadius
        case color
        case backgroundColor
    }
    
    public init(size: CGSize) {
    
        for key in Key.allCases {
            switch key {
            case .size:
                metadata[key.rawValue] = size
            case .position, .cornerRadius, .color, .backgroundColor:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .size:
            return Pixels.inViewSpace(pix.size, size: size)
        case .position:
            return Pixels.inViewSpace(pix.position, size: size)
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
            case .size:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.size)
            case .position:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.position)
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

public extension PixelRectangle {
    
    func pixelOffset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> Self {
        var pixel = self
        pixel.metadata[Key.position.rawValue] = CGPoint(x: x, y: y)
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

struct PixelRectangle_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelRectangle(size: CGSize(width: 100, height: 100))
        }
    }
}
