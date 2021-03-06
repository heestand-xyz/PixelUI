//
//  Created by Anton Heestand on 2021-11-17.
//

import Foundation
import RenderKit
import PixelKit
import Resolution

extension Pixels {
    
    static func createPix(for pixel: Pixel, at resolution: Resolution) -> PIX & NODEOut {
        createPix(for: pixel, at: resolution) ?? ColorPIX(at: ._128, color: .clear)
    }
    
    static func createPix(for pixel: Pixel, at resolution: Resolution) -> (PIX & NODEOut)? {
        
        guard var pix: PIX & NODEOut = pixel.pixType.pix(at: resolution) as? PIX & NODEOut else { return nil }
        
        switch pixel.pixelTree {
        case .content:
            
            if pixel.resizeContentResolution {
                let resolutionPix = ResolutionPIX(at: resolution)
                resolutionPix.placement = .fill
                resolutionPix.input = pix
                pix = resolutionPix
            }
            
        case .singleEffect(let pixel):
            
            guard let singleEffectPix = pix as? PIXSingleEffect else { return nil }
            
            singleEffectPix.input = Self.createPix(for: pixel, at: resolution)
            
        case .mergerEffect(let pixelA, let pixelB):
            
            guard let mergerEffectPix = pix as? PIXMergerEffect else { return nil }
            
            mergerEffectPix.inputA = Self.createPix(for: pixelA, at: resolution)
            mergerEffectPix.inputB = Self.createPix(for: pixelB, at: resolution)
            
        case .multiEffect(let pixels):
            
            guard let multiEffectPix = pix as? PIXMultiEffect else { return nil }
            
            multiEffectPix.inputs = pixels.map { pixel in
                Self.createPix(for: pixel, at: resolution)
            }
        
        case .feedback(let pixel, let feedbackPixel):
            
            guard let feedbackPix = pix as? FeedbackPIX else { return nil }
            
            feedbackPix.input = Self.createPix(for: pixel, at: resolution)
            feedbackPix.feedbackInput = Self.createPix(for: feedbackPixel, at: resolution)
        }
        
        return pix
    }
}
