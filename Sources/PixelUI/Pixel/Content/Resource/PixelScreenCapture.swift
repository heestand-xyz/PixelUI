//
//  Created by Anton Heestand on 2021-11-22.
//

#if os(macOS) && !targetEnvironment(macCatalyst)

import Foundation
import SwiftUI
import RenderKit
import PixelKit
import PixelColor

public struct PixelScreenCapture: Pixel {
    
    typealias Pix = ScreenCapturePIX
    
    public let pixType: PIXType = .content(.resource(.screenCapture))
    
    public let pixelTree: PixelTree = .content
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case screenIndex
    }
    
    public init() {}
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .screenIndex:
            return pix.screenIndex
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .screenIndex:
                Pixels.updateValue(pix: &pix, value: value, at: \.screenIndex)
            }
        }
    }
}

public extension PixelScreenCapture {
    
    func pixelScreenCaptureIndex(_ index: Int) -> Self {
        var pixel = self
        pixel.metadata[Key.screenIndex.rawValue] = index
        return pixel
    }
}

struct PixelScreenCapture_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelScreenCapture()
        }
    }
}

#endif
