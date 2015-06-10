//
//  String+Additions.swift
//  Modularm
//
//  Created by Klein, Greg on 6/9/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

extension String
{
   var trimmedString: String {
      get {
         let whitespaceCharacters = NSCharacterSet.whitespaceCharacterSet()
         return self.stringByTrimmingCharactersInSet(whitespaceCharacters)
      }
   }
   
   subscript (r: Range<Int>) -> String {
      get {
         let subStart = advance(self.startIndex, r.startIndex, self.endIndex)
         let subEnd = advance(subStart, r.endIndex - r.startIndex, self.endIndex)
         return self.substringWithRange(Range(start: subStart, end: subEnd))
      }
   }
   
   func substring(from: Int) -> String {
      let end = count(self)
      return self[from..<end]
   }
   
   func substring(from: Int, length: Int) -> String {
      let end = from + length
      return self[from..<end]
   }
}
