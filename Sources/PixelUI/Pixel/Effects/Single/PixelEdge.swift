//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelEdge: Pixel {
    
    typealias Pix = EdgePIX
    
    public let pixType: PIXType = .effect(.single(.edge))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case strength
        case distance
        case colored
        case transparent
        case includeAlpha
        case sobel
    }
    
    internal init(strength: CGFloat = 10.0,
                  distance: CGFloat = 1.0,
                  colored: Bool = false,
                  transparent: Bool = false,
                  includeAlpha: Bool = false,
                  sobel: Bool = false,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .strength:
                metadata[key.rawValue] = strength
            case .distance:
                metadata[key.rawValue] = distance
            case .colored:
                metadata[key.rawValue] = colored
            case .transparent:
                metadata[key.rawValue] = transparent
            case .includeAlpha:
                metadata[key.rawValue] = includeAlpha
            case .sobel:
                metadata[key.rawValue] = sobel
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .strength:
            return pix.strength
        case .distance:
            return pix.distance
        case .colored:
            return pix.colored
        case .transparent:
            return pix.transparent
        case .includeAlpha:
            return pix.includeAlpha
        case .sobel:
            return pix.sobel
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .strength:
                Pixels.updateValue(pix: &pix, value: value, at: \.strength)
            case .distance:
                Pixels.updateValue(pix: &pix, value: value, at: \.distance)
            case .colored:
                Pixels.updateValue(pix: &pix, value: value, at: \.colored)
            case .transparent:
                Pixels.updateValue(pix: &pix, value: value, at: \.transparent)
            case .includeAlpha:
                Pixels.updateValue(pix: &pix, value: value, at: \.includeAlpha)
            case .sobel:
                Pixels.updateValue(pix: &pix, value: value, at: \.sobel)
            }
        }
    }
}

public extension Pixel {
    
    func pixelEdge(strength: CGFloat = 10.0,
                   distance: CGFloat = 1.0,
                   colored: Bool = false,
                   transparent: Bool = false,
                   includeAlpha: Bool = false,
                   sobel: Bool = false) -> PixelEdge {
        PixelEdge(strength: strength,
                  distance: distance,
                  colored: colored,
                  transparent: transparent,
                  includeAlpha: includeAlpha,
                  sobel: sobel,
                  pixel: { self })
    }
}

struct PixelEdge_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCircle(radius: 100)
                .pixelEdge()
        }
    }
}
