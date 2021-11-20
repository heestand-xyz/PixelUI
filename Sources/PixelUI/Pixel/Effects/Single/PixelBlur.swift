////
////  Created by Anton Heestand on 2021-11-16.
////
//
//import Foundation
//import PixelKit
//import SwiftUI
//import Resolution
//
//public struct PixelBlur: Pixel {
//
//    @StateObject var pix = BlurPIX()
//
//    private let radius: CGFloat
//    
//    public init(radius: CGFloat) {
//        self.radius = radius
//    }
//
//    public var body: some View {
//        PixelView(pix: pix)
//            .onAppear {
//                pix.radius = radius
//            }
//            .onChange(of: radius) { radius in
//                pix.radius = radius
//            }
//    }
//}
//
//struct PixelBlur_Previews: PreviewProvider {
//    static var previews: some View {
//        PixelBlur(radius: 0.5)
//    }
//}
