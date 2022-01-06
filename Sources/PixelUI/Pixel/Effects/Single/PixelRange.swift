//
//  Created by Anton Heestand on 2022-01-06.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelRange: Pixel {
    
    typealias Pix = RangePIX
    
    public let pixType: PIXType = .effect(.single(.range))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case inLow
        case inHigh
        case outLow
        case outHigh
        case inLowColor
        case inHighColor
        case outLowColor
        case outHighColor
        case ignoreAlpha
    }
    
    internal init(inLow: CGFloat = 0.0,
                  inHigh: CGFloat = 1.0,
                  outLow: CGFloat = 0.0,
                  outHigh: CGFloat = 1.0,
                  inLowColor: PixelColor = .clear,
                  inHighColor: PixelColor = .white,
                  outLowColor: PixelColor = .clear,
                  outHighColor: PixelColor = .white,
                  ignoreAlpha: Bool = true,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .inLow:
                metadata[key.rawValue] = inLow
            case .inHigh:
                metadata[key.rawValue] = inHigh
            case .outLow:
                metadata[key.rawValue] = outLow
            case .outHigh:
                metadata[key.rawValue] = outHigh
            case .inLowColor:
                metadata[key.rawValue] = inLowColor
            case .inHighColor:
                metadata[key.rawValue] = inHighColor
            case .outLowColor:
                metadata[key.rawValue] = outLowColor
            case .outHighColor:
                metadata[key.rawValue] = outHighColor
            case .ignoreAlpha:
                metadata[key.rawValue] = ignoreAlpha
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .inLow:
            return pix.inLow
        case .inHigh:
            return pix.inHigh
        case .outLow:
            return pix.outLow
        case .outHigh:
            return pix.outHigh
        case .inLowColor:
            return pix.inLowColor
        case .inHighColor:
            return pix.inHighColor
        case .outLowColor:
            return pix.outLowColor
        case .outHighColor:
            return pix.outHighColor
        case .ignoreAlpha:
            return pix.ignoreAlpha
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .inLow:
                Pixels.updateValue(pix: &pix, value: value, at: \.inLow)
            case .inHigh:
                Pixels.updateValue(pix: &pix, value: value, at: \.inHigh)
            case .outLow:
                Pixels.updateValue(pix: &pix, value: value, at: \.outLow)
            case .outHigh:
                Pixels.updateValue(pix: &pix, value: value, at: \.outHigh)
            case .inLowColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.inLowColor)
            case .inHighColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.inHighColor)
            case .outLowColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.outLowColor)
            case .outHighColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.outHighColor)
            case .ignoreAlpha:
                Pixels.updateValue(pix: &pix, value: value, at: \.ignoreAlpha)
            }
        }
    }
}

public extension Pixel {
    
    func pixelRange(inLow: CGFloat = 0.0, inHigh: CGFloat = 1.0, outLow: CGFloat = 0.0, outHigh: CGFloat = 1.0, ignoreAlpha: Bool = true) -> PixelRange {
        PixelRange(inLow: inLow, inHigh: inHigh, outLow: outLow, outHigh: outHigh, ignoreAlpha: ignoreAlpha, pixel: { self })
    }
    
    func pixelRangeColor(inLow: Color = .clear, inHigh: Color = .white, outLow: Color = .clear, outHigh: Color = .white, ignoreAlpha: Bool = true) -> PixelRange {
        PixelRange(inLowColor: PixelColor(inLow), inHighColor: PixelColor(inHigh), outLowColor: PixelColor(outLow), outHighColor: PixelColor(outHigh), ignoreAlpha: ignoreAlpha, pixel: { self })
    }
}

struct PixelRange_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelRange(inLow: 0.25, inHigh: 0.75)
        }
    }
}
