//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelReorder: Pixel {
    
    typealias Pix = ReorderPIX
    
    public let pixType: PIXType = .effect(.merger(.reorder))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case redInput
        case greenInput
        case blueInput
        case alphaInput
        case redChannel
        case greenChannel
        case blueChannel
        case alphaChannel
        case premultiply
    }
    
    public init(redInput: ReorderPIX.Input = .first,
                greenInput: ReorderPIX.Input = .first,
                blueInput: ReorderPIX.Input = .first,
                alphaInput: ReorderPIX.Input = .first,
                redChannel: ReorderPIX.Channel = .red,
                greenChannel: ReorderPIX.Channel = .green,
                blueChannel: ReorderPIX.Channel = .blue,
                alphaChannel: ReorderPIX.Channel = .alpha,
                premultiply: Bool = true,
                pixel leadingPixel: () -> Pixel,
                withPixel trailingPixel: () -> Pixel) {
        
        pixelTree = .mergerEffect(leadingPixel(), trailingPixel())
        
        for key in Key.allCases {
            switch key {
            case .redInput:
                metadata[key.rawValue] = redInput.rawValue
            case .greenInput:
                metadata[key.rawValue] = greenInput.rawValue
            case .blueInput:
                metadata[key.rawValue] = blueInput.rawValue
            case .alphaInput:
                metadata[key.rawValue] = alphaInput.rawValue
            case .redChannel:
                metadata[key.rawValue] = redChannel.rawValue
            case .greenChannel:
                metadata[key.rawValue] = greenChannel.rawValue
            case .blueChannel:
                metadata[key.rawValue] = blueChannel.rawValue
            case .alphaChannel:
                metadata[key.rawValue] = alphaChannel.rawValue
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .redInput:
            return pix.redInput.rawValue
        case .greenInput:
            return pix.greenInput.rawValue
        case .blueInput:
            return pix.blueInput.rawValue
        case .alphaInput:
            return pix.alphaInput.rawValue
        case .redChannel:
            return pix.redChannel.rawValue
        case .greenChannel:
            return pix.greenChannel.rawValue
        case .blueChannel:
            return pix.blueChannel.rawValue
        case .alphaChannel:
            return pix.alphaChannel.rawValue
        case .premultiply:
            return pix.premultiply
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .redInput:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.redInput)
            case .greenInput:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.greenInput)
            case .blueInput:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.blueInput)
            case .alphaInput:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.alphaInput)
            case .redChannel:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.redChannel)
            case .greenChannel:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.greenChannel)
            case .blueChannel:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.blueChannel)
            case .alphaChannel:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.alphaChannel)
            case .premultiply:
                Pixels.updateValue(pix: &pix, value: value, at: \.premultiply)
            }
        }
    }
}

struct PixelReorder_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelReorder(greenInput: .second) {
                PixelCircle(radius: 100)
            } withPixel: {
                PixelStar(count: 5, radius: 100)
            }
        }
    }
}
