//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelConvert: Pixel {
    
    typealias Pix = ConvertPIX
    
    public let pixType: PIXType = .effect(.single(.convert))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case mode
    }
    
    internal init(_ mode: ConvertPIX.ConvertMode,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .mode:
                metadata[key.rawValue] = mode.rawValue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .mode:
            return pix.mode.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .mode:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.mode)
            }
        }
    }
}

public extension Pixel {
    
    func pixelConvert(_ mode: ConvertPIX.ConvertMode) -> PixelConvert {
        PixelConvert(mode, pixel: { self })
    }
}

struct PixelConvert_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelImage("kite")
                .pixelConvert(.squareToCircle)
        }
    }
}
