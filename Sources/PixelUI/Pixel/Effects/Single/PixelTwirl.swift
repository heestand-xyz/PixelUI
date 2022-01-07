//
//  Created by Anton Heestand on 2022-01-06.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelTwirl: Pixel {
    
    typealias Pix = TwirlPIX
    
    public let pixType: PIXType = .effect(.single(.twirl))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case strength
    }
    
    internal init(strength: CGFloat,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .strength:
                metadata[key.rawValue] = strength
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .strength:
            return pix.strength
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .strength:
                Pixels.updateValue(pix: &pix, value: value, at: \.strength)
            }
        }
    }
}

public extension Pixel {
    
    func pixelTwirl(_ strength: CGFloat) -> PixelTwirl {
        PixelTwirl(strength: strength, pixel: { self })
    }
}

struct PixelTwirl_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelTwirl(2.0)
        }
    }
}
