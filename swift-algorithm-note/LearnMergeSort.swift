//
//  LearnMergeSort.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/9.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation


// merge sort 归并排序
//时间复杂度为 O(nlogn)，优点是稳定排序，即是排序后不改变原来的元素的位置，缺点是需要一个和需要排序数组长度一致的临时数组


struct MergeSort {
    //[2,1,5,4,9]
    //http://www.algomation.com/player?algorithm=58bb32885b2b830400b05123
    //动图展示， 自上而下的实施(递归法)
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

//Bottom-up implementation
//http://www.mathcs.emory.edu/~cheung/Courses/171/Syllabus/7-Sort/merge-sort5.html
//参考链接，图文讲解，自下而上的实施(迭代)
//[2,1,5,4,9]
extension MergeSort {
    static func bottomUp<T>(_ a: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
        let n = a.count
        
        var z = [a, a]
        var d = 0
        
        var width = 1
        while width < n {
            var i = 0
            while i < n {
                var j = i
                var l = i
                var r = i + width
                
                let lmax = min(l + width, n)
                let rmax = min(r + width, n)
                //[1-d]写入 [d]读取
                while l < lmax && r < rmax {
                    if isOrderedBefore(z[d][l],z[d][r]) {
                        z[1-d][j] = z[d][l]
                        l += 1
                    } else {
                        z[1-d][j] = z[d][r]
                        r += 1
                    }
                    j += 1
                }
                while l < lmax {
                    z[1-d][j] = z[d][l]
                    j += 1
                    l += 1
                }
                while r < rmax {
                    z[1-d][j] = z[d][r]
                    j += 1
                    r += 1
                }
                i += width*2
            }
            
            width *= 2
            d = 1 - d
        }
        return z[d]
    }

}
