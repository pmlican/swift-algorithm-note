//
//  Deque.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/15.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation


public struct Deque<T> {
    private var array = [T]()
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    public mutating func equeueFront(_ element: T) {
        array.insert(element, at: 0)
    }
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    public mutating func dequeueBack() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.popLast()
        }
    }
    
    public func peerFront() -> T? {
        return array.first
    }
    
    public func peerBack() -> T? {
        return array.last
    }
    
}


public struct Deque1<T> {
    private var array: [T?]
    private var head: Int
    private var capacity: Int
    private var originalCapactiy: Int
    
    public init(_ capacity: Int = 10) {
        self.capacity = max(capacity, 1)
        originalCapactiy = self.capacity
        array = [T?](repeating: nil, count: capacity)
        head = capacity
    }
    
    public var isEmpty: Bool {
        return count == 0
    }
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else {
            return nil
        }
        array[head] = nil
        head += 1
        
        //处理出队后，空位太多导致浪费问题, 减少至25%
        if capacity >= originalCapactiy && head >= capacity*2 {
            let amountToRemove = capacity + capacity/2
            array.removeFirst(amountToRemove)
            head -= amountToRemove
            capacity /= 2
        }
        
        return element
    }
    
    public mutating func enqueueFront(_ element: T) {
        //处理前面空位填满情况
        if head == 0 {
            capacity *= 2
            let emptySpace = [T?](repeating: nil, count: capacity)
            array.insert(contentsOf: emptySpace, at: 0)
            head = capacity
        }
        
        head -= 1
        array[head] = element
    }
    
    public mutating func dequeueBack() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeLast()
        }
    }
    
    public func peekBack() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.last!
        }
    }
    
}
