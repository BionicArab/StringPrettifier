//
//  StringPrettifier.swift
//  StringPrettifier
//
//  Created by BionicArab G on 07.06.20.
//  Copyright © 2020 BionicArab G. All rights reserved.
//

import Foundation
import UIKit

public class StringPrettifier {
    
    public static func prettify(_ text: String) -> NSMutableAttributedString {
        return boldifyAllCapsWords(formatBreaklines(text))
    }
    
    private static func formatBreaklines(_ text: String) -> String {
        var txtWithBreaklines = ""
        
        let linkRanges = getLinkRangesIfExists(text)
        
        for (index, char) in text.enumerated() {
            txtWithBreaklines.append(char)
            if char.asciiValue == 46 {
                let isALink = linkRanges.contains(where: {index >= $0.0 || index <= $0.1})
                if index+1 < text.count {
                    if text[index+1] == " " || text[index+1].isLetter && !isALink {
                        txtWithBreaklines.append("\n\n")
                    }
                }
            }
        }
        return txtWithBreaklines.replacingOccurrences(of: "\n\n ", with: "\n\n")
    }
    
    private static func boldifyAllCapsWords(_ text: String) -> NSMutableAttributedString {
        let nsText = text as NSString
        let range = NSMakeRange(0, nsText.length)
        let attributedString = NSMutableAttributedString(string: text)
        
        nsText.enumerateSubstrings(in: range, options: .byWords) { (subString, range0, _, _) in
            guard let subString = subString else {
                return
            }
            var isALLCaps = true
            if subString.count > 4 {
                for (_, char) in subString.enumerated() {
                    if !char.isUppercase {
                        isALLCaps = false
                    }
                }
            } else {
                isALLCaps = false
            }
            
            if isALLCaps {
                attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 16)], range: range0)
            }
            
        }
        return attributedString
        
    }
    
    private static func getLinkRangesIfExists(_ text: String) -> [(Int,Int)] {
        var linkRanges = [(Int,Int)]()
              
              /// not to effect links with breaklines
              let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
              if let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count)) {
                  for match in matches {
                      linkRanges.append((match.range.lowerBound, match.range.upperBound))
                  }
              }
                  
        return linkRanges
    }
}

private extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}
