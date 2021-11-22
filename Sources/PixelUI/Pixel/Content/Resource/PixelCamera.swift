//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-22.
//

import Foundation
import SwiftUI
import RenderKit
import PixelKit
import PixelColor

public struct PixelCamera: Pixel {
    
    typealias Pix = CameraPIX
    
    public let pixType: PIXType = .content(.resource(.camera))
    
    public let pixelTree: PixelTree = .content
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case camera
    }
    
    public init(position camera: CameraPIX.Camera = .default) {
        
        for key in Key.allCases {
            switch key {
            case .camera:
                metadata[key.rawValue] = camera.rawValue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .camera:
            return pix.camera.rawValue
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .camera:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.camera)
            }
        }
    }
}

struct PixelCamera_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelCamera()
        }
    }
}
