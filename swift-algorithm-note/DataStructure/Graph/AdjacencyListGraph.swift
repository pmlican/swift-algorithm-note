//
//  AdjacencyListGraph.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/23.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

/*
 v1 -> [(v2: 1.0)]
 v2 -> [(v3: 1.0), (v5: 3.2)]
 v3 -> [(v4: 4.5)]
 v4 -> [(v1: 2.8)]
 
  Set up a cycle like so:
                v5
                 ^
                 | (3.2)
                 |
  v1 ---(1)---> v2 ---(1)---> v3 ---(4.5)---> v4
  ^                                            |
  |                                            V
  ---------<-----------<---------(2.8)----<----|
 有向环结构，用邻近列表图表示
 */

//维持一个顶点对应的一组边的关系
private class EdgeList<T> where T: Hashable {
    var vertex: Vertex<T>
    var edges: [Edge<T>]?
    
    init(vertex: Vertex<T>) {
        self.vertex = vertex
    }
    func addEdge(_ edge: Edge<T>) {
        edges?.append(edge)
    }
}

//邻接表图
open class AdjacencyListGraph<T>: AbstractGraph<T> where T: Hashable {
    fileprivate var adjacencyList: [EdgeList<T>] = []
    
    public required init() {
        super.init()
    }
    
    public required init(fromGraph graph: AbstractGraph<T>) {
        super.init(fromGraph: graph)
    }
    
    open override var vetices: [Vertex<T>] {
        var vertices = [Vertex<T>]()
        for edgeList in adjacencyList {
            vertices.append(edgeList.vertex)
        }
        return vertices
    }
    
    open override var edges: [Edge<T>] {
        var allEdges = Set<Edge<T>>()
        for edgeList in adjacencyList {
            guard let edges = edgeList.edges else {
                continue
            }
            for edge in edges {
                allEdges.insert(edge)
            }
        }
        return Array(allEdges)
    }
    
    open override func createVertex(_ data: T) -> Vertex<T> {
        let matchingVertices = vetices.filter { (vertex) -> Bool in
            return vertex.data == data
        }
        if matchingVertices.count > 0 {
            return matchingVertices.last!
        }
        
        let vertex = Vertex(data: data, index: adjacencyList.count)
        adjacencyList.append(EdgeList(vertex: vertex))
        return vertex
    }
    
    open override func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        let edge = Edge(from: from, to: to, weight: weight)
        let edgeList = adjacencyList[from.index]
        if edgeList.edges != nil {
            edgeList.addEdge(edge)
        } else {
            edgeList.edges = [edge]
        }
    }
    
    open override func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
    }
    
    open override var description: String {
        var rows = [String]()
        for edgeList in adjacencyList {
            guard let edges = edgeList.edges else {
                continue
            }
            var row = [String]()
            for edge in edges {
                var value = "\(edge.to.data)"
                if edge.weight != nil {
                    value = "\(value): \(edge.weight!)"
                }
                row.append(value)
            }
            rows.append("\(edgeList.vertex.data) -> [\(row.joined(separator: ", "))]")
        }
        return rows.joined(separator: "\n")
    }
    
    open override func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        guard let edges = adjacencyList[sourceVertex.index].edges else {
            return nil
        }
        for edge in edges {
            if edge.to == destinationVertex {
                return edge.weight
            }
        }
        return nil
     }
    open override func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        return adjacencyList[sourceVertex.index].edges ?? []
    }


}
