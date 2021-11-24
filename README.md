# PixelUI

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
                
                    PixelCircle(radius: radius)
                    PixelPolygon(count: 3, radius: radius)
                    PixelStar(count: 6, radius: radius)
                }
            }
        }
    }
}
```
