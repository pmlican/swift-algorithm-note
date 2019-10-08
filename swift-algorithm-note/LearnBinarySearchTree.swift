//
//  LearnBinarySearchTree.swift
//  learn_binary_search
//
//  Created by wanghaiwei on 2019/10/8.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

//Notice how each left child is smaller than its parent node, and each right child is greater than its parent node. This is the key feature of a binary search tree.
//二叉树性质：左子节点小于父节点，有子节点大于父节点
//插入和查找都是O(h)，h为树的高度，最低的叶子到根节点的距离
public class BinarySearchTree<T: Comparable> {
    private(set) public var value: T
    private(set) public var parent: BinarySearchTree?
    private(set) public var left: BinarySearchTree?
    private(set) public var right: BinarySearchTree?
    
    public init(value: T) {
        self.value = value
    }
    
    public var isRoot: Bool {
        return parent == nil
    }
    
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
    //对于原来 Objective-C 中使用 == 进行的对象指针的判定，在 Swift 中提供的是另一个操作符 ===
    //它用来判断两个 AnyObject 是否是同一个引用
    //https://swifter.tips/equal/ 判等
    public var isLeftChild: Bool {
        return parent?.left === self
    }

    public var isRightChild: Bool {
        return parent?.right === self
    }
    
    public var hasLeftChild: Bool {
        return left != nil
    }
    
    public var hasRightChild: Bool {
        return right != nil
    }
    
    public var hasAnyChild: Bool {
        return hasLeftChild || hasRightChild
    }
    
    public var hasBothChildren: Bool {
        return hasLeftChild && hasRightChild
    }
    
    public var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
    
    
}

//delete
extension BinarySearchTree {
    private func reconnectParentTo(node: BinarySearchTree?) {
        if let parent = parent {
            if isLeftChild {
                parent.left = node
            } else {
                parent.right = node
            }
        }
        node?.parent = parent
    }
    
    public func minium() -> BinarySearchTree {
        var node = self
        while let next = node.left {
            node = next
        }
        return node
    }
    
    public func maxium() -> BinarySearchTree {
        var node = self
        while let next = node.right {
            node = next
        }
        return node
    }
    
    @discardableResult
    public func remove() -> BinarySearchTree? {
        let replacement: BinarySearchTree?
        // Replacement for current node can be either biggest one on the left or
        // smallest one on the right, whichever is not nil
        //交换左节点最大值，交换右节点最小值，
        if let right = right {
            replacement = right.minium()
        } else if let left = left {
            replacement = left.maxium()
        } else {
            replacement = nil
        }
        //递归移除直到为nil，退出递归
        replacement?.remove()
        
        // Place the replacement on current node's position
        //替换位置,建立连接
        replacement?.right = right
        replacement?.left = left
        right?.parent = replacement
        left?.parent = replacement
        reconnectParentTo(node: replacement)
        
        // The current node is no longer part of the tree, so clean it up.
        //断开旧节点连接
        parent = nil
        left = nil
        right = nil
        
        return replacement
    }
    
    //The height of a node is the number of steps it takes to go from that node to its lowest leaf. The height of the entire tree is the distance from the root to the lowest leaf.
    public func height() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
        }
    }
    
    public func depth() -> Int {
        var node = self
        var edges = 0
        while let parent = node.parent {
            node = parent
            edges += 1
        }
        return edges
    }
}


extension BinarySearchTree {
    //现在插入节点需要随机数插入，如果插入的是排序的元素，则数组的形状不正确
    public func insert(value: T) {
        if value < self.value {
            if let left = left {
                left.insert(value: value)
            } else {
                left = BinarySearchTree(value: value)
                left?.parent = self
            }
        } else {
            if let right = right {
                right.insert(value: value)
            } else {
                right = BinarySearchTree(value: value)
                right?.parent = self
            }
        }
    }
    
    // first value is root node
    public convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value:array.first!)
        for v in array.dropFirst() {
            insert(value: v)
        }
    }
    //recursive way
    public func search(value: T) -> BinarySearchTree? {
        if value < self.value {
            return left?.search(value: value)
        } else if value > self.value {
            return right?.search(value: value)
        } else {
            return self
        }
    }
    //loop way
    public func search(_ value: T) -> BinarySearchTree? {
        var node: BinarySearchTree? = self
        while let n = node {
            if value < n.value {
                node = n.left
            } else if value > n.value {
                node = n.right
            } else {
                return node
            }
        }
        return nil
    }
    
    public func traverseInOrder(process: (T) -> ()) {
        left?.traverseInOrder(process: process)
        process(value)
        right?.traverseInOrder(process: process)
    }
    public func traversePreOrder(process: (T) -> ()) {
        process(value)
        left?.traversePreOrder(process: process)
        right?.traversePreOrder(process: process)
    }
    public func traversePostOrder(process: (T) -> ()) {
        left?.traversePostOrder(process: process)
        right?.traversePostOrder(process: process)
        process(value)
    }
    
    //map in order
    public func map(formula: (T) -> T) -> [T] {
        var a = [T]()
        if let left = left {
            a += left.map(formula: formula)
        }
        a.append(formula(value))
        if let right = right {
            a += right.map(formula: formula)
        }
        return a
    }
    
    public func toArray() -> [T] {
        return map { $0 }
    }
}

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "(\(left.description)) <-"
        }
        s += "\(value)"
        if let right = right {
            s += " -> (\(right.description))"
        }
        return s
    }
}
