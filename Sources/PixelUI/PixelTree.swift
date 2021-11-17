//
//  File.swift
//  
//
//  Created by Anton Heestand on 2021-11-16.
//

import PixelKit
import CoreGraphics

public indirect enum PixelTree {
    
    case content
    
    case singleEffect(Pixel)
    case mergerEffect(Pixel, Pixel)
    case multiEffect([Pixel])
}
