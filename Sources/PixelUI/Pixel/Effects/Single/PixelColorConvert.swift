//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelColorConvert: Pixel {
    
    typealias Pix = ColorConvertPIX
    
    public let pixType: PIXType = .effect(.single(.colorConvert))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case conversion
        case channel
    }
    
    internal init(conversion: ColorConvertPIX.Conversion,
                  channel: ColorConvertPIX.Channel = .all,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .conversion:
                metadata[key.rawValue] = conversion.rawValue
            case .channel:
                metadata[key.rawValue] = channel.rawValue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .conversion:
            return pix.conversion.rawValue
        case .channel:
            return pix.channel.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .conversion:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.conversion)
            case .channel:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.channel)
            }
        }
    }
}

public extension Pixel {
    
    func pixelColorConvert(_ conversion: ColorConvertPIX.Conversion,
                           channel: ColorConvertPIX.Channel = .all) -> PixelColorConvert {
        PixelColorConvert(conversion: conversion, channel: channel, pixel: { self })
    }
}

struct PixelColorConvert_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCircle(radius: 100)
                .pixelColor(.orange)
                .pixelColorConvert(.rgbToHsv)
        }
    }
}
