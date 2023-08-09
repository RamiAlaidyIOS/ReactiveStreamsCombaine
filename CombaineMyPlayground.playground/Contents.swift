import UIKit
import Foundation
import Combine

public func example(of description: String,
                    action: () -> Void) {
    print("\n——— Example of:", description, "———")
    action()
}

example(of: "Publisher") {
    // 1
    let myNotification = Notification.Name("MyNotification")
    // 2
    let publisher = NotificationCenter.default
        .publisher(for: myNotification, object: nil)
    // 3
    let center = NotificationCenter.default
    // 4
    let observer = center.addObserver(
        forName: myNotification,
        object: nil,
        queue: nil) { notification in
            print("Notification received!")
        }
    // 5
    center.post(name: myNotification, object: nil)
    // 6
    center.removeObserver(observer)
}

example(of: "Subscriber") {

    // 1
    let myNotification = Notification.Name("MyNotification")
    // 2
    let publisher = NotificationCenter.default
        .publisher(for: myNotification, object: nil)
    // 3
    let center = NotificationCenter.default
    let subscription = publisher
        .sink { _ in
            print("Notification received from a publisher!")
        }
    // 4
//    let observer = center.addObserver(
//        forName: myNotification,
//        object: nil,
//        queue: nil) { notification in
//            print("Notification received!")
//        }
//    // 5
//    center.post(name: myNotification, object: nil)
//    // 6
//    center.removeObserver(observer)

    // 1
    center.post(name: myNotification, object: nil)
    // 2
    subscription.cancel()
}


example(of: "Just") {
    // 1
    let just = Just("Hello world!")
    // 2
    _ = just
        .sink(
            receiveCompletion: {
                print("Received completion", $0)
            },
            receiveValue: {
                print("Received value", $0)
            })
}

example(of: "assign(to:on:)") {
    // 1
    class SomeObject {
        var value: String = "" {
            didSet {
                print(value)
            }
        } }
    // 2
    let object = SomeObject()
    // 3
    let publisher = ["Hello", "world!"].publisher
    // 4
    _ = publisher
        .assign(to: \.value, on: object)

}


example(of: "Custom Subscriber") {
    // 1
    let publisherNum = (1...6).publisher
    let publisher = ["A", "B", "C", "D", "E", "F"].publisher
    // 2
    final class IntSubscriber: Subscriber {

        // 3
        typealias Input = String

        typealias Failure = Never
        // 4
        func receive(subscription: Subscription) {
            subscription.request(.max(7))
        }
        // 5
        func receive(_ input: Int) -> Subscribers.Demand {
            print("Received value", input)
            return .unlimited
        }
        func receive(_ input: String) -> Subscribers.Demand {
            print("Received value", input)
            return .unlimited
        }
        // 6
        func receive(completion: Subscribers.Completion<Never>) {
            print("Received completion", completion)
        }
    }
    let subscriber = IntSubscriber()
    publisher.subscribe(subscriber)
}

