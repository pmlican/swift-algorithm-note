//
//  LearnBinarySearch.swift
//  learn_binary_search
//
//  Created by wanghaiwei on 2019/10/8.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

struct LearnBinarySearch {
    //递归实现,时间复杂度是 O(log n),因为一直在折半缩小数组的范围，所以复杂度为log2N
    //note1: 这个方法只有在数组已经排好序的情况才有效
    //note2: 有个细节要注意 midIndex = (lowerBound + upperBound) / 2 计算中间index如果用这种方式的话
    //当数组count很大时，会导致int溢出,在64位的系统可能不会出现，但在32位系统肯定会出现这个问题
    static func binarySearch<T:Comparable>(_ a: [T], key: T, range:Range<Int>) -> Int? {
        if range.lowerBound >= range.upperBound {
            // If we get here, then the search key is not present in the array.
            return nil
        } else {
            // Calculate where to split the array.
            let midIndex = range.lowerBound + (range.upperBound - range.lowerBound)/2
            // Is the search key in the left half?
            if a[midIndex] > key {
                return binarySearch(a, key: key, range: range.lowerBound..<midIndex)
                // Is the search key in the right half?
            } else if a[midIndex] < key {
                return binarySearch(a, key: key, range: midIndex+1..<range.upperBound)
                // If we get here, then we've found the search key!
            } else {
                return midIndex
            }
        }
    }
    
    //迭代实现
    static func binarySearch<T: Comparable>(_ a: [T], key: T) -> Int? {
        var lowerBound = 0
        var upperBound = a.count
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            if a[midIndex] == key {
                return midIndex
            } else if a[midIndex] < key {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return nil
    }
    //结论：
    //Is it a problem that the array must be sorted first? It depends. Keep in mind that sorting takes time -- the combination of binary search plus sorting may be slower than doing a simple linear search. Binary search shines in situations where you sort just once and then do many searches.

}
