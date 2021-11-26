//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import RenderKit
import PixelKit
import SwiftUI
import Resolution
import PixelColor

public struct PixelFilter: Pixel {
    
    typealias Pix = FilterPIX
    
    public let pixType: PIXType = .effect(.single(.filter))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case filter
    }
    
    internal init(_ filter: FilterPIX.Filter,
                  pixel: () -> Pixel) {
        
        pixelTree = .singleEffect(pixel())
        
        for key in Key.allCases {
            switch key {
            case .filter:
                metadata[key.rawValue] = filter.rawValue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .filter:
            return pix.filter.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .filter:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.filter)
            }
        }
    }
}

public extension Pixel {
    
    func pixelFilter(_ filter: FilterPIX.Filter) -> PixelFilter {
        PixelFilter(filter, pixel: { self })
    }
}

struct PixelFilter_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
                .pixelFilter(.noir)
        }
    }
}
