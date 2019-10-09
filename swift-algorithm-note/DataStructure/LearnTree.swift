//
//  LearnTree.swift
//  learn_binary_search
//
//  Created by wanghaiwei on 2019/10/8.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

struct LearnTree {
    
    
}

public class TreeNode<T> {
    public var value: T
    public weak var parent: TreeNode?
    public var children = [TreeNode<T>]()
    public init(value:T) {
        self.value = value
    }
    public func addChild(_ node: TreeNode<T>) {
        children.append(node)
        node.parent = self
    }
}

// custom print tree
//tree root node leaf
//树包含根，节点，叶子
extension TreeNode: CustomStringConvertible {
    public var description: String {
        var s = "\(value)"
        if !children.isEmpty {
            s += " {" + children.map {$0.description}.joined(separator: ",") + "}"
        }
        return s
    }
}

extension TreeNode where T: Equatable {
    
    func search(_ value: T) -> TreeNode? {
        if value == self.value {
            return self
        }
        for child in children {
            if let found = child.search(value) {
                return found
            }
        }
        return nil
    }
}
