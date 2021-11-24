//
//  Created by Anton Heestand on 2021-11-23.
//

import Foundation
import SwiftUI
import CoreGraphics
import RenderKit
import PixelKit
import PixelColor

extension PixelColor: Pixel {
    
    typealias Pix = ColorPIX
    
    public var pixType: PIXType { .content(.generator(.color)) }
    
    public var pixelTree: PixelTree { .content }
    
    public var size: CGSize? {
        get { nil }
        set {}
    }
    
    public var metadata: [String : PixelMetadata] {
        get { [Key.color.rawValue: self] }
        set {}
    }
    
    enum Key: String, CaseIterable {
        case color
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .color:
            return pix.color
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard let pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .color:
                guard let color = value as? PixelColor else { continue }
                pix.color = color
            }
        }
    }
}

extension Color: Pixel {
    
    typealias Pix = ColorPIX
    
    public var pixType: PIXType { .content(.generator(.color)) }
    
    public var pixelTree: PixelTree { .content }
    
    public var size: CGSize? {
        get { nil }
        set {}
    }
    
    public var metadata: [String : PixelMetadata] {
        get { [Key.color.rawValue: PixelColor(self)] }
        set {}
    }
    
    enum Key: String, CaseIterable {
        case color
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .color:
            return pix.color
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard let pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .color:
                guard let color = value as? PixelColor else { continue }
                pix.color = color
            }
        }
    }
}
