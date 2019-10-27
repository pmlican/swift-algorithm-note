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
/*
 A binary search tree is balanced when its left and right subtrees contain the same number of nodes. In that case, the height of the tree is log(n), where n is the number of nodes. That is the ideal situation.
 
 If one branch is significantly longer than the other, searching becomes very slow. We end up checking more values than we need. In the worst case, the height of the tree can become n. Such a tree acts like a linked list than a binary search tree, with performance degrading to O(n). Not good!
 
 One way to make the binary search tree balanced is to insert the nodes in a totally random order. On average that should balance out the tree well, but it not guaranteed, nor is it always practical.
 
 The other solution is to use a self-balancing binary tree. This type of data structure adjusts the tree to keep it balanced after you insert or delete nodes. To see examples, check AVL tree and red-black tree.

当树不平衡时，会导致搜索变成O(n)
 */

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
    //当前节点下面所有子树的节点
    public var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
    
    
}

//MARK: Valid
extension BinarySearchTree {
    //检查左节点是否小于当前节点，右节点是否大于当前节点
    public func isBST(minValue: T, maxValue: T) -> Bool {
        if value < minValue || value > maxValue {
            return false
        }
        let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
        let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
        return leftBST && rightBST
    }
}

//MARK: predecessor successor
//前任和继任者  O(h)
extension BinarySearchTree {
    //如果有左树，直接找左树最大值,如果没有左树，回溯父节点找父节点更小的值
    public func predecessor() -> BinarySearchTree<T>? {
        if let left = left {
            return left.maxium()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value < value {
                    return parent
                }
                node = parent
            }
            return nil
        }
    }
    //找继任者，操作和上面是镜像操作
    public func successor() -> BinarySearchTree<T>? {
        if let right = right {
            return right.minium()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value > value {
                    return parent
                }
                node = parent
            }
            return nil
        }
    }
}

//MARK: delete
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
    //You can also calculate the depth of a node, which is the distance to the root
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

//MARK: Search traverse
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
    //中序遍历
    public func traverseInOrder(process: (T) -> ()) {
        left?.traverseInOrder(process: process)
        process(value)
        right?.traverseInOrder(process: process)
    }
    //前序遍历
    public func traversePreOrder(process: (T) -> ()) {
        process(value)
        left?.traversePreOrder(process: process)
        right?.traversePreOrder(process: process)
    }
    //后序遍历
    public func traversePostOrder(process: (T) -> ()) {
        left?.traversePostOrder(process: process)
        right?.traversePostOrder(process: process)
        process(value)
    }
    
    //中序遍历 非递归方法
    public func traverseInOrderLoopWay() {
        var stack = [BinarySearchTree<T>]()
        var node: BinarySearchTree? = self
        while (node != nil) || (!stack.isEmpty) {
            while let n = node {
                stack.append(n)
                node = node?.left
            }
            node = stack.removeLast()
            print(node!.value)
            node = node?.right
        }
        
    }
    
    public func traverseInOrderLoopWay1() {
        var stack = [BinarySearchTree<T>]()
        var node: BinarySearchTree? = self
        while (node != nil) || (!stack.isEmpty) {
            if let n = node {
                stack.append(n)
                node = n.left
            } else {
                node = stack.removeLast()
                print(node!.value)
                node = node?.right
            }
        }
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


// Enum 版本
/*
 The difference is reference semantics versus value semantics. Making a change to the class-based tree will update that same instance in memory, but the enum-based tree is immutable -- any insertions or deletions will give you an entirely new copy of the tree
 区别在于，插入和删除会返回一个拷贝，要用变量重新赋值,取决于你怎么使用
 */

public enum BinarySearchTree1<T: Comparable> {
    case Empty
    case Leaf(T)
    //This is marked indirect so that it can hold BinarySearchTree values. Without indirect you can't make recursive enums
    // parent node 可以不需要，但某些操作实现会比较麻烦
    indirect case Node(left:BinarySearchTree1,value:T,right:BinarySearchTree1)
}
extension BinarySearchTree1 {
    public var count: Int {
        switch self {
        case .Empty: return 0
        case .Leaf: return 1
        case let .Node(left, _, right): return left.count + 1 + right.count
        }
    }
    public var height: Int {
        switch self {
        case .Empty: return -1
        case .Leaf: return 0
        case let .Node(left, _, right): return 1 + max(left.height, right.height)
        }
    }
    public func insert(newValue: T) -> BinarySearchTree1 {
        switch self {
        //其余两个都没调用insert 是出口
        case .Empty:
            return .Leaf(newValue)
        case .Leaf(let value):
            if newValue < value {
                return .Node(left: .Leaf(newValue), value: value, right: .Empty)
            } else {
                return .Node(left: .Empty, value: value, right: .Leaf(newValue))
            }
        //insert 是递归入口
        case let .Node(left, value, right):
            if newValue < value {
                return .Node(left: left.insert(newValue: newValue), value: value, right: right)
            } else {
                return .Node(left: left, value: value, right: right.insert(newValue: newValue))
            }
        }
    }
    public func search(x: T) -> BinarySearchTree1? {
        switch self {
        case .Empty:
            return nil
        case .Leaf(let y):
            return (x == y) ? self : nil
        case let .Node(left, y, right):
            if x < y {
                return left.search(x: x)
            } else if y < x {
                return right.search(x: x)
            } else {
                return self
            }
        }
    }
}
extension BinarySearchTree1: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .Empty: return "."
        case .Leaf(let value): return "\(value)"
        case let .Node(left, value, right):
            return "(\(left.debugDescription) <- \(value) -> \(right.debugDescription))"
        }
    }
}
