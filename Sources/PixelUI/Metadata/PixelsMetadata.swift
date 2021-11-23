//
//  Created by Anton Heestand on 2021-11-17.
//

import Foundation
import CoreGraphics
import PixelKit

public struct PixelsMetadata {

    public struct Key: Hashable, Equatable {
        let pixId: UUID
        let variable: String
    }
    
    static func pixelMetadata(pixel: Pixel, pix: PIX) -> [Key: PixelMetadata] {
       
        var allMetadata: [Key: PixelMetadata] = [:]
        
        for (key, value) in pixel.metadata {
            let metadataKey = Key(pixId: pix.id, variable: key)
            allMetadata[metadataKey] = value
        }
        
        switch pixel.pixelTree {
        case .content:
            break
        case .singleEffect(let pixel):

            guard let singleEffectPix = pix as? PIXSingleEffect else { break }

            guard let inputPix: PIX = singleEffectPix.input as? PIX else { break }

            for (key, value) in Self.pixelMetadata(pixel: pixel, pix: inputPix) {
                allMetadata[key] = value
            }

        case .mergerEffect(let pixelA, let pixelB):

            guard let mergerEffectPix = pix as? PIXMergerEffect else { break }

            guard let inputPixA: PIX = mergerEffectPix.inputA as? PIX else { break }
            guard let inputPixB: PIX = mergerEffectPix.inputB as? PIX else { break }

            for (key, value) in Self.pixelMetadata(pixel: pixelA, pix: inputPixA) {
                allMetadata[key] = value
            }
            for (key, value) in Self.pixelMetadata(pixel: pixelB, pix: inputPixB) {
                allMetadata[key] = value
            }

        case .multiEffect(let pixels):

            guard let multiEffectPix = pix as? PIXMultiEffect else { break }

            for (pixel, inputNode) in zip(pixels, multiEffectPix.inputs) {
                guard let inputPix: PIX = inputNode as? PIX else { continue }
                for (key, value) in Self.pixelMetadata(pixel: pixel, pix: inputPix) {
                    allMetadata[key] = value
                }
            }
            
        case .feedback(let pixel, let feedbackPixel):

            guard let mergerEffectPix = pix as? FeedbackPIX else { break }

            guard let inputPix: PIX = mergerEffectPix.input as? PIX else { break }
            guard let feedbackInputPix: PIX = mergerEffectPix.feedbackInput else { break }
            #warning("Loop")

            for (key, value) in Self.pixelMetadata(pixel: pixel, pix: inputPix) {
                allMetadata[key] = value
            }
            for (key, value) in Self.pixelMetadata(pixel: feedbackPixel, pix: feedbackInputPix) {
                allMetadata[key] = value
            }
        }
        
        return allMetadata
    }
    
    static func pixMetadata(pixel: Pixel, pix: PIX, size: CGSize) -> [Key: PixelMetadata] {
       
        var allMetadata: [Key: PixelMetadata] = [:]
        
        for (key, _) in pixel.metadata {
            let metadataKey = Key(pixId: pix.id, variable: key)
            allMetadata[metadataKey] = pixel.value(at: key, pix: pix, size: size)
        }
        
        switch pixel.pixelTree {
        case .content:
            break
        case .singleEffect(let pixel):

            guard let singleEffectPix = pix as? PIXSingleEffect else { break }

            guard let inputPix: PIX = singleEffectPix.input as? PIX else { break }

            for (key, value) in Self.pixMetadata(pixel: pixel, pix: inputPix, size: size) {
                allMetadata[key] = value
            }

        case .mergerEffect(let pixelA, let pixelB):

            guard let mergerEffectPix = pix as? PIXMergerEffect else { break }

            guard let inputPixA: PIX = mergerEffectPix.inputA as? PIX else { break }
            guard let inputPixB: PIX = mergerEffectPix.inputB as? PIX else { break }

            for (key, value) in Self.pixMetadata(pixel: pixelA, pix: inputPixA, size: size) {
                allMetadata[key] = value
            }
            for (key, value) in Self.pixMetadata(pixel: pixelB, pix: inputPixB, size: size) {
                allMetadata[key] = value
            }

        case .multiEffect(let pixels):

            guard let multiEffectPix = pix as? PIXMultiEffect else { break }

            for (pixel, inputNode) in zip(pixels, multiEffectPix.inputs) {
                guard let inputPix: PIX = inputNode as? PIX else { continue }
                for (key, value) in Self.pixMetadata(pixel: pixel, pix: inputPix, size: size) {
                    allMetadata[key] = value
                }
            }
            
        case .feedback(let pixel, let feedbackPixel):

            guard let mergerEffectPix = pix as? FeedbackPIX else { break }

            guard let inputPix: PIX = mergerEffectPix.input as? PIX else { break }
            guard let feedbackInputPix: PIX = mergerEffectPix.feedbackInput else { break }
            #warning("Loop")

            for (key, value) in Self.pixMetadata(pixel: pixel, pix: inputPix, size: size) {
                allMetadata[key] = value
            }
            for (key, value) in Self.pixMetadata(pixel: feedbackPixel, pix: feedbackInputPix, size: size) {
                allMetadata[key] = value
            }
        }
        
        return allMetadata
    }
}
