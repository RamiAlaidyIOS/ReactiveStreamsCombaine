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

example(of: "combineLatest") {
    // 1
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    // 2
    publisher1
        .combineLatest(publisher2)
        .sink(receiveCompletion: { _ in print("Completed") },
              receiveValue: { print("P1: \($0), P2: \($1)") })
        .store(in: &subscriptions)
    // 3
    publisher1.send(1)
    publisher1.send(2)
    publisher2.send("a")
    publisher2.send("b")
    publisher1.send(3)
    publisher2.send("c")
    // 4
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}

example(of: "zip") {
    // 1
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    // 2
    publisher1
        .zip(publisher2)
        .sink(receiveCompletion: { _ in print("Completed") },
              receiveValue: { print("P1: \($0), P2: \($1)") })
        .store(in: &subscriptions)
    // 3
    publisher1.send(1)
    publisher1.send(2)
    publisher2.send("a")
    publisher2.send("b")
    publisher1.send(3)
    publisher2.send("c")
    publisher2.send("d")
    // 4
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}
