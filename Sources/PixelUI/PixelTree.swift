//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-16.
//

import PixelKit

public indirect enum PixelTree {
    
    case generator(PIXGeneratorType)
    case resource(PIXResourceType)
    
    case singleEffect(PIXSingleEffectType, PixelTree)
    case mergerEffect(PIXMergerEffectType, PixelTree, PixelTree)
    case multiEffect(PIXMultiEffectType, [PixelTree])
    
    var pixType: PIXType {
        switch self {
        case .generator(let type):
            return .content(.generator(type))
        case .resource(let type):
            return .content(.resource(type))
        case .singleEffect(let type, _):
            return .effect(.single(type))
        case .mergerEffect(let type, _, _):
            return .effect(.merger(type))
        case .multiEffect(let type, _):
            return .effect(.multi(type))
        }
    }
}
