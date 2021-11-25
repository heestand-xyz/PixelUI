//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelChannelMix: Pixel {
    
    typealias Pix = ChannelMixPIX
    
    public let pixType: PIXType = .effect(.single(.channelMix))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case red
        case green
        case blue
        case alpha
    }
    
    internal init(red: ChannelMixPIX.Channel = .red,
                  green: ChannelMixPIX.Channel = .green,
                  blue: ChannelMixPIX.Channel = .blue,
                  alpha: ChannelMixPIX.Channel = .alpha,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .red:
                metadata[key.rawValue] = red.rawValue
            case .green:
                metadata[key.rawValue] = green.rawValue
            case .blue:
                metadata[key.rawValue] = blue.rawValue
            case .alpha:
                metadata[key.rawValue] = alpha.rawValue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .red:
            return pix.red.rawValue
        case .green:
            return pix.green.rawValue
        case .blue:
            return pix.blue.rawValue
        case .alpha:
            return pix.alpha.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .red:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.red)
            case .green:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.green)
            case .blue:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.blue)
            case .alpha:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.alpha)
            }
        }
    }
}

public extension Pixel {
    
    func pixelChannelMix(red: ChannelMixPIX.Channel = .red,
                         green: ChannelMixPIX.Channel = .green,
                         blue: ChannelMixPIX.Channel = .blue,
                         alpha: ChannelMixPIX.Channel = .alpha) -> PixelChannelMix {
        PixelChannelMix(red: red, green: green, blue: blue, alpha: alpha, pixel: { self })
    }
}

struct PixelChannelMix_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCircle(radius: 100)
                .pixelChannelMix(red: .blue, blue: .red)
        }
    }
}
