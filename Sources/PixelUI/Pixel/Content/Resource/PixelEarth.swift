//
//  Created by Anton Heestand on 2021-11-22.
//

import Foundation
import SwiftUI
import RenderKit
import PixelKit
import PixelColor

/// Pixel Earth
///
/// The span is in degrees between 0.0 and 180.0.
public struct PixelEarth: Pixel {
    
    typealias Pix = EarthPIX
    
    public let pixType: PIXType = .content(.resource(.maps))
    
    public let pixelTree: PixelTree = .content
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case mapType
        case coordinate
        case span
        case showsBuildings
        case showsPointsOfInterest
        case darkMode
    }
    
    public init(mapType: EarthPIX.MapType = .standard,
                            latitude: CGFloat,
                            longitude: CGFloat,
                            span: CGFloat) {
        self.init(mapType: mapType, coordinate: CGPoint(x: longitude, y: latitude), span: span)
    }
    
    public init(mapType: EarthPIX.MapType = .standard,
                coordinate: CGPoint,
                span: CGFloat) {
        
        for key in Key.allCases {
            switch key {
            case .mapType:
                metadata[key.rawValue] = mapType.rawValue
            case .coordinate:
                metadata[key.rawValue] = coordinate
            case .span:
                metadata[key.rawValue] = span
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .mapType:
            return pix.mapType.rawValue
        case .coordinate:
            return pix.coordinate
        case .span:
            return pix.span
        case .showsBuildings:
            return pix.showsBuildings
        case .showsPointsOfInterest:
            return pix.showsPointsOfInterest
        case .darkMode:
            return pix.darkMode
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
        
            guard let key = Key(rawValue: key) else { continue }
            
            switch key {
            case .mapType:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.mapType)
            case .coordinate:
                Pixels.updateValue(pix: &pix, value: value, at: \.coordinate)
            case .span:
                Pixels.updateValue(pix: &pix, value: value, at: \.span)
            case .showsBuildings:
                Pixels.updateValue(pix: &pix, value: value, at: \.showsBuildings)
            case .showsPointsOfInterest:
                Pixels.updateValue(pix: &pix, value: value, at: \.showsPointsOfInterest)
            case .darkMode:
                Pixels.updateValue(pix: &pix, value: value, at: \.darkMode)
            }
        }
    }
}

public extension PixelEarth {
    
    func pixelEarthShowBuildings() -> Self {
        var pixel = self
        pixel.metadata[Key.showsBuildings.rawValue] = true
        return pixel
    }
    
    func pixelEarthShowPointsOfInterest() -> Self {
        var pixel = self
        pixel.metadata[Key.showsPointsOfInterest.rawValue] = true
        return pixel
    }
    
    func pixelEarthDarkMode() -> Self {
        var pixel = self
        pixel.metadata[Key.darkMode.rawValue] = true
        return pixel
    }
}

struct PixelEarth_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelEarth(latitude: 59.3293, longitude: 18.0686, span: 1.0)
        }
    }
}
