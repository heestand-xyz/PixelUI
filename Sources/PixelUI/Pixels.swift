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
    
    public init(resolution: Resolution, pixel: @escaping () -> (Pixel)) {
        _pix = StateObject(wrappedValue: PixelBuilder.pix(for: pixel().pixelTree, at: resolution))
    }
    
    public var body: some View {
        PixelView(pix: pix)
    }
}
