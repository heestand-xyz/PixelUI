//
//  Created by Anton Heestand on 2021-11-16.
//

import SwiftUI
import Resolution
import PixelKit

public struct Pixels: ViewRepresentable {
    
    @StateObject var pix: PIX
    
    let rootPixel: Pixel
    
    @State var lastMetadata: [PixelMetadatas.Key: PixelMetadata] = [:]
    var currentMetadata: [PixelMetadatas.Key: PixelMetadata] {
        PixelMetadatas.metadata(pixel: rootPixel, pix: pix)
    }
//    var encodedMetadata: [PixelMetadatas.Key: String] {
//        currentMetadata.mapValues(\.encoded)
//    }
    
    public init(resolution: Resolution, pixel: @escaping () -> (Pixel)) {
        let pixel = pixel()
        rootPixel = pixel
        _pix = StateObject(wrappedValue: PixelBuilder.pix(for: pixel, at: resolution))
    }
    
    public func makeView(context: Context) -> PIXView {
        pix.pixView
    }
    
    public func updateView(_ view: PIXView, context: Context) {
//        let metadata = encodedMetadata.compactMapValues(\.decoded)
        DispatchQueue.main.async {
            
            let transaction = context.transaction
            if !transaction.disablesAnimations,
               let animation: Animation = transaction.animation {
                print("Pixels Update with Animation")
//                Self.animate(animation: animation, timer: &object.timer) { fraction in
//                    Self.motion(pxKeyPath: \.radius, pixKeyPath: \.radius, px: self, pix: pix, at: fraction)
//                }
            } else {
                print("Pixels Update")
                update(metadata: diffedMetadata(from: currentMetadata))
            }
            
            lastMetadata = currentMetadata
        }
    }
    
    func diffedMetadata(from metadata: [PixelMetadatas.Key: PixelMetadata]) -> [PixelMetadatas.Key: PixelMetadata] {
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
}
