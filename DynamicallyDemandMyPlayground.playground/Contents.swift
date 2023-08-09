import UIKit
import Foundation
import Combine

public func example(of description: String,
                    action: () -> Void) {
    print("\n——— Example of:", description, "———")
    action()
}
var subscriptions = Set<AnyCancellable>()
example(of: "Dynamically adjusting Demand") {
    final class IntSubscriber: Subscriber {
        typealias Input = Int
        typealias Failure = Never

        func receive(subscription: Subscription) {
            subscription.request(.max(3))
        }
        func receive(_ input: Int) -> Subscribers.Demand {
            print("Received value", input)
            switch input {
            case 1:
                return .max(2) // 1
            case 3:
                return .max(1) // 2
            default:
                return .none // 3
            }
        }
        func receive(completion: Subscribers.Completion<Never>) {
            print("Received completion", completion)
        }
    }
    let subscriber = IntSubscriber()
    let subject = PassthroughSubject<Int, Never>()
    subject.subscribe(subscriber)
    subject.send(1)
    subject.send(2)
    subject.send(3)
    subject.send(4)
    subject.send(5)
    subject.send(6)
    subject.send(7)
    subject.send(8)
    subject.send(9)
}

example(of: "Type erasure") {
  // 1
  let subject = PassthroughSubject<Int, Never>()
  // 2
  let publisher = subject.eraseToAnyPublisher()
// 3
  publisher
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
// 4
  subject.send(0)
  subject.send(1)
}
