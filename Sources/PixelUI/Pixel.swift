//
//  Created by Anton Heestand on 2021-11-16.
//

import SwiftUI
import PixelKit

public protocol Pixel {
    
    var pixelTree: PixelTree { get }
    
    var pix: PIX { get }    
}

extension Pixel {
    
    public var body: some View {
        PixelView(pix: pix)
    }
}
