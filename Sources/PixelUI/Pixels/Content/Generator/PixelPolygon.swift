//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelPolygon: Pixel {
    
    public let pixType: PIXType = .content(.generator(.polygon))
    
    public var metadata: [String : PixelMetadata]
    
    public var pixelTree: PixelTree
    
    public init() {
        metadata = [:]
        pixelTree = .content
    }
}

struct PixelPolygon_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelPolygon()
        }
    }
}
