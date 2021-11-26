//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelDelay: Pixel {
    
    typealias Pix = DelayPIX
    
    public let pixType: PIXType = .effect(.single(.delay))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case delayFrames
    }
    
    internal init(frameCount delayFrames: Int,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .delayFrames:
                metadata[key.rawValue] = delayFrames
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .delayFrames:
            return pix.delayFrames
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .delayFrames:
                Pixels.updateValue(pix: &pix, value: value, at: \.delayFrames)
            }
        }
    }
}

public extension Pixel {
    
    func pixelDelay(frameCount: Int) -> PixelDelay {
        PixelDelay(frameCount: frameCount, pixel: { self })
    }
}

struct PixelDelay_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelDelay(frameCount: 100)
        }
    }
}
