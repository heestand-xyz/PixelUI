//
//  Created by Anton Heestand on 2021-11-22.
//

import Foundation
import SwiftUI
import RenderKit
import PixelKit
import PixelColor
import MultiViews

public struct PixelImage: Pixel {
    
    typealias Pix = ImagePIX
    
    public let pixType: PIXType = .content(.resource(.image))
    
    public let pixelTree: PixelTree = .content
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case name
        case image
    }
    
    var name: String?
    var imageId: UUID?
    
    public init(_ name: String) {
        
        for key in Key.allCases {
            switch key {
            case .name:
                metadata[key.rawValue] = name
            default:
                continue
            }
        }
    }
    
    public init(_ image: @autoclosure @escaping () -> MPImage) {
        
        for key in Key.allCases {
            switch key {
            case .image:
                metadata[key.rawValue] = FutureImage(call: image)
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .name:
            return name
        case .image:
            return FutureImage(call: { pix.image })
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard let pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .name:
                guard let name: String = value as? String else { continue }
                guard let image = MPImage(named: name) else { continue }
                pix.image = image
                DispatchQueue.main.async {
                    pix.render()
                }
            case .image:
                guard pix.image == nil else { return }
                guard let futureImage = value as? FutureImage else { continue }
                pix.image = futureImage.call()
            }
        }
    }
}

struct PixelImage_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelImage("kite")
        }
    }
}
