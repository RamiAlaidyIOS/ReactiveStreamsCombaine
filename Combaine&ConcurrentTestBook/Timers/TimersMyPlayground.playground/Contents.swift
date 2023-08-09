
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

example(of: "RunLoop") {

    let runLoop = RunLoop.main
    let subscription = runLoop.schedule(
      after: runLoop.now,
      interval: .seconds(1),
      tolerance: .milliseconds(100)
    ){
      print("Timer fired")
    }
}

// Using the Timer class

example(of: "Time Calss") {

    let subscription = Timer
        .publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
        .scan(0) { counter, _ in counter + 1 }
        .sink { counter in
            print("Counter is \(counter)")
        }

}

example(of: "share") {

    let shared = URLSession.shared
      .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
      .map(\.data)
//      .print("shared")
      .share()

    print("subscribing first")

    let subscription1 = shared
        .sink(receiveCompletion: { _ in },
      receiveValue: {
          print("subscription1 received: '\($0)'")
      }
    )
//    print("subscribing second")
//    var subscription2: AnyCancellable? = nil
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        print("subscribing second")

      let subscription2 = shared
            .sink(receiveCompletion: {counter in
                print("subscription2 completion \(counter)")
            }, receiveValue: { resiveData in
                print("subscription2 received \(resiveData)")
            })
    }
}
