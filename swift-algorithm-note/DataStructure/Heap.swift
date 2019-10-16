//
//  Heap.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/15.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

//重点是理解shiftDown和shiftUp操作，因为插入和
public struct Heap<T> {
    
    var nodes = [T]()
    
    //顺序准则
    private var orderCriteria: (T, T) -> Bool
    
    //创建一个空的heap
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
    }
    //根据数组创建堆
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
        configureHeap(from: array)
    }
    
    public mutating func insert(_ value: T) {
        nodes.append(value)
        shiftUp(nodes.count - 1)
    }
    
    //remove root node
    @discardableResult
    public mutating func remove() -> T? {
        guard !nodes.isEmpty else {return nil}
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            let value = nodes[0]
            //用最后node作为堆顶
            nodes[0] = nodes.removeLast()
            //然后做shiftDown操作，调整符合堆属性
            shiftDown(0)
            //返回移除的堆顶
            return value
        }
    }
    
    //删除任意节点
    @discardableResult
    public mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else {return nil}
        let size = nodes.count - 1
        //判断是否最后一个叶子节点
        if index != size {
            //与最后一个交换，数组最后一个元素肯定是叶子节点
            nodes.swapAt(index, size)
            //做shiftDown 和 shiftUp操作
            shiftDown(from: index, until: size)
            shiftUp(index)
        }
        //如果没有交换证明是叶子节点，移除最后一个节点
        return nodes.removeLast()
    }
    
    
    private mutating func configureHeap(from array: [T]) {
        nodes = array
        //The leaf nodes are always located at array indices floor(n/2) to n-1. We will make use of this fact to quickly build up the heap from an array.
        for i in stride(from: (nodes.count/2 - 1), through: 0, by: -1) {
            shiftDown(i)
        }
    }
    
    internal mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, until: nodes.count)
    }
    
    internal mutating func shiftDown(from index: Int, until endIndex: Int) {
        let leftChildIndex = self.leftChildIndex(ofIndex: index)
        let rightChildIndex = leftChildIndex + 1
        
        var first = index
        
        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex], nodes[first]) {
            first = leftChildIndex
        }
        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex], nodes[first]) {
            first = rightChildIndex
        }
        if first == index {return}
        
        nodes.swapAt(index, first)
        shiftDown(from: first, until: endIndex)
    }
    
    internal mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        //比较两个数是否符合堆关系，并且不能<0,0索引为堆顶
        while childIndex > 0 && orderCriteria(child,nodes[parentIndex]) {
            nodes[childIndex] = nodes[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        nodes[childIndex] = child
    }
    
    //@inline(__always)：如果可以的话，指示编译器始终内联方法。
    //@inline(never)：指示编译器永不内联方法。
    //在编程中，函数内联 是一种编译器优化技术，它通过使用方法的内容替换直接调用该方法，就相当于假装该方法并不存在一样，这种做法在很大程度上优化了性能。
    
    //缺点:内联会增加二进制文件变大
    //另外一种用途是，利用这个特性来混淆付费内容代码,让App更加难逆向，因为要把所有使用的地方都替换才行

    /*
     formulas: 公式
     parent(i) = floor((i - 1)/2)
     left(i)   = 2i + 1
     right(i)  = left(i) + 1 = 2i + 2

     */
    @inline(__always) internal func leftChildIndex(ofIndex i: Int) -> Int {
        //因为堆内部用数组构成，所以没有父子指针开销，所以用的是下标，用公式计算各个节点的关系
        return 2*i + 1
    }
    
    @inline(__always) internal func rightChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 2
    }
    
    @inline(__always) internal func parentIndex(ofIndex i: Int) -> Int {
        return (i - 1) / 2
    }
    
    public var isEmpty: Bool {
        return nodes.isEmpty
    }
    
    public var count: Int {
        return nodes.count
    }
    public func peek() -> T? {
        return nodes.first
    }
}


extension Heap {
    //添加序列到heap, 像数组就是遵守Sequence协议的序列
    public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for value in sequence {
            insert(value)
        }
    }
    
    public mutating func replace(index i: Int, value: T) {
        guard i < nodes.count else {return}
        remove(at: i)
        insert(value)
    }
}

extension Heap where T: Equatable {
    
    public func index(of node: T) -> Int? {
        return nodes.firstIndex(of: node)
    }
    
    public mutating func remove(node: T) -> T? {
        if let index = index(of: node) {
            return remove(at: index)
        }
        return nil
    }
}
