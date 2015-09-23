//
//  TapScrollView.swift
//  Modularm
//
//  Created by Klein, Greg on 5/17/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

protocol TapScrollViewDelegate
{
   func tapScrollView(scrollView: UIScrollView, touchesBegan touches: NSSet, withEvent event: UIEvent)
   func tapScrollView(scrollView: UIScrollView, touchesCancelled touches: NSSet, withEvent event: UIEvent)
   func tapScrollView(scrollView: UIScrollView, touchesEnded touches: NSSet, withEvent event: UIEvent)
}

class TapScrollView: UIScrollView
{
   var tapDelegate: TapScrollViewDelegate?
   
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
   {
      super.touchesBegan(touches, withEvent: event)
      if !self.dragging
      {
         self.tapDelegate?.tapScrollView(self, touchesBegan: touches, withEvent: event!)
      }
   }
   
   override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
   {
      super.touchesMoved(touches, withEvent: event)
      self.tapDelegate?.tapScrollView(self, touchesCancelled: touches, withEvent: event!)
   }
   
   override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
   {
      super.touchesCancelled(touches, withEvent: event)
      self.tapDelegate?.tapScrollView(self, touchesCancelled: touches!, withEvent: event!)
   }
   
   override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
   {
      if !self.dragging
      {
         self.tapDelegate?.tapScrollView(self, touchesEnded: touches, withEvent: event!)
      }
      else
      {
         super.touchesEnded(touches, withEvent: event)
      }
   }
}
