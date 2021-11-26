//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelFlipFlop: Pixel {
    
    typealias Pix = FlipFlopPIX
    
    public let pixType: PIXType = .effect(.single(.flipFlop))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case flip
        case flop
    }
    
    internal init(flip: FlipFlopPIX.Flip = .none,
                  flop: FlipFlopPIX.Flop = .none,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .flip:
                metadata[key.rawValue] = flip.rawValue
            case .flop:
                metadata[key.rawValue] = flop.rawValue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .flip:
            return pix.flip.rawValue
        case .flop:
            return pix.flop.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .flip:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.flip)
            case .flop:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.flop)
            }
        }
    }
}

public extension Pixel {
    
    func pixelFlip(_ flip: FlipFlopPIX.Flip) -> PixelFlipFlop {
        PixelFlipFlop(flip: flip, pixel: { self })
    }
    
    func pixelFlop(_ flop: FlipFlopPIX.Flop) -> PixelFlipFlop {
        PixelFlipFlop(flop: flop, pixel: { self })
    }
}

struct PixelFlipFlop_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelImage("kite")
                .pixelFlip(.y)
        }
    }
}
