//
//  AdjacencyMatrixGraph.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/23.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

/*
 
[[nil, 1.0, nil, nil, nil]    v1
[nil, nil, 1.0, nil, 3.2]    v2
[nil, nil, nil, 4.5, nil]    v3
[2.8, nil, nil, nil, nil]    v4
[nil, nil, nil, nil, nil]]   v5

 v1   v2   v3   v4   v5
 
 Set up a cycle like so:
               v5
                ^
                | (3.2)
                |
 v1 ---(1)---> v2 ---(1)---> v3 ---(4.5)---> v4
 ^                                            |
 |                                            V
 ---------<-----------<---------(2.8)----<----|
有向环结构，用邻近矩阵图表示
*/

open class AdjacencyMatrixGraph<T>: AbstractGraph<T> where T: Hashable {
    fileprivate var adjacencyMatrix: [[Double?]] = []
    fileprivate var _vertices: [Vertex<T>] = []
    
    public required init() {
        super.init()
    }
    
    public required init(fromGraph graph: AbstractGraph<T>) {
        super.init(fromGraph: graph)
    }
    
    open override var vetices: [Vertex<T>] {
        return _vertices
    }
    
    open override var edges: [Edge<T>] {
        var edges = [Edge<T>]()
        for row in 0..<adjacencyMatrix.count {
            for column in 0..<adjacencyMatrix.count {
                if let weight = adjacencyMatrix[row][column] {
                    edges.append(Edge(from: vetices[row], to: vetices[column], weight: weight))
                }
            }
        }
        return edges
    }
    
    open override func createVertex(_ data: T) -> Vertex<T> {
        let matchingVertices = vetices.filter { (vertex) -> Bool in
            return vertex.data == data
        }
        if matchingVertices.count > 0 {
            return matchingVertices.last!
        }
        
        let vertex = Vertex(data: data, index: adjacencyMatrix.count)
        
        for i in 0..<adjacencyMatrix.count {
            adjacencyMatrix[i].append(nil)
        }
        //添加新的一行到底部
        let newRow = [Double?](repeating: nil, count: adjacencyMatrix.count + 1)
        adjacencyMatrix.append(newRow)
        
        _vertices.append(vertex)
        
        return vertex
    }
    
    open override func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        adjacencyMatrix[from.index][to.index] = weight
    }

    open override var description: String {
        var gird = [String]()
        let n = self.adjacencyMatrix.count
        for i in 0..<n {
            var row = ""
            for j in 0..<n {
                if let value = self.adjacencyMatrix[i][j] {
                    let number = String(format: "%.1f", value)
                    j == 0 ? (row += "\(number)") : (row += "\t\t\(number)")
                } else {
                    j == 0 ? (row += "ø") : (row += "\t\tø")
                }
            }
            gird.append(row)
        }
        return gird.joined(separator: "\n")
    }

    
}
