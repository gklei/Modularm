//
//  AlarmPreviewViewController.swift
//  Modularm
//
//  Created by Klein, Greg on 6/11/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmPreviewViewController: UIViewController
{
   // MARK: - Properties
   @IBOutlet weak var alarmTimeView: DigitalTimeView!
   @IBOutlet weak var alarmWillGoOffInLabel: UILabel!
   @IBOutlet weak var informativeTimeLabel: UILabel!
   @IBOutlet weak var previewAuxiliaryView: UIView!
   
   private weak var alarm: Alarm?
   private var _alarmViewTransformer: ViewTransformer?
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.view.backgroundColor = UIColor.clearColor()
      
      let leftRightEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
      leftRightEffect.minimumRelativeValue = 20.0
      leftRightEffect.maximumRelativeValue = -20.0
      
      let upDownEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
      upDownEffect.minimumRelativeValue = 14.0
      upDownEffect.maximumRelativeValue = -14.0
      
      let effectGroup = UIMotionEffectGroup()
      effectGroup.motionEffects = [leftRightEffect, upDownEffect]
      
      alarmTimeView.addMotionEffect(effectGroup)
      alarmTimeView.useVisualEffectView = false
      
      alarmWillGoOffInLabel.addMotionEffect(effectGroup)
      informativeTimeLabel.addMotionEffect(effectGroup)
      
      _alarmViewTransformer = ViewTransformer(view: view)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      self.updateHourAndMinuteLabelsWithAlarm(self.alarm)
      self.updateInformativeTimeLabel()
   }

   // MARK: Public
   func configureWithAlarm(alarm: Alarm?)
   {
      self.alarm = alarm
   }
   
   func setInformativeTimeLabelsHidden(hidden: Bool, animated: Bool)
   {
      let alpha: CGFloat = hidden ? 0.0 : 1.0
      if animated
      {
         UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.alarmWillGoOffInLabel.alpha = alpha
            self.informativeTimeLabel.alpha = alpha
         })
      }
      else
      {
         alarmWillGoOffInLabel.alpha = alpha
         informativeTimeLabel.alpha = alpha
      }
   }
   
   // MARK: - Private
   private func updateHourAndMinuteLabelsWithAlarm(alarm: Alarm?)
   {
      if let alarm = self.alarm
      {
         self.alarmTimeView.updateTimeWithAlarm(alarm)
      }
   }
   
   func updateLabelsWithHour(hour: Int, minute: Int)
   {
      self.alarmTimeView.updateTimeWithHour(hour, minute: minute)
   }
   
   func updateInformativeTimeLabel()
   {
      if let alarmDate = self.alarm?.fireDate
      {
         self.informativeTimeLabel.text = AlarmCountdownUtility.countdownTextForAlarmDate(alarmDate)
      }
   }
}

extension AlarmPreviewViewController
{
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      super.touchesBegan(touches, withEvent: event)
      _alarmViewTransformer?.touchesBegan(touches, withEvent: event!)
   }
   
   override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
      super.touchesMoved(touches, withEvent: event)
      _alarmViewTransformer?.touchesMoved(touches, withEvent: event!)
   }
   
   override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
      super.touchesEnded(touches, withEvent: event)
      _alarmViewTransformer?.resetViewWithDuration(0.4)
   }
   
   override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
      super.touchesCancelled(touches, withEvent: event)
      _alarmViewTransformer?.resetViewWithDuration(0.4)
   }
}
