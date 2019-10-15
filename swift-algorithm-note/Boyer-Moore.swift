//
//  Boyer-Moore.swift
//  swift-algorithm-note
//
//  Created by wanghaiwei on 2019/10/14.
//  Copyright © 2019 Shenzhen Hupzon Energy Technology Co., Ltd. All rights reserved.
//

import Foundation

extension String {
    
    //Hello, World
    //World
    
    func index(of pattern: String) -> Index? {
        // Cache the length of the search pattern because we're going to
        // use it a few times and it's expensive to calculate.
        let patternLength = pattern.count
        guard patternLength > 0, patternLength <= count else { return nil }
        
        // Make the skip table. This table determines how far we skip ahead
        // when a character from the pattern is found.
        var skipTable = [Character: Int]()
        for (i, c) in pattern.enumerated() {
            skipTable[c] = patternLength - i - 1
        }
        
        // This points at the last character in the pattern.
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]
        
        // The pattern is scanned right-to-left, so skip ahead in the string by
        // the length of the pattern. (Minus 1 because startIndex already points
        // at the first character in the source string.)
        var i = index(startIndex, offsetBy: patternLength - 1)
        
        // This is a helper function that steps backwards through both strings
        // until we find a character that doesn’t match, or until we’ve reached
        // the beginning of the pattern.
        func backwards() -> Index? {
            var q = p
            var j = i
            while q > pattern.startIndex {
                j = index(before: j)
                q = index(before: q)
                if self[j] != pattern[q] { return nil }
            }
            return j
        }
        
        // The main loop. Keep going until the end of the string is reached.
        while i < endIndex {
            let c = self[i]
            
            // Does the current character match the last character from the pattern?
            if c == lastChar {
                
                // There is a possible match. Do a brute-force search backwards.
                if let k = backwards() { return k }
                
                // If no match, we can only safely skip one character ahead.
                i = index(after: i)
            } else {
                // The characters are not equal, so skip ahead. The amount to skip is
                // determined by the skip table. If the character is not present in the
                // pattern, we can skip ahead by the full pattern length. However, if
                // the character *is* present in the pattern, there may be a match up
                // ahead and we can't skip as far.
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
    
}


//A variation on the above algorithm is the Boyer-Moore-Horspool algorithm.

extension String {
    func index1(of pattern: String) -> Index? {
        let patternLength = pattern.count
        guard patternLength > 0, patternLength <= count else {return nil}
        
        
        var skipTable = [Character: Int]()
        for (i, c) in pattern.enumerated() {
            skipTable[c] = patternLength - i - 1
        }
        
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]
        
        var i = index(startIndex, offsetBy: patternLength - 1)
        
        func backwards() -> Index? {
            var q = p
            var j = i
            while q > pattern.startIndex {
                j = index(before: j)
                q = index(before: q)
                if self[j] != pattern[q] {return nil}
            }
            return j
        }
        
        while i < endIndex {
            let c = self[i]
            if c == lastChar {
                if let k = backwards() {return k}
                //区别在于这里
                //Like the regular Boyer-Moore algorithm, it uses the skipTable to skip ahead a number of characters. The difference is in how we check partial matches. In the above version, if a partial match is found but it's not a complete match, we skip ahead by just one character. In this revised version, we also use the skip table in that situation.
                let jumpOffset = max(skipTable[c] ?? patternLength, 1)
                i = index(i, offsetBy: jumpOffset, limitedBy: endIndex) ?? endIndex
            } else {
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
}