//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelCircle: Pixel {
    
    typealias Pix = CirclePIX
    
    public let pixType: PIXType = .content(.generator(.circle))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case radius
    }
    
    public init(radius: CGFloat = 0.5) {

        pixelTree = .content
        
        for key in Key.allCases {
            switch key {
            case .radius:
                metadata[key.rawValue] = radius
            }
        }
    }
    
    public func value(at key: String, pix: PIX) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .radius:
            return pix.radius
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .radius:
                Pixels.updateValue(pix: &pix, value: value, at: \.radius)
            }
        }
    }
}

struct PixelCircle_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelCircle(radius: 0.25)
        }
    }
}
