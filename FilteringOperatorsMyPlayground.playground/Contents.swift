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

example(of: "filter") {
    // 1
    let numbers = (1...10).publisher
    // 2
    numbers
        .filter { $0.isMultiple(of: 3) }
        .sink(receiveValue: { n in
            print("\(n) is a multiple of 3!")
        })
        .store(in: &subscriptions)
}

example(of: "removeDuplicates") {
    // 1
    let words = "hey hey there! want to listen to mister mister ?"
        .components(separatedBy: " ")
    // 2
        .publisher
    words
        .removeDuplicates()
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "compactMap") {
    // 1
    let strings = ["a", "1.24", "3",
                   "def", "45", "0.23"].publisher
    // 2
    strings
        .compactMap { Float($0) }
        .sink(receiveValue: {
            // 3
            print($0) })
        .store(in: &subscriptions)
}

example(of: "ignoreOutput") {
    // 1
    let numbers = (1...10_000).publisher
    // 2
    numbers
        .ignoreOutput()
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}


// Finding values
example(of: "first(where:)") {
    // 1
    let numbers = (1...100).publisher
    // 2
    numbers
        .print("numbers")
        .first(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)

}
example(of: "last(where:)") {
    // 1
    let numbers = (1...9).publisher
    // 2
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}
example(of: "last(where:)") {
    let numbers = PassthroughSubject<Int, Never>()
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
    numbers.send(1)
    numbers.send(2)
    numbers.send(3)
    numbers.send(4)
    numbers.send(5)
    numbers.send(completion: .finished)
}
example(of: "dropFirst") {
  // 1
  let numbers = (1...10).publisher
// 2
  numbers
    .dropFirst(8)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

example(of: "drop(while:)") {
  // 1
  let numbers = (1...10).publisher
// 2
  numbers
//    .drop(while: { $0 % 5 != 0 })
        .drop(while: {
          print("x")
          return $0 % 5 != 0
        })
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

example(of: "drop(untilOutputFrom:)") {
    // 1
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    // 2
    taps
        .drop(untilOutputFrom: isReady)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    // 3
    (1...5).forEach { n in
        taps.send(n)
        if n == 3 {
            isReady.send()
        }
    }
}

example(of: "prefix") {
    // 1
    let numbers = (1...10).publisher
    // 2
    numbers
        .prefix(5)
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}
example(of: "prefix(while:)") {
    // 1
    let numbers = (1...10).publisher
    // 2
    numbers
        .prefix(while: { $0 < 3 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}
example(of: "prefix(untilOutputFrom:)") {
    // 1
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    // 2
    taps
        .prefix(untilOutputFrom: isReady)
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
    // 3
    (1...5).forEach { n in
        taps.send(n)
        if n == 3 {
            isReady.send()
        }
    }
}
