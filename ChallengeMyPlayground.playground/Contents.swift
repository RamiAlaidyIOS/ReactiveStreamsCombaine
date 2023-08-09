import UIKit
import Foundation
import Combine
import CoreLocation
public func example(of description: String,
                    action: () -> Void) {
    print("\n——— Example of:", description, "———")
    action()
}
var subscriptions = Set<AnyCancellable>()
example(of: "Challenge opertior") {
    // 1
     let isReady = PassthroughSubject<Void, Never>()
     let taps = PassthroughSubject<Int, Never>()
   // 2

    // 3
     let numbers = (1...100)
   // 4
     taps
       .drop(untilOutputFrom: isReady)
       .prefix(20)
       .filter({ $0 % 2 == 0 })
       .sink(receiveValue: { print($0) })
       .store(in: &subscriptions)

    numbers.forEach { i in
        taps.send(i)

        if i == 50{
            isReady.send()
        }
        if i > (50 + 20){
            isReady.send()
        }
    }
}
