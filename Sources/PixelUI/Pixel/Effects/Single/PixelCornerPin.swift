//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelCornerPin: Pixel {
    
    typealias Pix = CornerPinPIX
    
    public let pixType: PIXType = .effect(.single(.cornerPin))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        case perspective
        case subdivisions
    }
    
    internal init(topLeft: CGPoint,
                  topRight: CGPoint,
                  bottomLeft: CGPoint,
                  bottomRight: CGPoint,
                  perspective: Bool = false,
                  subdivisions: Int = 16,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .topLeft:
                metadata[key.rawValue] = topLeft
            case .topRight:
                metadata[key.rawValue] = topRight
            case .bottomLeft:
                metadata[key.rawValue] = bottomLeft
            case .bottomRight:
                metadata[key.rawValue] = bottomRight
            case .perspective:
                metadata[key.rawValue] = perspective
            case .subdivisions:
                metadata[key.rawValue] = subdivisions
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .topLeft:
            return Pixels.inNormalizedViewSpace(pix.topLeft, size: size)
        case .topRight:
            return Pixels.inNormalizedViewSpace(pix.topRight, size: size)
        case .bottomLeft:
            return Pixels.inNormalizedViewSpace(pix.bottomLeft, size: size)
        case .bottomRight:
            return Pixels.inNormalizedViewSpace(pix.bottomRight, size: size)
        case .perspective:
            return pix.perspective
        case .subdivisions:
            return pix.subdivisions
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .topLeft:
                Pixels.updateValueInNormalizedPixelSpace(pix: &pix, value: value, size: size, at: \.topLeft)
            case .topRight:
                Pixels.updateValueInNormalizedPixelSpace(pix: &pix, value: value, size: size, at: \.topRight)
            case .bottomLeft:
                Pixels.updateValueInNormalizedPixelSpace(pix: &pix, value: value, size: size, at: \.bottomLeft)
            case .bottomRight:
                Pixels.updateValueInNormalizedPixelSpace(pix: &pix, value: value, size: size, at: \.bottomRight)
            case .perspective:
                Pixels.updateValue(pix: &pix, value: value, at: \.perspective)
            case .subdivisions:
                Pixels.updateValue(pix: &pix, value: value, at: \.subdivisions)
            }
        }
    }
}

public extension Pixel {
    
    func pixelCornerPin(topLeft: CGPoint,
                        topRight: CGPoint,
                        bottomLeft: CGPoint,
                        bottomRight: CGPoint,
                        perspective: Bool = false,
                        subdivisions: Int = 16) -> PixelCornerPin {
        PixelCornerPin(topLeft: topLeft,
                       topRight: topRight,
                       bottomLeft: bottomLeft,
                       bottomRight: bottomRight,
                       perspective: perspective,
                       subdivisions: subdivisions,
                       pixel: { self })
    }
}

struct PixelCornerPin_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            Pixels {
                PixelImage("kite")
                    .pixelCornerPin(topLeft: CGPoint(x: 100, y: 100), topRight: CGPoint(x: geo.size.width, y: 0.0), bottomLeft: CGPoint(x: 0.0, y: geo.size.height), bottomRight: CGPoint(x: geo.size.width, y: geo.size.height))
            }
        }
    }
}
