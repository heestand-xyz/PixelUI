//
//  Created by Anton Heestand on 2021-11-16.
//

import PixelKit

@resultBuilder
public struct PixelBuilder {
        
    static func pix(for pixelTree: PixelTree) -> PIX {
        StarPIX()
    }
    
    public static func buildBlock(_ pixels: Pixel...) -> [Pixel] {
        pixels
    }
}
