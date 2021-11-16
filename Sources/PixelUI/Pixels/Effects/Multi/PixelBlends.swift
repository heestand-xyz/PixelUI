//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import SwiftUI
import Resolution
import RenderKit
import PixelKit

public struct PixelBlends: Pixel, View {
    
    public var pixelTree: PixelTree
    
    @StateObject public var pix: PIX
    
    public init(@PixelBuilder pixels: () -> [Pixel]) {
        let pixelTree: PixelTree = .multiEffect(.blends, pixels().map(\.pixelTree))
        self.pixelTree = pixelTree
        _pix = StateObject(wrappedValue: PixelBuilder.pix(for: pixelTree))
    }
}

struct PixelBlends_Previews: PreviewProvider {
    static var previews: some View {
        PixelBlends {
            PixelCircle()
            PixelPolygon()
        }
    }
}
