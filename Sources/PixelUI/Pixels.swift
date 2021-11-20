//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-16.
//

import SwiftUI
import Resolution
import PixelKit

public struct Pixels: View {
    
    @StateObject var pix: PIX
    
    let rootPixel: Pixel
    
    @State var lastMetadata: [PixelMetadatas.Key: PixelMetadata] = [:]
    var currentMetadata: [PixelMetadatas.Key: PixelMetadata] {
        PixelMetadatas.metadata(pixel: rootPixel, pix: pix)
    }
    var encodedMetadata: [PixelMetadatas.Key: String] {
        currentMetadata.mapValues(\.encoded)
    }
    
    public init(resolution: Resolution, pixel: @escaping () -> (Pixel)) {
        let pixel = pixel()
        rootPixel = pixel
        _pix = StateObject(wrappedValue: PixelBuilder.pix(for: pixel, at: resolution))
    }
    
    public var body: some View {
        PixelView(pix: pix)
            .onAppear {
                update(metadata: diffedMetadata(from: currentMetadata))
                lastMetadata = currentMetadata
            }
            .onChange(of: encodedMetadata) { encodedMetadata in
                let metadata = encodedMetadata.compactMapValues(\.decoded)
                update(metadata: diffedMetadata(from: metadata))
                lastMetadata = metadata
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
