//
//  Created by Anton Heestand on 2021-11-16.
//

@resultBuilder
public struct PixelBuilder {
    
    public static func buildBlock(_ components: Pixel...) -> [Pixel] {
        components
    }
}
