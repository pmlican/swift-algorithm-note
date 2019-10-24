//
//  Graph.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/23.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

//In the case of a sparse graph, where each vertex is connected to only a handful of other vertices, an adjacency list is the best way to store the edges. If the graph is dense, where each vertex is connected to most of the other vertices, then a matrix is preferred.

//抽象基类
open class AbstractGraph<T>: CustomStringConvertible where T: Hashable {
    public required init() {}
    
    public required init(fromGraph graph: AbstractGraph<T>) {
        for edge in graph.edges {
            let from = createVertex(edge.from.data)
            let to = createVertex(edge.to.data)
            addDirectedEdge(from, to: to, withWeight: edge.weight)
        }
    }
    
    open var description: String {
        fatalError("abstract property accessed")
    }
    
    open var vetices: [Vertex<T>] {
        fatalError("abstract property accessed")
    }
    
    open var edges: [Edge<T>] {
        fatalError("abstract property accessed")
    }
    
    open func createVertex(_ data: T) -> Vertex<T> {
        fatalError("abstract function called")
    }
    
    open func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        fatalError("abstract function called")
    }
    
    open func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        fatalError("adbstract function called")
    }
    
    open func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        fatalError("abstract function called")
    }
    open func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        fatalError("abstract function called")
    }
}
