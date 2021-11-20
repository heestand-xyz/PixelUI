//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelCircle: Pixel {
    
    public let pixType: PIXType = .content(.generator(.circle))
    
    public var pixelTree: PixelTree
    
    public let metadata: [String : PixelMetadata]
    
    enum Key: String {
        case radius
    }
    
    public init(radius: CGFloat = 0.5) {
        metadata = [
            Key.radius.rawValue : radius
        ]
        pixelTree = .content
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX) {
        
        guard let circlePix = pix as? CirclePIX else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .radius:
                guard let radius = value as? CGFloat else { continue }
                circlePix.radius = radius
                print("------> Circle Radius", radius)
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
