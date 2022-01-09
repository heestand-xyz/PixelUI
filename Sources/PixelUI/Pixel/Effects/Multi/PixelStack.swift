//
//  Created by Anton Heestand on 2022-01-09.
//

import Foundation
import SwiftUI
import Resolution
import RenderKit
import PixelKit
import PixelColor

public struct PixelStack: Pixel {
    
    typealias Pix = StackPIX
    
    public var pixType: PIXType = .effect(.multi(.stack))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case axis
        case alignment
        case spacing
        case padding
        case backgroundColor
    }
    
    public init(axis: StackPIX.Axis,
                alignment: StackPIX.Alignment = .center,
                spacing: CGFloat = 0.0,
                padding: CGFloat = 0.0,
                @PixelBuilder pixels: () -> [Pixel]) {

        pixelTree = .multiEffect(pixels())
        
        for key in Key.allCases {
            switch key {
            case .axis:
                metadata[key.rawValue] = axis.rawValue
            case .alignment:
                metadata[key.rawValue] = alignment.rawValue
            case .spacing:
                metadata[key.rawValue] = spacing
            case .padding:
                metadata[key.rawValue] = padding
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }

        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .axis:
            return pix.axis.rawValue
        case .alignment:
            return pix.alignment.rawValue
        case .spacing:
            return Pixels.inViewSpace(pix.spacing, size: size)
        case .padding:
            return Pixels.inViewSpace(pix.padding, size: size)
        case .backgroundColor:
            return pix.backgroundColor
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
            
            guard let key = Key(rawValue: key) else { continue }
        
            switch key {
            case .axis:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.axis)
            case .alignment:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.alignment)
            case .spacing:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.spacing)
            case .padding:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.padding)
            case .backgroundColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.backgroundColor)
            }
        }
    }
}

public extension PixelStack {
    
    func pixelBackgroundColor(_ color: Color) -> Self {
        var pixel = self
        pixel.metadata[Key.backgroundColor.rawValue] = PixelColor(color)
        return pixel
    }
}

struct PixelStack_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelStack(axis: .vertical) {
                PixelCircle(radius: 100)
                PixelPolygon(count: 3, radius: 100)
            }
        }
    }
}
