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
    var allMetadata: [PixelMetadatas.Key: String] {
        PixelMetadatas.metadata(pixel: rootPixel, pix: pix)
    }
    
    public init(resolution: Resolution, pixel: @escaping () -> (Pixel)) {
        let pixel = pixel()
        rootPixel = pixel
        _pix = StateObject(wrappedValue: PixelBuilder.pix(for: pixel, at: resolution))
    }
    
    public var body: some View {
        PixelView(pix: pix)
            .onAppear {
                DispatchQueue.main.async {
                    update()
                }
            }
            .onChange(of: allMetadata) { _ in
                DispatchQueue.main.async {
                    update()
                }
            }
    }
}
