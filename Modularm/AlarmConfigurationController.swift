//
//  AlarmConfigurationController.swift
//  Modularm
//
//  Created by Gregory Klein on 4/13/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmConfigurationController: UIViewController
{
   @IBOutlet weak var alarmOptionsControllerBottomVerticalSpaceConstraint: NSLayoutConstraint!
   private var navigationBarIsHidden = false

   override func viewDidLoad()
   {
      super.viewDidLoad()
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveAlarmOptionsControllerUpForNotification:", name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveAlarmOptionsControllerDownForNotification:", name: UIKeyboardWillHideNotification, object: nil)
   }
   
   func moveAlarmOptionsControllerUpForNotification(notification: NSNotification)
   {
      if let info = notification.userInfo
      {
         let keyboardBoundsValue = info[UIKeyboardFrameEndUserInfoKey] as! NSValue
         let keyboardBounds = keyboardBoundsValue.CGRectValue()
         let height = CGRectGetHeight(keyboardBounds)
         
         UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alarmOptionsControllerBottomVerticalSpaceConstraint.constant = height
            self.view.layoutIfNeeded()
         })
      }
      println("notification: \(notification)")
   }
   
   func moveAlarmOptionsControllerDownForNotification(notification: NSNotification)
   {
      if let info = notification.userInfo
      {
         UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alarmOptionsControllerBottomVerticalSpaceConstraint.constant = 0
            self.view.layoutIfNeeded()
         })
      }
      println("notification: \(notification)")
   }
}
