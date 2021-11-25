//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelChromaKey: Pixel {
    
    typealias Pix = ChromaKeyPIX
    
    public let pixType: PIXType = .effect(.single(.chromaKey))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case keyColor
        case range
        case softness
        case edgeDesaturation
        case alphaCrop
        case premultiply
    }
    
    internal init(color keyColor: Color,
                  range: CGFloat = 0.1,
                  softness: CGFloat = 0.1,
                  edgeDesaturation: CGFloat = 0.5,
                  alphaCrop: CGFloat = 0.5,
                  premultiply: Bool = true,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .keyColor:
                metadata[key.rawValue] = PixelColor(keyColor)
            case .range:
                metadata[key.rawValue] = range
            case .softness:
                metadata[key.rawValue] = softness
            case .edgeDesaturation:
                metadata[key.rawValue] = edgeDesaturation
            case .alphaCrop:
                metadata[key.rawValue] = alphaCrop
            case .premultiply:
                metadata[key.rawValue] = premultiply
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .keyColor:
            return pix.keyColor
        case .range:
            return pix.range
        case .softness:
            return pix.softness
        case .edgeDesaturation:
            return pix.edgeDesaturation
        case .alphaCrop:
            return pix.alphaCrop
        case .premultiply:
            return pix.premultiply
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .keyColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.keyColor)
            case .range:
                Pixels.updateValue(pix: &pix, value: value, at: \.range)
            case .softness:
                Pixels.updateValue(pix: &pix, value: value, at: \.softness)
            case .edgeDesaturation:
                Pixels.updateValue(pix: &pix, value: value, at: \.edgeDesaturation)
            case .alphaCrop:
                Pixels.updateValue(pix: &pix, value: value, at: \.alphaCrop)
            case .premultiply:
                Pixels.updateValue(pix: &pix, value: value, at: \.premultiply)
            }
        }
    }
}

public extension Pixel {
    
    func pixelChromaKey(color: Color,
                        range: CGFloat = 0.1,
                        softness: CGFloat = 0.1,
                        edgeDesaturation: CGFloat = 0.5,
                        alphaCrop: CGFloat = 0.5,
                        premultiply: Bool = true) -> PixelChromaKey {
        PixelChromaKey(color: color, range: range, softness: softness, edgeDesaturation: edgeDesaturation, alphaCrop: alphaCrop, premultiply: premultiply, pixel: { self })
    }
}

struct PixelChromaKey_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelImage("kite")
                .pixelChromaKey(color: .green)
        }
    }
}
