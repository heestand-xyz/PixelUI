//
//  Created by Anton Heestand on 2021-11-16.
//

import Resolution
import RenderKit
import PixelKit

@resultBuilder
public struct PixelBuilder {
    
    public static func buildBlock(_ pixels: Pixel...) -> [Pixel] {
        pixels
    }
}
