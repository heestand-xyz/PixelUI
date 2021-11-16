//
//  Created by Anton Heestand on 2021-11-16.
//

import RenderKit
import PixelKit

@resultBuilder
public struct PixelBuilder {
        
    static func pix(for pixelTree: PixelTree) -> PIX & NODEOut {
        pix(for: pixelTree) ?? ColorPIX(at: ._128, color: .clear)
    }
    
    static func pix(for pixelTree: PixelTree) -> (PIX & NODEOut)? {
        
        guard let pix: PIX & NODEOut = pixelTree.pixType.pix(at: ._1024) as? PIX & NODEOut else { return nil }
        
        switch pixelTree {
        case .generator:
            break
        case .resource:
            break
        case .singleEffect(_, let pixelTree):
            
            guard let singleEffectPix = pix as? PIXSingleEffect else { return nil }
            
            singleEffectPix.input = Self.pix(for: pixelTree)
            
        case .mergerEffect(_, let pixelTreeA, let pixelTreeB):
            
            guard let mergerEffectPix = pix as? PIXMergerEffect else { return nil }
            
            mergerEffectPix.inputA = Self.pix(for: pixelTreeA)
            mergerEffectPix.inputB = Self.pix(for: pixelTreeB)
            
        case .multiEffect(_, let pixelTrees):
            
            guard let multiEffectPix = pix as? PIXMultiEffect else { return nil }
            
            multiEffectPix.inputs = pixelTrees.map(Self.pix(for:))
        }
        
        return pix
    }
    
    public static func buildBlock(_ pixels: Pixel...) -> [Pixel] {
        pixels
    }
}
