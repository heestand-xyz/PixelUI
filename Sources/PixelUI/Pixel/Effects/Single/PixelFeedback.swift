////
////  File.swift
////
////
////  Created by Anton Heestand on 2021-11-23.
////
//
//import Foundation
//import RenderKit
//import PixelKit
//import SwiftUI
//import Resolution
//
//public struct PixelFeedback: Pixel {
//
//    typealias Pix = FeedbackPIX
//
//    public let pixType: PIXType = .effect(.single(.feedback))
//
//    public var pixelTree: PixelTree
//
//    public var metadata: [String : PixelMetadata] = [:]
//
//    public init(pixel: () -> Pixel,
//                feedbackPixel: () -> Pixel) {
//
//        pixelTree = .feedback(pixel(), feedbackPixel())
//    }
//
//    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? { nil }
//
//    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {}
//}
//
//struct PixelFeedback_Previews: PreviewProvider {
//    static var previews: some View {
//        Pixels {
//            PixelFeedback {
//                PixelCircle(radius: 100)
//            } feedbackPixel: {
//                PixelStar(count: 5, radius: 100)
//            }
//        }
//    }
//}
