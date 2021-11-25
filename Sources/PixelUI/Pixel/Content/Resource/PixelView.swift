////
////  Created by Anton Heestand on 2021-11-24.
////
//
//import Foundation
//import SwiftUI
//import RenderKit
//import PixelKit
//import PixelColor
//import MultiViews
//
//public struct PixelView<Content: View>: Pixel {
//
//    typealias Pix = ViewPIX
//
//    public let pixType: PIXType = .content(.resource(.view))
//
//    public let pixelTree: PixelTree = .content
//
//    public var metadata: [String : PixelMetadata] = [:]
//
//    enum Key: String, CaseIterable {
//        case view
//    }
//
//    public init(_ content: @escaping () -> Content) {
//
//        for key in Key.allCases {
//            switch key {
//            case .view:
//                metadata[key.rawValue] = FutureView(call: {
//                    MPHostingController(rootView: content()).view
//                })
//            }
//        }
//    }
//
//    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
//
//        guard let pix = pix as? Pix else { return nil }
//
//        guard let key = Key(rawValue: key) else { return nil }
//
//        switch key {
//        case .view:
//            return FutureView(call: { pix.view })
//        }
//    }
//
//    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
//
//        guard let pix = pix as? Pix else { return }
//
//        for (key, value) in metadata {
//
//            guard let key = Key(rawValue: key) else { continue }
//
//            switch key {
//            case .view:
//                guard pix.renderView == nil else { return }
//                guard let futureView = value as? FutureView else { continue }
//                pix.renderView = futureView.call()
//            }
//        }
//    }
//}
//
//struct PixelView_Previews: PreviewProvider {
//    static var previews: some View {
//        Pixels {
//            PixelView {
//                Text("Test")
//            }
//        }
//    }
//}
