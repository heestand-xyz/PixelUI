//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelColorCorrect: Pixel {
    
    typealias Pix = ColorCorrectPIX
    
    public let pixType: PIXType = .effect(.single(.colorCorrect))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case whitePoint
        case vibrance
        case temperature
    }
    
    internal init(whitePoint: Color = .white,
                  vibrance: CGFloat = 0.0,
                  temperature: CGFloat = 0.0,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .whitePoint:
                metadata[key.rawValue] = PixelColor(whitePoint)
            case .vibrance:
                metadata[key.rawValue] = vibrance
            case .temperature:
                metadata[key.rawValue] = temperature
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .whitePoint:
            return pix.whitePoint
        case .vibrance:
            return pix.vibrance
        case .temperature:
            return pix.temperature
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .whitePoint:
                Pixels.updateValue(pix: &pix, value: value, at: \.whitePoint)
            case .vibrance:
                Pixels.updateValue(pix: &pix, value: value, at: \.vibrance)
            case .temperature:
                Pixels.updateValue(pix: &pix, value: value, at: \.temperature)
            }
        }
    }
}

public extension Pixel {
    
    /// Pixel Color Correct
    /// - Parameters:
    ///   - whitePoint: The color white should be.
    ///   - vibrance: Saturation between `0.0` and `1.0`.
    ///   - temperature: Cold is `-1.0`, neutral is `0.0` and warm is `1.0`,
    func pixelColorCorrect(whitePoint: Color = .white,
                           vibrance: CGFloat = 0.0,
                           temperature: CGFloat = 0.0) -> PixelColorCorrect {
        PixelColorCorrect(whitePoint: whitePoint, vibrance: vibrance, temperature: temperature, pixel: { self })
    }
}

struct PixelColorCorrect_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelImage("kite")
                .pixelColorCorrect(vibrance: 0.5, temperature: 0.5)
        }
    }
}
