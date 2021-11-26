//
//  Created by Anton Heestand on 2021-11-23.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

/// Pixel Metal Multi Effect
///
/// **Variables:** pi, u, v, uv, pixCount, texs, var.width, var.height, var.aspect, var.your-varaible-name
///
/// Example:
/// ```swift
/// Pixels {
///     PixelMetalMultiEffect(code:
///         """
///         float4 pixA = texs.sample(s, uv, 0);
///         float4 pixB = texs.sample(s, uv, 1);
///         float4 pixC = texs.sample(s, uv, 2);
///         return pixA + pixB + pixC;
///         """
///     ) {
///         PixelCircle(radius: 100)
///         PixelStar(count: 5, radius: 100)
///         PixelPolygon(count: 3, radius: 100)
///     }
/// }
/// ```
public struct PixelMetalMultiEffect: Pixel {
    
    typealias Pix = MetalMultiEffectPIX
    
    public let pixType: PIXType = .effect(.multi(.metalMultiEffect))
    
    public let pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case code
    }
    
    public init(variables: [PixelVariable] = [],
                code: String,
                @PixelBuilder pixels: () -> [Pixel]) {
        
        pixelTree = .multiEffect(pixels())

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

struct PixelMetalMultiEffect_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelMetalMultiEffect(code:
                """
                float4 pixA = texs.sample(s, uv, 0);
                float4 pixB = texs.sample(s, uv, 1);
                float4 pixC = texs.sample(s, uv, 2);
                return pixA + pixB + pixC;
                """
            ) {
                PixelCircle(radius: 100)
                PixelStar(count: 5, radius: 100)
                PixelPolygon(count: 3, radius: 100)
            }
        }
    }
}
