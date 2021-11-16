//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelCircle: Pixel {
    
    public var pixelTree: PixelTree
    
    let radius: CGFloat
    
    public init(radius: CGFloat = 0.25, resolution: Resolution? = nil) {
        
        pixelTree = .generator(.circle)
        
        self.radius = radius
    }
}

struct PixelCircle_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelCircle(radius: 0.25)
        }
    }
}
