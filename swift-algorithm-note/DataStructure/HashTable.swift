//
//  HashTable.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/16.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation


//哈希表只过是一个数组，利用key,计算数组的索引
//处理碰撞问题，一种方法是数组每个元素是一个桶，这个桶可以是链表或者是另一数组，
//一种办法是，将这个值，放到下一个为空的位置

// 可以用factor判断容量是否不足了，因为理想状态下容量越大，碰撞几率越低，factor = count / capacity 如果是大于75,就可以重新扩大hashtable,如果不扩大就会使操作有O(1)降低为O(n)
//This version of HashTable always uses an array of a fixed size or capacity. If you have many items to store in the hash table, for the capacity, choose a prime number greater than the maximum number of items.
//因为质数只能被1和本身整除，所以取模时避免频繁等于0，就是被整除

public struct HashTable<Key: Hashable, Value> {
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    private var buckets: [Bucket]
    //是指所有bucket存储的元素
    private(set) public var count = 0
    
    public var isEmpty: Bool { return count == 0}
    
    public init(capacity: Int) {
        assert(capacity > 0)
        buckets = Array<Bucket>(repeatElement([], count: capacity))
    }
    
    //计算索引的公式
    private func index(forKey key: Key) -> Int {
        return abs(key.hashValue % buckets.count)
    }
    
    //一共有四种常用操作： 增删改查
    //查
    public func value(forKey key:Key) -> Value? {
        let index = self.index(forKey: key)
        for element in buckets[index] {
            if element.key == key {
                return element.value
            }
        }
        return nil
    }
    //增改
    @discardableResult
    public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        //如果存在就替换
        for (i, element) in buckets[index].enumerated() {
            if element.key == key {
                let oldValue = element.value
                buckets[index][i].value = value
                return oldValue
            }
        }
        //如果不存在
        buckets[index].append((key: key, value: value))
        count += 1
        return nil
    }
    //删
    @discardableResult
    public mutating func removeValue(forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        for (i, element) in buckets[index].enumerated() {
            if element.key == key {
                buckets[index].remove(at: i)
                count -= 1
                return element.value
            }
        }
        return nil
    }
    
    //增加角标方法，可以像字典那样使用
    public subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        set {
            if let value = newValue {
                updateValue(value, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }
    
}
