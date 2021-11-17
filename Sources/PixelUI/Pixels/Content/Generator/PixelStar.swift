//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelStar: Pixel {
    
    public var pixelTree: PixelTree
        
    public init() {
        
        pixelTree = .generator(.star, [:])
    }
}

struct PixelStar_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelStar()
        }
    }
}
