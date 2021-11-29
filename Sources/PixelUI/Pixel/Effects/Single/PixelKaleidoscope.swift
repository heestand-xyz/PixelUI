//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution

public struct PixelKaleidoscope: Pixel {
    
    typealias Pix = KaleidoscopePIX
    
    public let pixType: PIXType = .effect(.single(.kaleidoscope))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case divisions
        case mirror
        case rotation
        case position
    }
    
    internal init(divisions: Int = 12,
                  mirror: Bool = true,
                  rotation: Angle = .zero,
                  offset position: CGPoint = .zero,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .divisions:
                metadata[key.rawValue] = divisions
            case .mirror:
                metadata[key.rawValue] = mirror
            case .rotation:
                metadata[key.rawValue] = rotation
            case .position:
                metadata[key.rawValue] = position
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .divisions:
            return pix.divisions
        case .mirror:
            return pix.mirror
        case .rotation:
            return Pixels.asAngle(pix.rotation)
        case .position:
            return Pixels.inZeroViewSpace(pix.position, size: size)
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .divisions:
                Pixels.updateValue(pix: &pix, value: value, at: \.divisions)
            case .mirror:
                Pixels.updateValue(pix: &pix, value: value, at: \.mirror)
            case .rotation:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.rotation)
            case .position:
                Pixels.updateValueInZeroPixelSpace(pix: &pix, value: value, size: size, at: \.position)
            }
        }
    }
}

public extension Pixel {
    
    func pixelKaleidoscope(divisions: Int = 12,
                           mirror: Bool = true,
                           rotation: Angle = .zero,
                           offset: CGPoint = .zero) -> PixelKaleidoscope {
        PixelKaleidoscope(divisions: divisions,
                          mirror: mirror,
                          rotation: rotation,
                          offset: offset,
                          pixel: { self })
    }
}

struct PixelKaleidoscope_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelKaleidoscope()
        }
    }
}
