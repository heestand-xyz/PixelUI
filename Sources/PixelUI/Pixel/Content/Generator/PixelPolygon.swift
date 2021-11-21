//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelPolygon: Pixel {
    
    typealias Pix = PolygonPIX
    
    public let pixType: PIXType = .content(.generator(.polygon))
    
    public var metadata: [String : PixelMetadata] = [:]
    
    public var pixelTree: PixelTree
    
    enum Key: String, CaseIterable {
        case count
        case radius
        case color
        case backgroundColor
    }
    
    public init(count: Int,
                radius: CGFloat = 0.5) {

        pixelTree = .content

        for key in Key.allCases {
            switch key {
            case .count:
                metadata[key.rawValue] = count
            case .radius:
                metadata[key.rawValue] = radius
            case .color, .backgroundColor:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }

        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .count:
            return pix.count
        case .radius:
            return pix.radius
        case .color:
            return pix.color
        case .backgroundColor:
            return pix.backgroundColor
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .count:
                Pixels.updateValue(pix: &pix, value: value, at: \.count)
            case .radius:
                Pixels.updateValue(pix: &pix, value: value, at: \.radius)
            case .color:
                Pixels.updateValue(pix: &pix, value: value, at: \.color)
            case .backgroundColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.backgroundColor)
            }
        }
    }
}

public extension PixelPolygon {
    
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
}

struct PixelPolygon_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelPolygon(count: 3)
        }
    }
}
