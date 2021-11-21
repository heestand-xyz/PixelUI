//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-17.
//

import Foundation
import PixelKit

extension Pixels {
    
    func update(metadata: [PixelMetadatas.Key: PixelMetadata], size: CGSize) {
        Self.update(metadata: metadata, pixel: rootPixel, pix: pix, size: size)
    }
    
    private static func update(metadata: [PixelMetadatas.Key: PixelMetadata],
                               pixel: Pixel,
                               pix: PIX,
                               size: CGSize) {
        
        var localMetadata: [String: PixelMetadata] = [:]
        for (key, value) in metadata {
            guard key.pixId == pix.id else { continue }
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
        }
    }
}
