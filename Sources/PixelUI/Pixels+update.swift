//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-17.
//

import Foundation
import PixelKit

extension Pixels {
    
    func update() {
        Self.update(pixel: rootPixel, pix: pix)
    }
    
    static func update(pixel: Pixel, pix: PIX) {
        
        for (key, value) in pixel.metadata {
            if let circlePix = pix as? CirclePIX {
                if key == "radius", let value = value as? CGFloat {
                    circlePix.radius = value
                }
            }
        }
     
        switch pixel.pixelTree {
        case .content:
            break
        case .singleEffect(let pixel):
            
            guard let singleEffectPix = pix as? PIXSingleEffect else { return }
            
            guard let inputPix: PIX = singleEffectPix.input as? PIX else { return }
            
            Self.update(pixel: pixel, pix: inputPix)
            
        case .mergerEffect(let pixelA, let pixelB):
            
            guard let mergerEffectPix = pix as? PIXMergerEffect else { return }
            
            guard let inputPixA: PIX = mergerEffectPix.inputA as? PIX else { return }
            guard let inputPixB: PIX = mergerEffectPix.inputB as? PIX else { return }
            
            Self.update(pixel: pixelA, pix: inputPixA)
            Self.update(pixel: pixelB, pix: inputPixB)

        case .multiEffect(let pixels):
            
            guard let multiEffectPix = pix as? PIXMultiEffect else { return }
            
            for (pixel, inputNode) in zip(pixels, multiEffectPix.inputs) {
                guard let inputPix: PIX = inputNode as? PIX else { continue }
                Self.update(pixel: pixel, pix: inputPix)
            }
        }
    }
}
