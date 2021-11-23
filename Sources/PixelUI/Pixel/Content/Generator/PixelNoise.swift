//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelNoise: Pixel {
    
    typealias Pix = NoisePIX
    
    public let pixType: PIXType = .content(.generator(.noise))
    
    public let pixelTree: PixelTree = .content
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case seed
        case octaves
        case position
        case motion
        case zoom
        case colored
        case random
        case includeAlpha
    }
    
    /// Pixel Noise
    /// - Parameter ocataves: The detail of noise. A lower value is smoother and a higher value is more detailed. The lowest value is 1 and the highest value is 10.
    public init(detail ocataves: Int = 1) {

        for key in Key.allCases {
            switch key {
            case .octaves:
                metadata[key.rawValue] = ocataves
            case .colored:
                metadata[key.rawValue] = true
            case .seed, .position, .motion, .zoom, .random, .includeAlpha:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .seed:
            return pix.seed
        case .octaves:
            return pix.octaves
        case .position:
            return Pixels.inViewSpace(pix.position, size: size)
        case .motion:
            return Pixels.inViewSpace(pix.motion, size: size)
        case .zoom:
            return pix.zoom
        case .colored:
            return pix.colored
        case .random:
            return pix.random
        case .includeAlpha:
            return pix.includeAlpha
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .seed:
                Pixels.updateValue(pix: &pix, value: value, at: \.seed)
            case .octaves:
                Pixels.updateValue(pix: &pix, value: value, at: \.octaves)
            case .position:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.position)
            case .motion:
                Pixels.updateValueInPixelSpace(pix: &pix, value: value, size: size, at: \.motion)
            case .zoom:
                Pixels.updateValue(pix: &pix, value: value, at: \.zoom)
            case .colored:
                Pixels.updateValue(pix: &pix, value: value, at: \.colored)
            case .random:
                Pixels.updateValue(pix: &pix, value: value, at: \.random)
            case .includeAlpha:
                Pixels.updateValue(pix: &pix, value: value, at: \.includeAlpha)
            }
        }
    }
}

public extension PixelNoise {
    
    func pixelOffset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> Self {
        var pixel = self
        pixel.metadata[Key.position.rawValue] = CGPoint(x: x, y: y)
        return pixel
    }
    
    func pixelNoiseMonochrome() -> Self {
        var pixel = self
        pixel.metadata[Key.colored.rawValue] = false
        return pixel
    }
    
    func pixelNoiseSeed(_ seed: Int) -> Self {
        var pixel = self
        pixel.metadata[Key.seed.rawValue] = seed
        return pixel
    }
    
    func pixelNoiseMotion(_ motion: CGFloat) -> Self {
        var pixel = self
        pixel.metadata[Key.motion.rawValue] = motion
        return pixel
    }
    
    func pixelNoiseZoom(_ zoom: CGFloat) -> Self {
        var pixel = self
        pixel.metadata[Key.zoom.rawValue] = zoom
        return pixel
    }
    
    func pixelNoiseRandom() -> Self {
        var pixel = self
        pixel.metadata[Key.random.rawValue] = true
        return pixel
    }
    
    func pixelNoiseIncludeAlpha() -> Self {
        var pixel = self
        pixel.metadata[Key.includeAlpha.rawValue] = true
        return pixel
    }
}

struct PixelNoise_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelNoise()
        }
    }
}
