//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import SwiftUI
import Resolution
import RenderKit
import PixelKit

public struct PixelBlends: Pixel {
    
    public var pixelTree: PixelTree
        
    public init(@PixelBuilder pixels: () -> [Pixel]) {
        
        pixelTree = .multiEffect(.blends, [:], pixels().map(\.pixelTree))
    }
}

struct PixelBlends_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelBlends {
                PixelCircle()
                PixelPolygon()
            }
        }
    }
}
