//
//  Init.swift
//  TwitterLikeAnimation
//
//  Created by ZEUS on 27/6/23.
//

import Foundation

internal func Init<T>(_ object: T, block: (T) throws -> ()) rethrows -> T {
    try block(object)
    return object
}
