# PixelUI

## Install

### Swift Package

~~~~swift
.package(url: "https://github.com/heestand-xyz/PixelUI", from: "1.0.0")
~~~~

## Setup

```swift
import SwiftUI
import PixelUI
```

```swift
struct ContentView: View {
    
    var body: some View {
    
        GeometryReader { geo in
            
            let radius = geo.size.height / 2
            
            Pixels {
                
                PixelBlends(mode: .difference) {
                    
                    PixelCamera()
                    PixelCircle(radius: radius)
                    PixelPolygon(count: 3, radius: radius)
                        .pixelCornerRadius(radius * 0.1)
                }
            }
        }
    }
}
```
