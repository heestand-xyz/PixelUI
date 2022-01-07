//
//  Created by Anton Heestand on 2022-01-06.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelSlope: Pixel {
    
    typealias Pix = SlopePIX
    
    public let pixType: PIXType = .effect(.single(.slope))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case amplitude
    }
    
    internal init(amplitude: CGFloat,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .amplitude:
                metadata[key.rawValue] = amplitude
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .amplitude:
            return pix.amplitude
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .amplitude:
                Pixels.updateValue(pix: &pix, value: value, at: \.amplitude)
            }
        }
    }
}

public extension Pixel {
    
    func pixelSlope(amplitude: CGFloat) -> PixelSlope {
        PixelSlope(amplitude: amplitude, pixel: { self })
    }
}

struct PixelSlope_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelSlope(amplitude: 100.0)
        }
    }
}
