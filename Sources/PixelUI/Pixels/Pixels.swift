//
//  Created by Anton Heestand on 2021-11-16.
//

import SwiftUI
import Resolution
import PixelKit

public struct Pixels: ViewRepresentable {
    
    @StateObject var pix: PIX
    
    let rootPixel: Pixel
    
    static var lastMetadata: [UUID: [PixelMetadatas.Key: PixelMetadata]] = [:]
//    @State var lastMetadata: [PixelMetadatas.Key: PixelMetadata] = [:]
    var pixelMetadata: [PixelMetadatas.Key: PixelMetadata] {
        PixelMetadatas.pixelMetadata(pixel: rootPixel, pix: pix)
    }
//    var encodedMetadata: [PixelMetadatas.Key: String] {
//        currentMetadata.mapValues(\.encoded)
//    }
    
    @State var timer: Timer?
    
    public init(resolution: Resolution, pixel: @escaping () -> (Pixel)) {
        let pixel = pixel()
        rootPixel = pixel
        _pix = StateObject(wrappedValue: PixelBuilder.pix(for: pixel, at: resolution))
    }
    
    public func makeView(context: Context) -> PIXView {
        Self.lastMetadata[pix.id] = [:]
        return pix.pixView
    }
    
    public func updateView(_ view: PIXView, context: Context) {
//        let metadata = encodedMetadata.compactMapValues(\.decoded)

        let diffedPixelMetadata = diffedMetadata(from: pixelMetadata, with: Self.lastMetadata[pix.id] ?? [:])
        Self.lastMetadata[pix.id] = pixelMetadata
        
        print("Pixels Update View", diffedPixelMetadata.count)

        DispatchQueue.main.async {
            
            let pixMetadata = PixelMetadatas.pixMetadata(pixel: rootPixel, pix: pix)
            
            let transaction = context.transaction
            if !transaction.disablesAnimations,
               let animation: Animation = transaction.animation {
                print("Pixels Update with Animation")
                Self.animate(animation: animation, timer: &timer) { fraction in
                    let interpolatedMetadata = interpolateMetadata(at: fraction, pixelMetadata: diffedPixelMetadata, pixMetadata: pixMetadata)
                    update(metadata: interpolatedMetadata)
                }
            } else {
                print("Pixels Update")
                update(metadata: diffedPixelMetadata)
            }
            
        }
    }
    
    func diffedMetadata(from metadata: [PixelMetadatas.Key: PixelMetadata],
                        with lastMetadata: [PixelMetadatas.Key: PixelMetadata]) -> [PixelMetadatas.Key: PixelMetadata] {
        var diffedMetadata: [PixelMetadatas.Key: PixelMetadata] = [:]
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
                             pixelMetadata: [PixelMetadatas.Key: PixelMetadata],
                             pixMetadata: [PixelMetadatas.Key: PixelMetadata]) -> [PixelMetadatas.Key: PixelMetadata] {
        var metadata: [PixelMetadatas.Key: PixelMetadata] = [:]
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
