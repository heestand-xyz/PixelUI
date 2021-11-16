//
//  Created by Anton Heestand on 2021-11-16.
//

import Resolution
import RenderKit
import PixelKit

@resultBuilder
public struct PixelBuilder {
        
    static func pix(for pixelTree: PixelTree, at resolution: Resolution) -> PIX & NODEOut {
        pix(for: pixelTree, at: resolution) ?? ColorPIX(at: ._128, color: .clear)
    }
    
    static func pix(for pixelTree: PixelTree, at resolution: Resolution) -> (PIX & NODEOut)? {
        
        guard let pix: PIX & NODEOut = pixelTree.pixType.pix(at: ._1024) as? PIX & NODEOut else { return nil }
        
        switch pixelTree {
        case .generator:
            break
        case .resource:
            break
        case .singleEffect(_, let pixelTree):
            
            guard let singleEffectPix = pix as? PIXSingleEffect else { return nil }
            
            singleEffectPix.input = Self.pix(for: pixelTree, at: resolution)
            
        case .mergerEffect(_, let pixelTreeA, let pixelTreeB):
            
            guard let mergerEffectPix = pix as? PIXMergerEffect else { return nil }
            
            mergerEffectPix.inputA = Self.pix(for: pixelTreeA, at: resolution)
            mergerEffectPix.inputB = Self.pix(for: pixelTreeB, at: resolution)
            
        case .multiEffect(_, let pixelTrees):
            
            guard let multiEffectPix = pix as? PIXMultiEffect else { return nil }
            
            multiEffectPix.inputs = pixelTrees.map { pixelTree in
                Self.pix(for: pixelTree, at: resolution)
            }
        }
        
        return pix
    }
    
    public static func buildBlock(_ pixels: Pixel...) -> [Pixel] {
        pixels
    }
}
