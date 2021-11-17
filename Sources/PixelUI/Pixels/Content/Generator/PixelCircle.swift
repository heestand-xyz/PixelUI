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
    
    public init(radius: CGFloat = 0.25) {
        metadata = ["radius": radius]
        pixelTree = .content
    }
}

struct PixelCircle_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelCircle(radius: 0.25)
        }
    }
}
