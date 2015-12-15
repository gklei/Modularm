//
//  TimeView.swift
//  Modularm
//
//  Created by Klein, Greg on 7/4/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class TimeView: UIView
{
   internal var time: (hour: Int, minute: Int) = (0, 0)
   internal var _visualEffectView: UIVisualEffectView
   
   var useVisualEffectView: Bool {
      get {
         return !_visualEffectView.hidden
      }
      set {
         _visualEffectView.hidden = !newValue
      }
   }
   
   required init?(coder aDecoder: NSCoder)
   {
      let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
      _visualEffectView = UIVisualEffectView(effect: blurEffect)
      super.init(coder: aDecoder)
      
      addSubview(_visualEffectView)
   }
   
   override init(frame: CGRect)
   {
      let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
      _visualEffectView = UIVisualEffectView(effect: blurEffect)
      super.init(frame: frame)
      
      addSubview(_visualEffectView)
   }
   
   func updateTimeWithAlarm(alarm: Alarm)
   {
      self.time = (alarm.fireDate.hour, alarm.fireDate.minute)
   }
   
   func updateTimeWithHour(hour: Int, minute: Int)
   {
      self.time = (hour, minute)
   }
   
   func updateColor(color: UIColor)
   {
   }
   
   func updateBlurEffectStyle(style: UIBlurEffectStyle)
   {
      _visualEffectView.effect = UIBlurEffect(style: style)
   }
   
   override func layoutSubviews()
   {
      super.layoutSubviews()
      _visualEffectView.frame = bounds
   }
}
