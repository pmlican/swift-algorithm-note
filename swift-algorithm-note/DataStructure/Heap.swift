//
//  Heap.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/15.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

public struct Heap<T> {
    
    var nodes = [T]()
    
    //顺序准则
    private var orderCriteria: (T, T) -> Bool
    
    
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
    }
    
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
        configureHeap(from: array)
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
}
