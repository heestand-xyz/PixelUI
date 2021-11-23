//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-21.
//

import SwiftUI
import Resolution
import PixelKit

struct PixelsView: ViewRepresentable {
    
    @StateObject var pix: PIX
    
    let rootPixel: Pixel
    
    let size: CGSize
    let resolution: Resolution
    
    static var lastMetadata: [UUID: [PixelsMetadata.Key: PixelMetadata]] = [:]
    static var lastSize: [UUID: CGSize] = [:]
    static var lastResolution: [UUID: Resolution] = [:]

    var pixelMetadata: [PixelsMetadata.Key: PixelMetadata] {
        PixelsMetadata.pixelMetadata(pixel: rootPixel, pix: pix)
    }
    
    @State var timer: Timer?
    
    init(resolution: Resolution, size: CGSize, pixel: @escaping () -> (Pixel)) {
        let pixel = pixel()
        rootPixel = pixel
        self.size = size
        self.resolution = resolution
        _pix = StateObject(wrappedValue: Pixels.createPix(for: pixel, at: resolution))
    }
    
    func makeView(context: Context) -> PIXView {
        
        Self.lastMetadata[pix.id] = [:]
        Self.lastSize[pix.id] = size
        Self.lastResolution[pix.id] = resolution
        
        return pix.pixView
    }
    
    func updateView(_ view: PIXView, context: Context) {
        
        if size != Self.lastSize[pix.id] {
            Self.lastMetadata[pix.id] = [:]
        }
        
        if resolution != Self.lastResolution[pix.id] {
            Pixels.update(resolution: resolution, pixel: rootPixel, pix: pix)
        }
        
        let lastMetadata = Self.lastMetadata[pix.id] ?? [:]
        
        let diffedPixelMetadata = diffedMetadata(from: pixelMetadata, with: lastMetadata)
        
        let pixMetadata = PixelsMetadata.pixMetadata(pixel: rootPixel, pix: pix, size: size)
        
        let transaction = context.transaction
        if !transaction.disablesAnimations,
           let animation: Animation = transaction.animation {
            print("Pixels Update with Animation")
            Pixels.animate(animation: animation, timer: &timer) { fraction in
                let interpolatedMetadata = interpolateMetadata(at: fraction, pixelMetadata: diffedPixelMetadata, pixMetadata: pixMetadata)
                update(metadata: interpolatedMetadata, size: size)
            }
        } else {
            print("Pixels Update")
            update(metadata: diffedPixelMetadata, size: size)
        }
        
        Self.lastMetadata[pix.id] = pixelMetadata
        Self.lastSize[pix.id] = size
        Self.lastResolution[pix.id] = resolution
    }
    
    func update(metadata: [PixelsMetadata.Key: PixelMetadata], size: CGSize) {
        Pixels.update(metadata: metadata, pixel: rootPixel, pix: pix, size: size)
    }
    
    func diffedMetadata(from metadata: [PixelsMetadata.Key: PixelMetadata],
                        with lastMetadata: [PixelsMetadata.Key: PixelMetadata]) -> [PixelsMetadata.Key: PixelMetadata] {
        var diffedMetadata: [PixelsMetadata.Key: PixelMetadata] = [:]
        for (key, value) in metadata {
            if let lastValue = lastMetadata[key] {
                if !value.isEqual(to: lastValue) {
                    diffedMetadata[key] = value
                }
            } else {
                diffedMetadata[key] = value
            }
        }
        return diffedMetadata
    }
    
    func interpolateMetadata(at fraction: CGFloat,
                             pixelMetadata: [PixelsMetadata.Key: PixelMetadata],
                             pixMetadata: [PixelsMetadata.Key: PixelMetadata]) -> [PixelsMetadata.Key: PixelMetadata] {
        var metadata: [PixelsMetadata.Key: PixelMetadata] = [:]
        for (pixelKey, pixelValue) in pixelMetadata {
            for (pixKey, pixValue) in pixMetadata {
                if pixKey == pixelKey {
                    let value: PixelMetadata = pixValue.interpolate(at: fraction, to: pixelValue)
                    metadata[pixelKey] = value
                    break
                }
            }
        }
        return metadata
    }
}
