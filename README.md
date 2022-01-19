# PixelUI

## Install

### Swift Package

~~~~swift
.package(url: "https://github.com/heestand-xyz/PixelUI", from: "1.0.0")
~~~~

## Camera Example

```swift
import SwiftUI
import PixelUI
```

```swift
struct ContentView: View {

    var body: some View {

        Pixels {
            PixelCamera()
        }
    }
}
```

## Gradients Example

<img src="https://github.com/heestand-xyz/PixelUI/blob/main/Assets/Images/PixelUI-Example-2.png?raw=true" width="300">

```swift
import SwiftUI
import PixelUI

struct GradientsView: View {
    
    var body: some View {
        
        Pixels {
                    
            PixelBlends(mode: .add) {
                
                PixelGradient(axis: .vertical, colors: [.orange, .blue])
                
                PixelNoise()
            }
            .pixelGamma(0.75)
        }
    }
}
```

## Effects Example

<img src="https://github.com/heestand-xyz/PixelUI/blob/main/Assets/Images/PixelUI-Example-3.png?raw=true" width="300">

```swift
import SwiftUI
import PixelUI

struct EffectsView: View {
    
    var body: some View {
        
        Pixels {
            
            PixelImage("Kite")
                .pixelDisplace(300) {
                    
                    PixelBlends(mode: .over) {
                        Color.gray
                        PixelBlends(mode: .multiply) {
                            PixelNoise()
                            PixelGradient(axis: .radial, colors: [.clear, .white])
                        }
                    }
                }
                .pixelLumaSaturation(0.0) {
                    PixelGradient(axis: .radial)
                }
        }
    }
}
```

## Shapes Example

<img src="https://github.com/heestand-xyz/PixelUI/blob/main/Assets/Images/PixelUI-Example-1.png?raw=true" width="300">

```swift

import SwiftUI
import PixelUI

struct ShapesView: View {
    
    var body: some View {
        
        GeometryReader { geo in
            
            let radius = geo.size.height / 2
            
            Pixels {
                
                PixelBlends(mode: .difference) {
                    
                    PixelPolygon(count: 3, radius: radius)
                        .pixelCornerRadius(radius * 0.25)
                    
                    PixelPolygon(count: 3, radius: radius * 0.55)
                        .pixelCornerRadius(radius * 0.125)
                        .pixelFlip(.y)
                    
                    PixelCircle(radius: radius * 0.15)
                    
                    PixelBlendsForEach(0..<3, mode: .difference) { index in
                        let radians = (CGFloat(index) / 3) * .pi * 2 - .pi / 2
                        return PixelCircle(radius: radius * 0.15)
                            .pixelOffset(x: cos(radians) * radius * 0.5,
                                         y: sin(radians) * radius * 0.5)
                    }
                }
            }
        }
    }
}
```
