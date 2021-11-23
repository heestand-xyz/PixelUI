//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelLine: Pixel {
    
    typealias Pix = LinePIX
    
    public let pixType: PIXType = .content(.generator(.line))
    
    public let pixelTree: PixelTree = .content
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case positionFrom
        case positionTo
        case lineWidth
        case color
        case backgroundColor
    }
    
    public init(from positionFrom: CGPoint,
                to positionTo: CGPoint,
                lineWidth: CGFloat = 1) {

        for key in Key.allCases {
            switch key {
            case .positionFrom:
                metadata[key.rawValue] = positionFrom
            case .positionTo:
                metadata[key.rawValue] = positionTo
            case .lineWidth:
                metadata[key.rawValue] = lineWidth
            case .color, .backgroundColor:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .positionFrom:
            return Pixels.inViewSpace(pix.positionFrom, size: size)
        case .positionTo:
            return Pixels.inViewSpace(pix.positionTo, size: size)
        case .lineWidth:
            return Pixels.inViewSpace(pix.lineWidth, size: size)
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
            case .positionFrom:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.positionFrom)
            case .positionTo:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.positionTo)
            case .lineWidth:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.lineWidth)
            case .color:
                Pixels.updateValue(pix: &pix, value: value, at: \.color)
            case .backgroundColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.backgroundColor)
            }
        }
    }
}

public extension PixelLine {
    
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

struct PixelLine_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometryProxy in
            Pixels {
                PixelLine(from: CGPoint(x: 0, y: geometryProxy.size.height / 2),
                          to: CGPoint(x: geometryProxy.size.width, y: geometryProxy.size.height / 2))
            }
        }
    }
}
