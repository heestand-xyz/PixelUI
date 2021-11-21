//
//  Created by Anton Heestand on 2021-11-16.
//

import SwiftUI
import Resolution
import PixelKit

public struct Pixels: View {
    
    let resolution: Resolution
    let pixel: () -> Pixel
    
    public init(resolution: Resolution, pixel: @escaping () -> Pixel) {
        self.resolution = resolution
        self.pixel = pixel
    }
    
    public var body: some View {
        GeometryReader { geometryProxy in
            PixelsView(resolution: resolution, size: geometryProxy.size, pixel: pixel)
        }
    }
}
