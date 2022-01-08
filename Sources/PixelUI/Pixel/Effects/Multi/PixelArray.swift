//
//  Created by Anton Heestand on 2021-11-16.
//

import Foundation
import SwiftUI
import Resolution
import RenderKit
import PixelKit
import PixelColor

public struct PixelCoordinate {
    public var offset: CGPoint
    public var scale: CGFloat
    public var angle: Angle
    public var opacity: CGFloat
    public var index: Int
    public init(offset: CGPoint = .zero, scale: CGFloat = 1.0, angle: Angle = .zero, opacity: CGFloat = 1.0, index: Int = 0) {
        self.offset = offset
        self.scale = scale
        self.angle = angle
        self.opacity = opacity
        self.index = index
    }
}

public struct PixelArray: Pixel {
    
    typealias Pix = ArrayPIX
    
    public var pixType: PIXType = .effect(.multi(.array))
    
    public var pixelTree: PixelTree
    
    public var metadata: [String : PixelMetadata] = [:]
    
    enum Key: String, CaseIterable {
        case blendMode
        case backgroundColor
    }
    
    public init(mode blendMode: RenderKit.BlendMode,
                coordinates: [PixelCoordinate],
                @PixelBuilder pixels: () -> [Pixel]) {

        pixelTree = .multiEffect(pixels())
        
        for (index, coordinate) in coordinates.enumerated() {
            metadata["coordinate-offset-\(index)"] = coordinate.offset
            metadata["coordinate-scale-\(index)"] = coordinate.scale
            metadata["coordinate-angle-\(index)"] = coordinate.angle
            metadata["coordinate-opacity-\(index)"] = coordinate.opacity
            metadata["coordinate-index-\(index)"] = coordinate.index
        }
        
        for key in Key.allCases {
            switch key {
            case .blendMode:
                metadata[key.rawValue] = blendMode.rawValue
            default:
                continue
            }
        }
    }
    
    public func value(at key: String, pix: PIX, size: CGSize) -> PixelMetadata? {
        
        guard let pix = pix as? Pix else { return nil }
        
        if key.starts(with: "coordinate") {
            guard let indexString = key.split(separator: "-").last else { return nil }
            guard let index = Int(indexString) else { return nil }
            guard pix.coordinates.indices.contains(index) else { return nil }
            if key.contains("offset") {
                return Pixels.inZeroViewSpace(pix.coordinates[index].position, size: size)
            } else if key.contains("scale") {
                return pix.coordinates[index].scale
            } else if key.contains("angle") {
                return Pixels.asAngle(pix.coordinates[index].rotation)
            } else if key.contains("opacity") {
                return pix.coordinates[index].opacity
            } else if key.contains("index") {
                return pix.coordinates[index].textureIndex
            }
        }
        
        guard let key = Key(rawValue: key) else { return nil }
        
        switch key {
        case .blendMode:
            return pix.blendMode.rawValue
        case .backgroundColor:
            return pix.backgroundColor
        }
    }
    
    public func update(metadata: [String : PixelMetadata], pix: PIX, size: CGSize) {
        
        guard var pix = pix as? Pix else { return }
        
        for (key, value) in metadata {
            
            if key.starts(with: "coordinate") {
                guard let indexString = key.split(separator: "-").last else { continue }
                guard let index = Int(indexString) else { continue }
                if key.contains("offset") {
                    guard let offset = value as? CGPoint else { continue }
                    let position = Pixels.inZeroPixelSpace(offset, size: size)
                    if pix.coordinates.indices.contains(index) {
                        pix.coordinates[index].position = position
                    } else {
                        pix.coordinates.append(Coordinate(position))
                    }
                } else if key.contains("scale") {
                    guard let scale = value as? CGFloat else { continue }
                    if pix.coordinates.indices.contains(index) {
                        pix.coordinates[index].scale = scale
                    } else {
                        pix.coordinates.append(Coordinate(.zero, scale: scale))
                    }
                } else if key.contains("angle") {
                    guard let angle = value as? Angle else { continue }
                    let rotation = Pixels.asRotation(angle)
                    if pix.coordinates.indices.contains(index) {
                        pix.coordinates[index].rotation = rotation
                    } else {
                        pix.coordinates.append(Coordinate(.zero, rotation: rotation))
                    }
                } else if key.contains("opacity") {
                    guard let opacity = value as? CGFloat else { continue }
                    if pix.coordinates.indices.contains(index) {
                        pix.coordinates[index].opacity = opacity
                    } else {
                        pix.coordinates.append(Coordinate(.zero, opacity: opacity))
                    }
                } else if key.contains("index") {
                    guard let index = value as? Int else { continue }
                    if pix.coordinates.indices.contains(index) {
                        pix.coordinates[index].textureIndex = index
                    } else {
                        pix.coordinates.append(Coordinate(.zero, textureIndex: index))
                    }
                }
            }
            
            guard let key = Key(rawValue: key) else { continue }
        
            switch key {
            case .blendMode:
                Pixels.updateRawValue(pix: &pix, value: value, at: \.blendMode)
            case .backgroundColor:
                Pixels.updateValue(pix: &pix, value: value, at: \.backgroundColor)
            }
        }
        
        pix.render()
    }
}

public extension PixelArray {
    
    func pixelBackgroundColor(_ color: Color) -> Self {
        var pixel = self
        pixel.metadata[Key.backgroundColor.rawValue] = PixelColor(color)
        return pixel
    }
}

struct PixelArray_Previews: PreviewProvider {
    static var previews: some View {
        Pixels {
            PixelArray(mode: .add, coordinates: [
                PixelCoordinate(opacity: 0.333),
                PixelCoordinate(offset: CGPoint(x: 200 * value, y: 0), angle: Angle(degrees: -180 * value), opacity: 0.333, index: 1),
                PixelCoordinate(offset: CGPoint(x: -200 * value, y: 0), angle: Angle(degrees: 180 * value), opacity: 0.333, index: 2),
            ]) {
                PixelCircle(radius: 100)
                PixelStar(count: 5, radius: 100)
                PixelPolygon(count: 3, radius: 100)
            }
        }
    }
}
