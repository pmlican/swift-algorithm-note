//
//  LearnMergeSort.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/9.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation


// merge sort 归并排序
//时间复杂度为 O(nlogn)


struct MergeSort {
    //[2,1,5,4,9]
    static func topDown(_ array:[Int]) -> [Int] {
        guard array.count > 1 else {return array}
        
        let middleIndex = array.count / 2
        
        let leftArray = topDown(Array(array[0..<middleIndex]))
        
        let rightArray = topDown(Array(array[middleIndex..<array.count]))
        
        return merge(leftPile: leftArray, rightPile: rightArray)
    }
    static func merge(leftPile: [Int], rightPile: [Int]) -> [Int] {
        var leftIndex = 0
        var rightIndex = 0
        
        var orderedPile = [Int]()
        //因为知道数组长度，用reserveCapacity预留容量，以避免以后重新分配开销
        //Since you already know number of elements that will end up in this array, you reserve capacity to avoid reallocation overhead later.
        orderedPile.reserveCapacity(leftPile.count + rightPile.count)
        
        //移动左右标记，放到已排序的数组中
        while leftIndex < leftPile.count && rightIndex < rightPile.count {
            if leftPile[leftIndex] < rightPile[rightIndex] {
                orderedPile.append(leftPile[leftIndex])
                leftIndex += 1
            } else if leftPile[leftIndex] > rightPile[rightIndex] {
                orderedPile.append(rightPile[rightIndex])
                rightIndex += 1
            } else {
                //如果两个元素相等，同时加入
                orderedPile.append(leftPile[leftIndex])
                leftIndex += 1
                orderedPile.append(rightPile[rightIndex])
                rightIndex += 1
            }
        }
        //左右堆合并后，还剩未能合并的，统统添加到数组，因为每个堆都是已经排好序
        while leftIndex < leftPile.count {
            orderedPile.append(leftPile[leftIndex])
            leftIndex += 1
        }
        while rightIndex < rightPile.count {
            orderedPile.append(rightPile[rightIndex])
            rightIndex += 1
        }
        return orderedPile
    }
}
