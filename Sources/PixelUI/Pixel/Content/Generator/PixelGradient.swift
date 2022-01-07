//
//  Created by Anton Heestand on 2021-11-22.
//

import Foundation
import SwiftUI
import RenderKit
import PixelKit
import PixelColor

public struct PixelColorStop {
    let stop: CGFloat
    let color: PixelColor
    public init(at stop: CGFloat, color: Color) {
        self.stop = stop
        self.color = PixelColor(color)
    }
}

public struct PixelGradient: Pixel {
    
    typealias Pix = GradientPIX
    
    public let pixType: PIXType = .content(.generator(.gradient))
    
    public let pixelTree: PixelTree = .content
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case direction
        case scale
        case offset
        case gamma
        case extendMode
        case position
    }
    
    public init(axis direction: GradientPIX.Direction,
                colorStops: [PixelColorStop] = [
                    PixelColorStop(at: 0.0, color: .black),
                    PixelColorStop(at: 1.0, color: .white)
                ]) {
        
        for (index, colorStop) in colorStops.enumerated() {
            metadata["gradient-color-\(index)"] = colorStop.color
            metadata["gradient-stop-\(index)"] = colorStop.stop
        }
        
        for key in Key.allCases {
            switch key {
            case .direction:
                metadata[key.rawValue] = direction.rawValue
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        if key.starts(with: "gradient") {
            guard let indexString = key.split(separator: "-").last else { return nil }
            guard let index = Int(indexString) else { return nil }
            guard pix.colorStops.indices.contains(index) else { return nil }
            if key.contains("color") {
                return pix.colorStops[index].color
            } else if key.contains("stop") {
                return pix.colorStops[index].stop
            }
        }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .direction:
            return pix.direction.rawValue
        case .scale:
            return pix.scale
        case .offset:
            return pix.offset
        case .gamma:
            return pix.gamma
        case .extendMode:
            return pix.extendMode.rawValue
        case .position:
            return Pixels.inZeroViewSpace(pix.position, size: size)
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
            
            if key.starts(with: "gradient") {
                guard let indexString = key.split(separator: "-").last else { continue }
                guard let index = Int(indexString) else { continue }
                if key.contains("color") {
                    guard let color = value as? PixelColor else { continue }
                    if pix.colorStops.indices.contains(index) {
                        pix.colorStops[index].color = color
                    } else {
                        pix.colorStops.append(ColorStop(0.0, color))
                    }
                } else if key.contains("stop") {
                    guard let stop = value as? CGFloat else { continue }
                    if pix.colorStops.indices.contains(index) {
                        pix.colorStops[index].stop = stop
                    } else {
                        pix.colorStops.append(ColorStop(stop, .clear))
                    }
                }
            }
            
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .direction:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.direction)
            case .scale:
                Pixels.updateValue(pix: &pix, value: value, at: \.scale)
            case .offset:
                Pixels.updateValue(pix: &pix, value: value, at: \.offset)
            case .gamma:
                Pixels.updateValue(pix: &pix, value: value, at: \.gamma)
            case .extendMode:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.extendMode)
            case .position:
                Pixels.updateValueInZeroPixelSpace(pix: &pix, value: value, size: size, at: \.position)
            }
        }
    }
}

public extension PixelGradient {
    
    func pixelOffset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> Self {
        var pixel = self
        pixel.metadata[Key.position.rawValue] = CGPoint(x: x, y: y)
        return pixel
    }
    
    func pixelGradientScale(_ scale: CGFloat) -> Self {
        var pixel = self
        pixel.metadata[Key.scale.rawValue] = scale
        return pixel
    }
    
    func pixelGradientOffset(_ offset: CGFloat) -> Self {
        var pixel = self
        pixel.metadata[Key.offset.rawValue] = offset
        return pixel
    }
    
    func pixelGradientGamma(_ gamma: CGFloat) -> Self {
        var pixel = self
        pixel.metadata[Key.gamma.rawValue] = gamma
        return pixel
    }
    
    func pixelGradientExtend(_ extendMode: ExtendMode) -> Self {
        var pixel = self
        pixel.metadata[Key.extendMode.rawValue] = extendMode.rawValue
        return pixel
    }
}

struct PixelGradient_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelGradient(axis: .vertical)
        }
    }
}
