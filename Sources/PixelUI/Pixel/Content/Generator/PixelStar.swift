//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelStar: Pixel {
    
    public let pixType: PIXType = .content(.generator(.star))
    
    public var metadata: [String : PixelMetadata]
    
    public var pixelTree: PixelTree
    
    enum Key: String {
        case count
    }
    
    public init(count: Int) {
        metadata = [
            Key.count.rawValue : count
        ]
        pixelTree = .content
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX) {
        
        guard let starPix = pix as? StarPIX else { return }
        
        for (key, value) in metadata {
            
            guard let key = Key(rawValue: key) else { continue }
        
            switch key {
            case .count:
                guard let count = value as? Int else { continue }
                starPix.count = count
                print("------> Star Count", count)
            }
        }
    }
}

struct PixelStar_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelStar(count: 5)
        }
    }
}
