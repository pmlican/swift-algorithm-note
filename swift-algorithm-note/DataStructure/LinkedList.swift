//
//  LinkedList.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/17.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

public class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode?
    //防止循环引用
    weak var previous: LinkedListNode?
    
    public init(value:T) {
        self.value = value
    }
}

public class LinkedList<T> {
    public typealias Node = LinkedListNode<T>
    
    private var head: Node?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node? {
        return head
    }
    
    public var last: Node? {
        guard var node = head else {return nil}
        
        while let next = node.next {
            node = next
        }
        return node
    }
    
    public func append(value: T) {
        let newNode = Node(value: value)
        if let lastNode = last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }
    //还有另外一种方法提速到O(1)操作，就是定义个属性，在增加和删除的时候更新这个变量
    //这个循环操作是O(n)
    public var count: Int {
        guard var node = head else {
            return 0
        }
        var count = 1
        while let next = node.next {
            node = next
            count += 1
        }
        return count
    }
    
    //index是不安全操作，像数组也是一样
    public func node(atIndex index: Int) -> Node {
        if index == 0 {
            return head!
        } else {
            var node = head!.next
            for _ in 1..<index {
                node = node?.next
                //This means that the given index is out of bounds and it causes a crash
                if node == nil {
                    break
                }
            }
            return node!
        }
    }
    
    public subscript(index: Int) -> T {
        let node = self.node(atIndex: index)
        return node.value
    }
    
    //如果对链表顺序不重要的话，尽量在头部插入节点，因为这个O(1)操作，如果再尾部插入数据是O(n)
    public func insert(_ node: Node, atIndex index: Int) {
        let newNode = node
        if index == 0 {
            newNode.next = head
            head?.previous = newNode
            head = newNode
        } else {
            let prev = self.node(atIndex: index - 1)
            let next = prev.next
            //连接节点
            newNode.previous = prev
            newNode.next = prev.next
            prev.next = newNode
            next?.previous = newNode
        }
    }
    
    public func removeAll() {
        head = nil
    }
    
    public func remove(node: Node) -> T {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            //要考虑头指针问题，如果有尾部指针，也要考虑
            head = next
        }
        next?.previous = prev
        
        node.next = nil
        node.previous = nil
        return node.value
    }
    
    public func removeLast() -> T {
        assert(!isEmpty)
        return remove(node: last!)
    }
    
    public func removeAt(_ index: Int) -> T {
        let node = self.node(atIndex: index)
        return remove(node: node)
    }
    
    /*
    public func reverse() {
        var node = head
        tail = node
        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            head = currentNode
        }
    }
     */
    
    //map方法
    public func map<U>(transform: (T) -> U) -> LinkedList<U> {
        let result = LinkedList<U>()
        var node = head
        while node != nil {
            result.append(value: transform(node!.value))
            node = node!.next
        }
        return result
    }
    
    //filter
    public func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while node != nil {
            if predicate(node!.value) {
                result.append(value: node!.value)
            }
            node = node!.next
        }
        return result
    }
    
}

extension LinkedList:CustomStringConvertible {
    //[Hello, Swift, World] 方便调试输出信息
    //t's handy to have some sort of readable debug output:
    public var description: String {
        var s = "["
        var node = head
        while node != nil {
            s += "\(node!.value)"
            node = node!.next
            if node != nil {
                s += ", "
            }
        }
        return s + "]"
    }
}

//MARK: collection协议
extension LinkedList: Collection {
    
    public typealias Index = LinkedListIndex<T>
    
    public func index(after i: Index) -> Index {
        return LinkedListIndex<T>(node: i.node?.next, tag: i.tag + 1)
    }
    
    public var startIndex: Index {
        get {
            return LinkedListIndex<T>(node: head, tag: 0)
        }
    }
    
    public var endIndex: Index {
        get {
            if let h = self.head {
                return LinkedListIndex<T>(node: h, tag: count)
            } else {
                return LinkedListIndex<T>(node: nil, tag: startIndex.tag)
            }
        }
    }
    
    public subscript(postion: Index) -> T {
        get {
            return postion.node!.value
        }
    }

    
}

public struct LinkedListIndex<T>: Comparable {
 
    fileprivate let node: LinkedList<T>.Node?
    fileprivate let tag: Int
    
    public static func < (lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return lhs.tag < rhs.tag
    }
    
    public static func == (lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
}
