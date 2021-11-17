//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-16.
//

import PixelKit
import CoreGraphics

public indirect enum PixelTree {
    
    public typealias Metadata = [String: CGFloat]
    
    case generator(PIXGeneratorType, Metadata)
    case resource(PIXResourceType, Metadata)
    
    case singleEffect(PIXSingleEffectType, Metadata, PixelTree)
    case mergerEffect(PIXMergerEffectType, Metadata, PixelTree, PixelTree)
    case multiEffect(PIXMultiEffectType, Metadata, [PixelTree])
    
    var pixType: PIXType {
        switch self {
        case .generator(let type, _):
            return .content(.generator(type))
        case .resource(let type, _):
            return .content(.resource(type))
        case .singleEffect(let type, _, _):
            return .effect(.single(type))
        case .mergerEffect(let type, _, _, _):
            return .effect(.merger(type))
        case .multiEffect(let type, _, _):
            return .effect(.multi(type))
        }
    }
    
    var metadata: Metadata {
        switch self {
        case .generator(_, let metadata):
            return metadata
        case .resource(_, let metadata):
            return metadata
        case .singleEffect(_, let metadata, _):
            return metadata
        case .mergerEffect(_, let metadata, _, _):
            return metadata
        case .multiEffect(_, let metadata, _):
            return metadata
        }
    }
}
