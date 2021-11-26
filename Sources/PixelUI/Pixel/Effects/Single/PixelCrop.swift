//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelCrop: Pixel {
    
    typealias Pix = CropPIX
    
    public let pixType: PIXType = .effect(.single(.crop))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case cropLeft
        case cropRight
        case cropBottom
        case cropTop
    }
    
    internal init(left cropLeft: CGFloat = 0.0,
                  right cropRight: CGFloat = 0.0,
                  bottom cropBottom: CGFloat = 0.0,
                  top cropTop: CGFloat = 0.0,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .cropLeft:
                metadata[key.rawValue] = cropLeft
            case .cropRight:
                metadata[key.rawValue] = cropRight
            case .cropBottom:
                metadata[key.rawValue] = cropBottom
            case .cropTop:
                metadata[key.rawValue] = cropTop
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .cropLeft:
            return Pixels.inNormalizedLeftPixelSpace(pix.cropLeft, size: size)
        case .cropRight:
            return Pixels.inNormalizedRightPixelSpace(pix.cropRight, size: size)
        case .cropBottom:
            return Pixels.inNormalizedBottomPixelSpace(pix.cropBottom, size: size)
        case .cropTop:
            return Pixels.inNormalizedTopPixelSpace(pix.cropTop, size: size)
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .cropLeft:
                Pixels.updateValueInNormalizedLeftPixelSpace(pix: &pix, value: value, size: size, at: \.cropLeft)
            case .cropRight:
                Pixels.updateValueInNormalizedRightPixelSpace(pix: &pix, value: value, size: size, at: \.cropRight)
            case .cropBottom:
                Pixels.updateValueInNormalizedBottomPixelSpace(pix: &pix, value: value, size: size, at: \.cropBottom)
            case .cropTop:
                Pixels.updateValueInNormalizedTopPixelSpace(pix: &pix, value: value, size: size, at: \.cropTop)
            }
        }
    }
}

public extension Pixel {
    
    /// Pixel Crop
    ///
    /// Crop values are relative to the side with positive values
    func pixelCrop(left: CGFloat = 0.0,
                   right: CGFloat = 0.0,
                   bottom: CGFloat = 0.0,
                   top: CGFloat = 0.0) -> PixelCrop {
        PixelCrop(left: left,
                  right: right,
                  bottom: bottom,
                  top: top,
                  pixel: { self })
    }
}

struct PixelCrop_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelImage("kite")
                .pixelCrop(left: 100)
        }
    }
}
