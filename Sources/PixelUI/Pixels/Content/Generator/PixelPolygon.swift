//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelPolygon: Pixel {
    
    public var pixelTree: PixelTree
    
    public init() {
        pixelTree = .generator(.polygon)
    }
}

struct PixelPolygon_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelPolygon()
        }
    }
}
