//
//  Created by Anton Heestand on 2021-11-23.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

/// Pixel Metal Script
///
/// **Variables:** pi, u, v, var.width, var.height, var.aspect, var.your-varaible-name
public struct PixelMetalScript: Pixel {
    
    typealias Pix = MetalScriptPIX
    
    public let pixType: PIXType = .content(.generator(.metalScript))
    
    public let pixelTree: PixelTree = .content
    
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
                alpha alphaScript: String = "1.0") {

        for (index, variable) in variables.enumerated() {
            metadata["variable-\(index)"] = variable
        }
        
        for key in Key.allCases {
            switch key {
            case .colorStyle:
                metadata[key.rawValue] = MetalScriptPIX.ColorStyle.color.rawValue
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
                alpha alphaScript: String = "1.0") {

        for (index, variable) in variables.enumerated() {
            metadata["variable-\(index)"] = variable
        }
        
        for key in Key.allCases {
            switch key {
            case .colorStyle:
                metadata[key.rawValue] = MetalScriptPIX.ColorStyle.white.rawValue
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

struct PixelMetalScript_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelMetalScript(red: "1.0", green: "0.5", blue: "0.0", alpha: "1.0")
        }
    }
}
