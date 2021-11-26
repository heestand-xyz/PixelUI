//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelFlare: Pixel {
    
    typealias Pix = FlarePIX
    
    public let pixType: PIXType = .effect(.single(.flare))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case scale
        case count
        case angle
        case threshold
        case brightness
        case gamma
        case color
        case rayResolution
    }
    
    internal init(scale: CGFloat = 0.25,
                  count: Int = 6,
                  angle: Angle = Angle(degrees: 90),
                  threshold: CGFloat = 0.95,
                  brightness: CGFloat = 1.0,
                  gamma: CGFloat = 0.25,
                  color: Color = .orange,
                  rayResolution: Int = 32,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .scale:
                metadata[key.rawValue] = scale
            case .count:
                metadata[key.rawValue] = count
            case .angle:
                metadata[key.rawValue] = angle
            case .threshold:
                metadata[key.rawValue] = threshold
            case .brightness:
                metadata[key.rawValue] = brightness
            case .gamma:
                metadata[key.rawValue] = gamma
            case .color:
                metadata[key.rawValue] = PixelColor(color)
            case .rayResolution:
                metadata[key.rawValue] = rayResolution
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .scale:
            return pix.scale
        case .count:
            return pix.count
        case .angle:
            return Pixels.asAngle(pix.angle)
        case .threshold:
            return pix.threshold
        case .brightness:
            return pix.brightness
        case .gamma:
            return pix.gamma
        case .color:
            return pix.color
        case .rayResolution:
            return pix.rayResolution
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .scale:
                Pixels.updateValue(pix: &pix, value: value, at: \.scale)
            case .count:
                Pixels.updateValue(pix: &pix, value: value, at: \.count)
            case .angle:
                Pixels.updateValueAngle(pix: &pix, value: value, at: \.angle)
            case .threshold:
                Pixels.updateValue(pix: &pix, value: value, at: \.threshold)
            case .brightness:
                Pixels.updateValue(pix: &pix, value: value, at: \.brightness)
            case .gamma:
                Pixels.updateValue(pix: &pix, value: value, at: \.gamma)
            case .color:
                Pixels.updateValue(pix: &pix, value: value, at: \.color)
            case .rayResolution:
                Pixels.updateValue(pix: &pix, value: value, at: \.rayResolution)
            }
        }
    }
}

public extension Pixel {
    
    func pixelFlare(scale: CGFloat = 0.25,
                    count: Int = 6,
                    angle: Angle = Angle(degrees: 90),
                    threshold: CGFloat = 0.95,
                    brightness: CGFloat = 1.0,
                    gamma: CGFloat = 0.25,
                    color: Color = .orange,
                    rayResolution: Int = 32) -> PixelFlare {
        PixelFlare(scale: scale,
                   count: count,
                   angle: angle,
                   threshold: threshold,
                   brightness: brightness,
                   gamma: gamma,
                   color: color,
                   rayResolution: rayResolution,
                   pixel: { self })
    }
}

struct PixelFlare_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelPolygon(count: 3, radius: 100)
                .pixelFlare()
        }
    }
}
