//
//  Queue.swift
//  learn_swift_algorithm
//
//  Created by Can Lee on 2019/9/27.
//  Copyright © 2019 Can Lee. All rights reserved.
//

import Foundation

/*queue优化
 enqueue操作通常为O(1)操作，因为swift数组，通常在末尾预留一些空间来插入数组，当数组满了，才会去调整开辟更多空间，把所有元素复制过去，虽然是O(n),但这个偶尔发生，所以平均下来还是O(1)操作
 dequeue操作，因为移除第一个元素，会挪动剩余所有元素的位置，复杂度为O(n),因为内置的array并没有帮我们优化这个操作
 */
//stack 更加轻量
//更高效的方法，思路:移除前面的元素时，不调整数组元素位置，标记为空，而是设定一个阈值周期去调整元素位置


public struct Queue<T> {
    fileprivate var array = [T?]()
    //记录前面移除的元素个数
    fileprivate var head = 0
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
        guard head < array.count, let element = array[head] else {return nil}
        array[head] = nil
        head += 1
        let percentage = Double(head)/Double(array.count)
        //判断是否满足条件
        if array.count > 50 && percentage > 0.25 {
            //移除前面从head才开始的元素
            array.removeFirst(head)
            //重置标记
            head = 0
        }
        return element
    }
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}
