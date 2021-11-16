//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelCircle: Pixel, View {
    
    @StateObject public var pix: PIX = CirclePIX()
    var circlePix: CirclePIX { pix as! CirclePIX }
    
    private let resolution: Resolution?
    
    public init(resolution: Resolution? = nil) {
        self.resolution = resolution
    }
    
    public var body: some View {
        PixelView(pix: pix)
            .onAppear {
                if let resolution = resolution {
                    circlePix.resolution = resolution
                }
            }
            .onChange(of: resolution) { resolution in
                if let resolution = resolution {
                    circlePix.resolution = resolution
                }
            }
    }
}

struct PixelCircle_Previews: PreviewProvider {
    static var previews: some View {
        PixelCircle()
    }
}
