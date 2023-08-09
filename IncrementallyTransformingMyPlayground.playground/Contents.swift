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
example(of: "scan") {
    // 1
    var dailyGainLoss: Int { .random(in: -10...10) }
    // 2
    let august2019 = (0..<22)
        .map { _ in dailyGainLoss }
        .publisher
    // 3
    august2019
        .scan(50) { latest, current in
            max(0, latest + current)
        }
        .sink(receiveValue: { _ in })
        .store(in: &subscriptions)
}
