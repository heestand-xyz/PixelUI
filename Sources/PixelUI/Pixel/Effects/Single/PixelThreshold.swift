//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelThreshold: Pixel {
    
    typealias Pix = ThresholdPIX
    
    public let pixType: PIXType = .effect(.single(.threshold))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case threshold
    }
    
    internal init(at threshold: CGFloat = 0.5,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .threshold:
                metadata[key.rawValue] = threshold
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .threshold:
            return pix.threshold
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .threshold:
                Pixels.updateValue(pix: &pix, value: value, at: \.threshold)
            }
        }
    }
}

public extension Pixel {
    
    func pixelThreshold(at threshold: CGFloat = 0.5) -> PixelThreshold {
        PixelThreshold(at: threshold, pixel: { self })
    }
}

struct PixelThreshold_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelThreshold(at: 0.5)
        }
    }
}
