//
//  Created by Anton Heestand on 2021-11-24.
//

import MultiViews

protocol Future {
    associatedtype T: Any
    var call: () -> T? { get }
}

struct FutureImage: Future {
    var call: () -> MPImage?
}
