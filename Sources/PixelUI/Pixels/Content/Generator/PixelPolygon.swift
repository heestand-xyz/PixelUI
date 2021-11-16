//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelPolygon: Pixel, View {
    
    @StateObject public var pix: PIX = PolygonPIX()
    var polygonPix: PolygonPIX { pix as! PolygonPIX }
    
    private let resolution: Resolution?
    
    public init(resolution: Resolution? = nil) {
        self.resolution = resolution
    }
    
    public var body: some View {
        PixelView(pix: pix)
            .onAppear {
                if let resolution = resolution {
                    polygonPix.resolution = resolution
                }
            }
            .onChange(of: resolution) { resolution in
                if let resolution = resolution {
                    polygonPix.resolution = resolution
                }
            }
    }
}

struct PixelPolygon_Previews: PreviewProvider {
    static var previews: some View {
        PixelPolygon()
    }
}
