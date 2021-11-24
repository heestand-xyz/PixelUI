//
//  Created by Anton Heestand on 2021-11-17.
//

import Foundation
import CoreGraphics
import PixelKit
import Resolution

extension Pixels {
    
    static func update(metadata: [PixelsMetadata.Key: PixelMetadata],
                       pixel: Pixel,
                       pix: PIX,
                       size: CGSize) {
        
        let pixId = pix.id
        
        var pix = pix
        if pixel.resizeContentResolution {
            guard let resolutionPix = pix as? ResolutionPIX else { return }
            guard let inputPix = resolutionPix.input as? PIX else { return }
            pix = inputPix
        }
        
        var localMetadata: [String: PixelMetadata] = [:]
        for (key, value) in metadata {
            guard key.pixId == pixId else { continue }
            localMetadata[key.variable] = value
        }
        pixel.update(metadata: localMetadata, pix: pix, size: size)
     
        switch pixel.pixelTree {
        case .content:
            break
        case .singleEffect(let pixel):
            
            guard let singleEffectPix = pix as? PIXSingleEffect else { return }
            
            guard let inputPix: PIX = singleEffectPix.input as? PIX else { return }
            
            Self.update(metadata: metadata, pixel: pixel, pix: inputPix, size: size)
            
        case .mergerEffect(let pixelA, let pixelB):
            
            guard let mergerEffectPix = pix as? PIXMergerEffect else { return }
            
            guard let inputPixA: PIX = mergerEffectPix.inputA as? PIX else { return }
            guard let inputPixB: PIX = mergerEffectPix.inputB as? PIX else { return }
            
            Self.update(metadata: metadata, pixel: pixelA, pix: inputPixA, size: size)
            Self.update(metadata: metadata, pixel: pixelB, pix: inputPixB, size: size)

        case .multiEffect(let pixels):
            
            guard let multiEffectPix = pix as? PIXMultiEffect else { return }
            
            for (pixel, inputNode) in zip(pixels, multiEffectPix.inputs) {
                guard let inputPix: PIX = inputNode as? PIX else { continue }
                Self.update(metadata: metadata, pixel: pixel, pix: inputPix, size: size)
            }
            
        case .feedback(let pixel, let feedbackPixel):
            
            guard let feedbackPix = pix as? FeedbackPIX else { return }
            
            guard let inputPix: PIX = feedbackPix.input as? PIX else { return }
            guard let feedbackInputPix: PIX = feedbackPix.feedbackInput else { return }
            #warning("Loop")
            
            Self.update(metadata: metadata, pixel: pixel, pix: inputPix, size: size)
            Self.update(metadata: metadata, pixel: feedbackPixel, pix: feedbackInputPix, size: size)
        }
    }
}
