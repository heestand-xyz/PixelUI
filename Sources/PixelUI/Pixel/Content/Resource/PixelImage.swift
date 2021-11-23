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
    }
    
    public init(_ name: String) {
        
        for key in Key.allCases {
            switch key {
            case .name:
                metadata[key.rawValue] = name
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
                
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .name:
            return ""
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
