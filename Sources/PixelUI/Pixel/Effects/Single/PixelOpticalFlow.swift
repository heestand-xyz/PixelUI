//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelOpticalFlow: Pixel {
    
    typealias Pix = OpticalFlowPIX
    
    public let pixType: PIXType = .effect(.single(.opticalFlow))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    internal init(pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? { nil }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {}
}

public extension Pixel {
    
    func pixelOpticalFlow() -> PixelOpticalFlow {
        PixelOpticalFlow(pixel: { self })
    }
}

struct PixelOpticalFlow_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelOpticalFlow()
        }
    }
}
