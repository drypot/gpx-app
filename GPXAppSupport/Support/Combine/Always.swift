//
//  Always.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 5/17/24.
//

/*
 A Combine publisher that repeatedly emits the same value as long as there is demand
 https://gist.github.com/sharplet/ddf2debb7eccff40d307027f4c6d9f0c
 */

import Foundation
import Combine

// Sequence

struct AlwaysSequence<Output>: Sequence, IteratorProtocol  {
    let output: Output
    
    mutating func next() -> Output? {
        return output
    }
}

// Combine Publisher

struct AlwaysPublisher<Output>: Publisher {
    typealias Failure = Never
    let output: Output

    func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        let subscription = Subscription(output: output, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

private extension AlwaysPublisher {
    final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == Output, S.Failure == Failure {
        
        private let output: Output
        private var subscriber: S?
        
        init(output: Output, subscriber: S) {
            self.output = output
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            var demand = demand
            while let subscriber, demand > 0 {
                demand -= 1
                demand += subscriber.receive(output)
            }
        }
        
        func cancel() {
            subscriber = nil
        }
    }
}
