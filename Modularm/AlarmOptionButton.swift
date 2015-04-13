//
//  AlarmOptionButton.swift
//  Modularm
//
//  Created by Gregory Klein on 4/13/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmOptionButton: UIButton
{
   required init(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)

      if let image = self.imageView?.image
      {
         self.setImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
         self.tintColor = UIColor(white: 0, alpha: 0.3)
      }
   }
}
