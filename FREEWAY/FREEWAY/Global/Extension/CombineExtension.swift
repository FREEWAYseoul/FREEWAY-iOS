//
//  CombineExtension.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/13.
//

import Foundation
import Combine

extension Publisher {
    func withRetained<T: AnyObject>(_ value: T) -> Publishers.Map<Self, (T, Self.Output)> {
        map { [unowned value] in
            return (value, $0)
        }
    }

    func withOnlyRetained<T: AnyObject>(_ value: T) -> Publishers.Map<Self, T> {
        map { [unowned value] _ in
            return value
        }
    }
}
