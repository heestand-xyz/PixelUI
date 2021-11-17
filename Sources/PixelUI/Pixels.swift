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
    
    let pixelTree: PixelTree
    
    public init(resolution: Resolution, pixel: @escaping () -> (Pixel)) {
        let pixelTree: PixelTree = pixel().pixelTree
        self.pixelTree = pixelTree
        _pix = StateObject(wrappedValue: PixelBuilder.pix(for: pixelTree, at: resolution))
    }
    
    public var body: some View {
        PixelView(pix: pix)
            .onAppear {
                update()
            }
    }
}
