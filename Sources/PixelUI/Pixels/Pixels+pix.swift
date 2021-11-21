//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-17.
//

import Foundation
import RenderKit
import PixelKit
import Resolution

extension Pixels {
    
    static func pix(for pixel: Pixel, at resolution: Resolution) -> PIX & NODEOut {
        pix(for: pixel, at: resolution) ?? ColorPIX(at: ._128, color: .clear)
    }
    
    static func pix(for pixel: Pixel, at resolution: Resolution) -> (PIX & NODEOut)? {
        
        guard let pix: PIX & NODEOut = pixel.pixType.pix(at: resolution) as? PIX & NODEOut else { return nil }
        
        switch pixel.pixelTree {
        case .content:
            break
        case .singleEffect(let pixel):
            
            guard let singleEffectPix = pix as? PIXSingleEffect else { return nil }
            
            singleEffectPix.input = Self.pix(for: pixel, at: resolution)
            
        case .mergerEffect(let pixelA, let pixelB):
            
            guard let mergerEffectPix = pix as? PIXMergerEffect else { return nil }
            
            mergerEffectPix.inputA = Self.pix(for: pixelA, at: resolution)
            mergerEffectPix.inputB = Self.pix(for: pixelB, at: resolution)
            
        case .multiEffect(let pixels):
            
            guard let multiEffectPix = pix as? PIXMultiEffect else { return nil }
            
            multiEffectPix.inputs = pixels.map { pixel in
                Self.pix(for: pixel, at: resolution)
            }
        }
        
        return pix
    }
}
