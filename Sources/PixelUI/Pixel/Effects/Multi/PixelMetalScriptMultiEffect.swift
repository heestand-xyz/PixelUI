//
//  Created by Anton Heestand on 2021-11-23.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

/// Pixel Metal Script Multi Effect
///
/// **Variables:** pi, u, v, uv, pixCount, texs, var.width, var.height, var.aspect, var.your-varaible-name
/// ```metal
/// texs.sample(s, uv, 0).r
/// ```
public struct PixelMetalScriptMultiEffect: Pixel {
    
    typealias Pix = MetalScriptMultiEffectPIX
    
    public let pixType: PIXType = .effect(.multi(.metalScriptMultiEffect))
    
    public let pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case colorStyle
        case whiteScript
        case redScript
        case greenScript
        case blueScript
        case alphaScript
    }
    
    public init(variables: [PixelVariable] = [],
                red redScript: String,
                green greenScript: String,
                blue blueScript: String,
                alpha alphaScript: String = "1.0",
                @PixelBuilder pixels: () -> [Pixel]) {

        pixelTree = .multiEffect(pixels())
        
        for (index, variable) in variables.enumerated() {
            metadata["variable-\(index)"] = variable
        }
        
        for key in Key.allCases {
            switch key {
            case .colorStyle:
                metadata[key.rawValue] = MetalScriptMultiEffectPIX.ColorStyle.color.rawValue
            case .redScript:
                metadata[key.rawValue] = redScript
            case .greenScript:
                metadata[key.rawValue] = greenScript
            case .blueScript:
                metadata[key.rawValue] = blueScript
            case .alphaScript:
                metadata[key.rawValue] = alphaScript
            case .whiteScript:
                continue
            }
        }
    }
    
    public init(variables: [PixelVariable] = [],
                white whiteScript: String,
                alpha alphaScript: String = "1.0",
                @PixelBuilder pixels: () -> [Pixel]) {
        
        pixelTree = .multiEffect(pixels())

        for (index, variable) in variables.enumerated() {
            metadata["variable-\(index)"] = variable
        }
        
        for key in Key.allCases {
            switch key {
            case .colorStyle:
                metadata[key.rawValue] = MetalScriptMultiEffectPIX.ColorStyle.white.rawValue
            case .whiteScript:
                metadata[key.rawValue] = whiteScript
            case .alphaScript:
                metadata[key.rawValue] = alphaScript
            case .redScript, .greenScript, .blueScript:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        if key.starts(with: "variable") {
            guard let indexString = key.split(separator: "-").last else { return nil }
            guard let index = Int(indexString) else { return nil }
            guard pix.metalUniforms.indices.contains(index) else { return nil }
            let metalUniform: MetalUniform = pix.metalUniforms[index]
            return PixelVariable(name: metalUniform.name, value: metalUniform.value)
        }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .colorStyle:
            return pix.colorStyle.rawValue
        case .whiteScript:
            return pix.whiteScript
        case .redScript:
            return pix.redScript
        case .greenScript:
            return pix.greenScript
        case .blueScript:
            return pix.blueScript
        case .alphaScript:
            return pix.alphaScript
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
            
            if key.starts(with: "variable") {
                guard let indexString = key.split(separator: "-").last else { continue }
                guard let index = Int(indexString) else { continue }
                guard let variable = value as? PixelVariable else { return }
                let metalUniform = MetalUniform(name: variable.name, value: variable.value)
                if pix.metalUniforms.indices.contains(index) {
                    pix.metalUniforms[index] = metalUniform
                } else {
                    pix.metalUniforms.append(metalUniform)
                }
            }
            
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .colorStyle:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.colorStyle)
            case .whiteScript:
                Pixels.updateValue(pix: &pix, value: value, at: \.whiteScript)
            case .redScript:
                Pixels.updateValue(pix: &pix, value: value, at: \.redScript)
            case .greenScript:
                Pixels.updateValue(pix: &pix, value: value, at: \.greenScript)
            case .blueScript:
                Pixels.updateValue(pix: &pix, value: value, at: \.blueScript)
            case .alphaScript:
                Pixels.updateValue(pix: &pix, value: value, at: \.alphaScript)
            }
        }
    }
}

struct PixelMetalScriptMultiEffect_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelMetalScriptMultiEffect(red: "texs.sample(s, uv, 0).r",
                                        green: "texs.sample(s, uv, 1).g",
                                        blue: "texs.sample(s, uv, 2).b",
                                        alpha: "1.0") {
                PixelCircle(radius: 50)
                PixelStar(count: 5, radius: 50)
                PixelPolygon(count: 3, radius: 50)
            }
        }
    }
}
