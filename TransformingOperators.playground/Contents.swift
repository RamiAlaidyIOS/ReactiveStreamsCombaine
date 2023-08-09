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

// Collecting values
example(of: "collect") {
    ["A", "B", "C", "D", "E"].publisher
//        .collect() // insert Collect
        .collect(3)
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}


// Mapping values
example(of: "map") {
    // 1
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    // 2
    [123, 4, 56].publisher
    // 3
        .map {
            formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
        }
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "mapping key paths") {
    // 1
    let publisher = PassthroughSubject<CLLocation, Never>()

    // 2
    publisher
    // 3
        .map(\.coordinate.latitude, \.coordinate.longitude)
        .sink(receiveValue: { x, y in
            // 4
            print(
                "The coordinate at (\(x), \(y)) is in quadrant"
//                quadrantOf(x: x, y: y)
            )
        })
        .store(in: &subscriptions)

    // 5
    publisher.send(CLLocation(latitude: -10, longitude: 1))
    publisher.send(CLLocation(latitude: 5, longitude: 0))
}
//example(of: "tryMap") {
//    // 1
//    Just("Directory name that does not exist")
//    // 2
//        .tryMap { try
//            FileManager.default.contentsOfDirectory(atPath: $0) }
//    // 3
//        .sink(receiveCompletion: { print($0) },
//              receiveValue: { print($0) })
//        .store(in: &subscriptions)
//}

// Flattening publishers //
example(of: "flatMap") {
    struct Chatter{
        var name: String
        var message: String
        
    }
    // 1
    let charlotte = Chatter(name: "Charlotte", message: "Hi, I'm Charlotte!")
    let james = Chatter(name: "James", message: "Hi, I'm James!")
    // 2
    let chat = CurrentValueSubject<Chatter, Never>(charlotte)
    // 3
    chat
        .sink(receiveValue: { print($0.message) })
        .store(in: &subscriptions)
    // 4
//    charlotte.message = "Charlotte: How's it going?"
    // 5
    chat.value = james
}
example(of: "replaceNil") {
    // 1
    ["A", nil, "C"].publisher
        .replaceNil(with: "-" as String?) // 2
        .map { $0! }
        .sink(receiveValue: { print($0 as Any) }) // 3
        .store(in: &subscriptions)

}

example(of: "replaceEmpty(with:)") {
  // 1
  let empty = Empty<Int, Never>()
// 2
  empty
    .replaceEmpty(with: 1)
    .sink(receiveCompletion: { print($0) },
          receiveValue: { print($0) })
    .store(in: &subscriptions)

}
