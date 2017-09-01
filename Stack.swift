//
//  Stack.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 01/06/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation

public struct Stack<T> {
    fileprivate var array = [T]()
    
    public init(array: [T]) {
        self.array = array
    }
    
    public var isEmpty: Bool {
        return self.array.isEmpty
    }
    
    public var count: Int {
        return self.array.count
    }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return self.array.popLast()
    }
    
    public var top: T? {
        return self.array.last
    }
}
