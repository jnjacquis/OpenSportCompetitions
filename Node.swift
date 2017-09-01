//
//  Node.swift
//  OpenSportCompetitions
//
//  Created by Jean-Noel on 01/06/2017.
//  Copyright © 2017 jjs. All rights reserved.
//

import Foundation

class Node<T> {
    
    var value: T
    var level: Int?
    weak var parent: Node<T>?
    
    var children: [Node<T>] = []
    
    init(value: T) {
        self.value = value
    }
    
    init(value: T, level: Int) {
        self.value = value
        self.level = level
    }
    
    func add(child: Node<T>) {
        // Force child's level to current + 1
        child.level = self.level! + 1
        children.append(child)
        child.parent = self
    }
    
    func isRoot() -> Bool {
        if self.level == 0 {
            return true
        } else {
            return false
        }
    }
}
