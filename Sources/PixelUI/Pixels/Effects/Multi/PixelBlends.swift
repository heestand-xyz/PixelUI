//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import SwiftUI
import Resolution
import RenderKit
import PixelKit

public struct PixelBlends: Pixel, View {
    
    @StateObject public var pix: PIX = BlendsPIX()
    var blendsPix: BlendsPIX { pix as! BlendsPIX }
    
    private let pixels: [Pixel]
    
    public init(@PixelBuilder pixels: () -> [Pixel]) {
        self.pixels = pixels()
    }
    
    public var body: some View {
        PixelView(pix: pix)
            .onAppear {
                blendsPix.inputs = pixels.map(\.pix) as? [PIX & NODEOut] ?? []
            }
//            .onChange(of: pixels) { pixels in
//                blendsPix.inputs = pixels.map(\.pix) as? [PIX & NODEOut] ?? []
//            }
    }
}

struct PixelBlends_Previews: PreviewProvider {
    static var previews: some View {
        PixelBlends {
            PixelCircle()
            PixelPolygon()
        }
    }
}
