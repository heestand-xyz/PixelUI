//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelFreeze: Pixel {
    
    typealias Pix = FreezePIX
    
    public let pixType: PIXType = .effect(.single(.freeze))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case freeze
    }
    
    internal init(_ freeze: Bool,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .freeze:
                metadata[key.rawValue] = freeze
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .freeze:
            return pix.freeze
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .freeze:
                Pixels.updateValue(pix: &pix, value: value, at: \.freeze)
            }
        }
    }
}

public extension Pixel {
    
    func pixelFreeze(_ freeze: Bool) -> PixelFreeze {
        PixelFreeze(freeze, pixel: { self })
    }
}

struct PixelFreeze_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelFreeze(true)
        }
    }
}
