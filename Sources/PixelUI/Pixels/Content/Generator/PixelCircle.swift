//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelCircle: Pixel, View {
    
    public var pixelTree: PixelTree
    
    @StateObject public var pix: PIX
    
//    private let resolution: Resolution?
    
    public init(resolution: Resolution? = nil) {
//        self.resolution = resolution
        let pixelTree: PixelTree = .generator(.circle)
        self.pixelTree = pixelTree
        _pix = StateObject(wrappedValue: PixelBuilder.pix(for: pixelTree))
    }
}

struct PixelCircle_Previews: PreviewProvider {
    static var previews: some View {
        PixelCircle()
    }
}
