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
    
    public init() {
        metadata = [:]
        pixelTree = .content
    }
}

struct PixelStar_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelStar()
        }
    }
}
