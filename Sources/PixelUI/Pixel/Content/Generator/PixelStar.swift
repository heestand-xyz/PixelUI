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
    
    public var pixelTree: PixelTree
    
    enum Key: String, CaseIterable {
        case count
        case leadingRadius
        case trailingRadius
        case color
        case backgroundColor
    }
    
    public init(count: Int,
                leadingRadius: CGFloat = 0.5,
                trailingRadius: CGFloat = 0.25) {

        pixelTree = .content

        for key in Key.allCases {
            switch key {
            case .count:
                metadata[key.rawValue] = count
            case .leadingRadius:
                metadata[key.rawValue] = leadingRadius
            case .trailingRadius:
                metadata[key.rawValue] = trailingRadius
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
        case .leadingRadius:
            return pix.leadingRadius
        case .trailingRadius:
            return pix.trailingRadius
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
            case .leadingRadius:
                Pixels.updateValue(pix: &pix, value: value, at: \.leadingRadius)
            case .trailingRadius:
                Pixels.updateValue(pix: &pix, value: value, at: \.trailingRadius)
            case .color:
                Pixels.updateValue(pix: &pix, value: value, at: \.color)
            case .backgroundColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.backgroundColor)
            }
        }
    }
}

public extension PixelStar {
    
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

struct PixelStar_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelStar(count: 5)
        }
    }
}
