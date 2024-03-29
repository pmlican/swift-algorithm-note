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
//        testBinarySearchTree1()
//        testMergeSort()
//        testMergeSort1()
//        testBoyerMoore()
//        testStride()
//        testHeap()
        
        
    }
    func testGraph() {
        let listGraph = AdjacencyListGraph<Int>()
        let matrixGraph = AdjacencyMatrixGraph<Int>()
        testGraph(graph: matrixGraph)

    }
    func testGraph(graph: AbstractGraph<Int>) {
        let v1 = graph.createVertex(1)
        let v2 = graph.createVertex(2)
        let v3 = graph.createVertex(3)
        let v4 = graph.createVertex(4)
        let v5 = graph.createVertex(5)
        
        graph.addDirectedEdge(v1, to: v2, withWeight: 1.0)
        graph.addDirectedEdge(v2, to: v3, withWeight: 1.0)
        graph.addDirectedEdge(v3, to: v4, withWeight: 4.5)
        graph.addDirectedEdge(v4, to: v1, withWeight: 2.8)
        graph.addDirectedEdge(v2, to: v5, withWeight: 3.2)
        
        print(graph)

    }
    
    func testHeap() {
        let arr = [1,2,10,7,5]
        var heap = Heap(array: arr, sort: >)
        print(heap.nodes)
        
        heap.insert(16)
        print(heap.nodes)
        
    
    }
    
    func testStride() {
        let arr = [1,3,5,6,2]
        for i in stride(from: (arr.count/2 - 1), through: 0, by: -1) {
            print("\(i)=====>\(arr[i])")
        }
    }
    
    func testBoyerMoore() {
        let s = "Hello, World"
        if let index = s.index(of: "World") {
            print(index)
            let i = s.distance(from: s.startIndex, to: index)
            print(i)
        }
    }
    
    func testMergeSort1() {
        let arr = [2,1,5,4,9]
        let sorted = MergeSort.bottomUp(arr, <)
        print(sorted)
    }
    
    func testMergeSort() {
        let arr = [2,1,5,4,9]
        let sorted = MergeSort.topDown(arr)
        print(sorted)
    }
    
    /*
        7
      /    \
      2     10
     /  \   /
    1   6  9
     */
    
    func testBinarySearchTree1() {
        var tree = BinarySearchTree1.Leaf(7)
        tree = tree.insert(newValue: 2)
        tree = tree.insert(newValue: 6)
        tree = tree.insert(newValue: 10)
        tree = tree.insert(newValue: 9)
        tree = tree.insert(newValue: 1)
        print(tree)
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
        
        //root count 6
        if let root = tree.search(7) {
            print("root count \(root.count)")
        }
        // height 2  depth 0  depth和height刚好相反，height是最低节点到根节点距离，depth是当前节点到根节点的距离
        print("height \(tree.height())  depth \(tree.depth()) ")
        
        print("*****************")
        //三种顺序不一样
        tree.traverseInOrder { value in print(value) }
        tree.traversePreOrder { value in print(value) }
        tree.traversePostOrder { value in print(value) }
        
        print("*****************")
        tree.traverseInOrderLoopWay()
        print("*****************")
        tree.traverseInOrderLoopWay1()
        print("*****************")


        print(tree.toArray())
        
        print(tree.height())
        
        if let node9 = tree.search(9) {
            print(node9.depth())
        }
        //((1) <-2 -> (5)) <-7 -> ((9) <-10)
        //((1 -> (100)) <-2 -> (5)) <-7 -> ((9) <-10)
        //So the new 100 node is in the wrong place in the tree!
        //As a result, doing tree.search(100) gives nil.
        
        if let node1 = tree.search(1) {
            //check valid
            print(tree.isBST(minValue: Int.min, maxValue: Int.max))
            node1.insert(value: 100)
            print(tree.search(100))
            print(tree)
            print(tree.isBST(minValue: Int.min, maxValue: Int.max))
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

