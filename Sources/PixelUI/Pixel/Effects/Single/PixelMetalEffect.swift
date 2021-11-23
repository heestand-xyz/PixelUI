//
//  Created by Anton Heestand on 2021-11-23.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

/// Pixel Metal Effect
///
/// **Variables:** pi, u, v, uv, w, h, wu, hv, tex, pix, var.width, var.height, var.aspect, var.your-variable-name
///
/// Example:
/// ```swift
/// Pixels {
///     PixelMetalEffect(code:
///         """
///         float gamma = 0.25;
///         return pow(pix, 1.0 / gamma);
///         """
///     ) {
///         PixelCamera()
///     }
/// }
/// ```
public struct PixelMetalEffect: Pixel {
    
    typealias Pix = MetalEffectPIX
    
    public let pixType: PIXType = .effect(.single(.metalEffect))
    
    public let pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case code
    }
    
    public init(variables: [PixelVariable] = [],
                code: String,
                pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())

        for (index, variable) in variables.enumerated() {
            metadata["variable-\(index)"] = variable
        }
        
        for key in Key.allCases {
            switch key {
            case .code:
                metadata[key.rawValue] = code
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
        case .code:
            return pix.code
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
            case .code:
                Pixels.updateValue(pix: &pix, value: value, at: \.code)
            }
        }
    }
}

struct PixelMetalEffect_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelMetalEffect(code: "return pix;") {
                PixelCircle(radius: 50)
            }
        }
    }
}
