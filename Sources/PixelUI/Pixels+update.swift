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
        Self.update(pixelTree: pixelTree, pix: pix)
    }
    
    static func update(pixelTree: PixelTree, pix: PIX) {
        
        for (key, value) in pixelTree.metadata {
            if let circlePix = pix as? CirclePIX {
                if key == "radius" {
                    circlePix.radius = value
                }
            }
        }
     
        switch pixelTree {
        case .generator:
            break
        case .resource:
            break
        case .singleEffect(_, _, let pixelTree):
            
            guard let singleEffectPix = pix as? PIXSingleEffect else { return }
            
            guard let inputPix: PIX = singleEffectPix.input as? PIX else { return }
            
            Self.update(pixelTree: pixelTree, pix: inputPix)
            
        case .mergerEffect(_, _, let pixelTreeA, let pixelTreeB):
            
            guard let mergerEffectPix = pix as? PIXMergerEffect else { return }
            
            guard let inputPixA: PIX = mergerEffectPix.inputA as? PIX else { return }
            guard let inputPixB: PIX = mergerEffectPix.inputB as? PIX else { return }
            
            Self.update(pixelTree: pixelTreeA, pix: inputPixA)
            Self.update(pixelTree: pixelTreeB, pix: inputPixB)

        case .multiEffect(_, _, let pixelTrees):
            
            guard let multiEffectPix = pix as? PIXMultiEffect else { return }
            
            for (pixelTree, inputNode) in zip(pixelTrees, multiEffectPix.inputs) {
                guard let inputPix: PIX = inputNode as? PIX else { continue }
                Self.update(pixelTree: pixelTree, pix: inputPix)
            }
        }
    }
}
