//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelPolygon: Pixel {
    
    typealias Pix = PolygonPIX
    
    public let pixType: PIXType = .content(.generator(.polygon))
    
    public var metadata: [String : PixelMetadata]
    
    public var pixelTree: PixelTree
    
    enum Key: String {
        case count
    }
    
    public init(count: Int) {
        metadata = [
            Key.count.rawValue : count,
        ]
        pixelTree = .content
    }
    
    public func value(at key: String, pix: PIX) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }

        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .count:
            return pix.count
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX) {
        
        guard let pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .count:
                guard let value = value as? Int else { continue }
                pix.count = value
            }
        }
    }
}

struct PixelPolygon_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelPolygon(count: 3)
        }
    }
}
