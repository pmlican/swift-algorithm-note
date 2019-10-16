//
//  PriorityQueue.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/15.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

/*
 三种方式创建优先队列：
 1.有序数组
 2.二叉搜索树
 3.堆
 */

public struct PriorityQueue<T> {
    fileprivate var heap: Heap<T>
    
    public init(sort: @escaping (T, T) -> Bool) {
        heap = Heap(sort: sort)
    }
    public var isEmpty: Bool {
        return heap.isEmpty
    }
    public var count:Int {
        return heap.count
    }
    public func peek() -> T? {
        return heap.peek()
    }
    
    public mutating func enqueue(element: T) {
        heap.insert(element)
    }
    
    public mutating func dequeue() -> T? {
        return heap.remove()
    }
    
    public mutating func changePriority(index i: Int, value: T) {
        return heap.replace(index: i, value: value)
    }
}


