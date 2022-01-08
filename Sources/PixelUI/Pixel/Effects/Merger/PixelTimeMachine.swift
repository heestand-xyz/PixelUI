//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelTimeMachine: Pixel {
    
    typealias Pix = TimeMachinePIX
    
    public let pixType: PIXType = .effect(.merger(.timeMachine))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case seconds
    }
    
    internal init(seconds: CGFloat,
                  pixel leadingPixel: () -> Pixel,
                  withPixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())
        
        for key in Key.allCases {
            switch key {
            case .seconds:
                metadata[key.rawValue] = seconds
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .seconds:
            return pix.seconds
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .seconds:
                Pixels.updateValue(pix: &pix, value: value, at: \.seconds)
            }
        }
    }
}

public extension Pixel {
    
    func pixelTimeMachine(seconds: CGFloat, pixel: () -> Pixel) -> PixelTimeMachine {
        PixelTimeMachine(seconds: seconds, pixel: { self }, withPixel: pixel)
    }
}

struct PixelTimeMachine_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelTimeMachine(seconds: 2.0) {
                    PixelGradient(axis: .vertical)
                }
        }
    }
}
