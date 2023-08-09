import UIKit
import Foundation
import Combine

public func example(of description: String,
                    action: () -> Void) {
    print("\n——— Example of:", description, "———")
    action()
}
var subscriptions = Set<AnyCancellable>()
example(of: "PassthroughSubject") {
    // 1
    enum MyError: Error {
        case test }
    // 2
    final class StringSubscriber: Subscriber {
        typealias Input = String
        typealias Failure = MyError
        func receive(subscription: Subscription) {
            subscription.request(.max(2))
        }
        func receive(_ input: String) -> Subscribers.Demand {
            print("Received value", input)
            // 3
            return input == "World" ? .max(1) : .none
        }
        func receive(completion: Subscribers.Completion<MyError>) {
            print("Received completion", completion)
        }
    }
    // 4
    let subscriber = StringSubscriber()
    // 5
    let subject = PassthroughSubject<String, MyError>()
    // 6
    subject.subscribe(subscriber)
    // 7
    let subscription = subject
      .sink(
        receiveCompletion: { completion in
          print("Received completion (sink)", completion)
        },
        receiveValue: { value in
          print("Received value (sink)", value)
        }
    )
    subject.send("Hello")
    subject.send("World")

    // 8
    subscription.cancel()
    // 9
    subject.send("Still there?")
//    subject.send(completion: .failure(MyError.test))
    subject.send(completion: .finished)
    subject.send("How about another one?")
}


/////
example(of: "CurrentValueSubject") {
  // 1
  let subject = CurrentValueSubject<Int, Never>(0)
// 2
  subject
    .print()
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions) // 3

    subject.send(1)
    subject.send(2)
    print("Value 1:- ",subject.value)

    subject.value = 3
    print("Value 2:- ",subject.value)

    subject
       .print()
      .sink(receiveValue: { print("Second subscription:", $0) })
      .store(in: &subscriptions)

    subject.send(completion: .finished)


}
