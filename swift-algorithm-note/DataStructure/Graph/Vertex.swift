//
//  Vertex.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/23.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

//描述图的顶点
public struct Vertex<T>: Equatable where T: Hashable {
    public var data: T
    public let index: Int
}

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(index):\(data)"
    }
}

// where语句限制了关联属性T遵循Hashable协议，默认编译器会自动生成
extension Vertex: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
        hasher.combine(index)
    }
}

public func ==<T>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
    return lhs.index == rhs.index && lhs.data == rhs.data
}
