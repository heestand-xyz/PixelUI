//
//  Created by Anton Heestand on 2021-11-16.
//

import SwiftUI
import PixelKit

public protocol Pixel {
    
    var pixType: PIXType { get }
    var pixelTree: PixelTree { get }
    
    var metadata: [String: PixelMetadata] { get set }
    
    func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata?
    func update(metadata: [String: PixelMetadata], pix: PIX, size: CGSize)
}
