//
//  Observer.swift
//  ti-broish
//
//  Created by Martin Sotirov on 02.05.21.
//

import Foundation

final class Observer<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
