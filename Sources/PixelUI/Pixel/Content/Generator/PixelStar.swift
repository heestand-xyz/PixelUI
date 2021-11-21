//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import PixelKit
import SwiftUI
import Resolution

public struct PixelStar: Pixel {
    
    typealias Pix = StarPIX
    
    public let pixType: PIXType = .content(.generator(.star))
    
    public var metadata: [String : PixelMetadata] = [:]
    
    public var pixelTree: PixelTree
    
    enum Key: String, CaseIterable {
        case count
    }
    
    public init(count: Int) {

        pixelTree = .content

        for key in Key.allCases {
            switch key {
            case .count:
                metadata[key.rawValue] = count
            }
        }
    }
    
    public func value(at key: String, pix: PIX) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }

        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .count:
            return pix.count
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
            
            guard let key = Key(rawValue: key) else { continue }
        
            switch key {
            case .count:
                Pixels.updateValue(pix: &pix, value: value, at: \.count)
            }
        }
    }
}

struct PixelStar_Previews: PreviewProvider {
    static var previews: some View {
        Pixels(resolution: ._1024) {
            PixelStar(count: 5)
        }
    }
}
