//
//  Edge.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/23.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation


public struct Edge<T>: Equatable where T: Hashable {
    public let from: Vertex<T>
    public let to: Vertex<T>
    public let weight: Double?
}

extension Edge: CustomStringConvertible {
    public var description: String {
        guard let weight = weight else {
            return "\(from.description) -> \(to.description)"
        }
        return "\(from.description) -(\(weight))-> \(to.description)"
    }
}

extension Edge: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(weight)
    }

}

public func ==<T>(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to && lhs.weight == rhs.weight
}
