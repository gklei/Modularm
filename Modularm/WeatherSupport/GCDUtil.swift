//
//  GCDUtil.swift
//  Modularm
//
//  Created by Alex Hong on 10/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

class GCDUtil{
   class func runOnMainAsync(block:()->()){
      if NSThread.currentThread().isMainThread {
         block()
      } else {
         dispatch_async(dispatch_get_main_queue()){
            block()
         }
      }
   }
   
   class func runOnMainSync(block:()->()){
      if NSThread.currentThread().isMainThread{
         block()
      } else {
         dispatch_sync(dispatch_get_main_queue()) { () -> Void in
            block()
         }
      }
   }
   
   class func runAsync(block:()->()){
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
         block()
      }
   }
}