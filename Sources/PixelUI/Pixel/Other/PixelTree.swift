//
//  Created by Anton Heestand on 2021-11-16.
//

import PixelKit
import CoreGraphics

public indirect enum PixelTree {
    
    case content
    
    case singleEffect(Pixel)
    case mergerEffect(Pixel, Pixel)
    case multiEffect([Pixel])
    
    case feedback(Pixel, Pixel)
    
    var pixels: [Pixel] {
        switch self {
        case .content:
            return []
        case .singleEffect(let pixel):
            return [pixel]
        case .mergerEffect(let pixelA, let pixelB):
            return [pixelA, pixelB]
        case .multiEffect(let pixels):
            return pixels
        case .feedback(let pixelA, let pixelB):
            return [pixelA, pixelB]
        }
    }
}
