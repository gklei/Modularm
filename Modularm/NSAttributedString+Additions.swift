//
//  NSAttributedString+Additions.swift
//  Modularm
//
//  Created by Klein, Greg on 4/28/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

extension NSAttributedString
{
   convenience init(text: String)
   {
      let titleAttrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 19)!]
      self.init(string: text, attributes: titleAttrs)
   }
   
   convenience init(text: String, color: UIColor)
   {
      let titleAttrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 19)!, NSForegroundColorAttributeName : color]
      self.init(string: text, attributes: titleAttrs)
   }

   convenience init(text: String, boldText: String)
   {
      let titleAttrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 19)!]
      let boldTitleAttrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 19)!]

      let mutableAttributedString = NSMutableAttributedString(string: text, attributes: titleAttrs)
      let boldAttributedString = NSAttributedString(string: " \(boldText)", attributes: boldTitleAttrs)

      mutableAttributedString.appendAttributedString(boldAttributedString)
      self.init(attributedString: mutableAttributedString)
   }
}
