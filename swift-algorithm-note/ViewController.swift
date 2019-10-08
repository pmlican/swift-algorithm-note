//
//  ViewController.swift
//  learn_binary_search
//
//  Created by wanghaiwei on 2019/10/8.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        testBinarySearch()
//        testTree()
        testBinarySearchTree()
    }
    
    /*
         7
       /    \
      2      10
     /  \    /
    1    5   9
     */
    
    func testBinarySearchTree() {
        let tree = BinarySearchTree(array: [7, 2, 5, 10, 9, 1])
        print(tree)
        print(tree.search(value: 5))
        print(tree.search(value: 7))
        print(tree.search(value: 2))
        print(tree.search(value: 6))
        
        //三种顺序不一样
        tree.traverseInOrder { value in print(value) }
        tree.traversePreOrder { value in print(value) }
        tree.traversePostOrder { value in print(value) }
        
        print(tree.toArray())
        
        print(tree.height())
        
        if let node9 = tree.search(9) {
            print(node9.depth())
        }

    }

    func testBinarySearch() {
        let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
        let index = LearnBinarySearch.binarySearch(numbers, key: 43, range: 0..<numbers.count)
        print(index ?? " not found")
    }
    
    func testTree() {
        //beverages饮料分类
        let tree = TreeNode(value: "beverages")
        let hotNode = TreeNode(value: "hot")
        let coldNode = TreeNode(value: "cold")
        let teaNode = TreeNode(value: "tea")
        let coffeeNode = TreeNode(value: "coffeeNode")
        let chocolateNode = TreeNode(value: "chocalateNode")
        
        let blackTeaNode = TreeNode(value: "blackTeaNode")
        let greenTeaNode = TreeNode(value: "greenTeaNode")
        let chaiTeaNode = TreeNode(value: "chai")
        
        let sodaNode = TreeNode(value: "soda")
        let milkNode = TreeNode(value: "milk")
        
        let gingerAleNode = TreeNode(value: "ginger ale")
        let bitterLemonNode = TreeNode(value: "bitter lemon")
        
        tree.addChild(hotNode)
        tree.addChild(coldNode)
        //热饮
        hotNode.addChild(teaNode)
        hotNode.addChild(coffeeNode)
        hotNode.addChild(chocolateNode)
        //冷饮
        coldNode.addChild(sodaNode)
        coldNode.addChild(milkNode)
        //茶饮
        teaNode.addChild(blackTeaNode)
        teaNode.addChild(greenTeaNode)
        teaNode.addChild(chaiTeaNode)
        //苏打
        sodaNode.addChild(gingerAleNode)
        sodaNode.addChild(bitterLemonNode)
        
        print(tree)
        //beverages {hot {tea {blackTeaNode,greenTeaNode,chai},coffeeNode,chocalateNode},cold {soda {ginger ale,bitter lemon},milk}}
        
        print(tree.search("cocoa") ?? "nil")
        print(tree.search("chai") ?? "nil")
        print(tree.search("bubbly") ?? "nil")

    }


}
