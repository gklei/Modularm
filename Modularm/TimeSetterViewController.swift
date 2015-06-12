//
//  ViewController.swift
//  CustomTimeSetter
//
//  Created by Gregory Klein on 5/27/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

let kDisabledAlphaValue: CGFloat = 0.35

protocol TimeSetterViewControllerDelegate
{
   func timeSetterViewControllerTimeWasTapped()
}

class TimeSetterViewController: UIViewController
{
   @IBOutlet weak var hourLabel: UILabel!
   @IBOutlet weak var minuteLabel: UILabel!
   @IBOutlet weak var labelContainerView: UIView!
   @IBOutlet weak var informativeLabel: UILabel!
   
   @IBOutlet weak var hourMarkerView: UIView!
   @IBOutlet weak var minuteMarkerView: UIView!
   
   var currentHourValue: Int? {
      return self.hourScrollViewController?.currentTimeValue?.value
   }
   
   var currentMinuteValue: Int? {
      return self.minuteScrollViewController?.currentTimeValue?.value
   }
   
   var timelineMode: TimelineMode = .Standard
   
   var hourScrollViewController: InfiniteTimelineScrollingViewController?
   var minuteScrollViewController: InfiniteTimelineScrollingViewController?
   
   private weak var alarm: Alarm?
   var delegate: TimeSetterViewControllerDelegate?
   
   func configureWithAlarm(alarm: Alarm?)
   {
      self.alarm = alarm
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      
      self.delay(0.01, closure: { () -> () in
         if let hour = self.alarm?.fireDate.hour where self.hourLabel != nil
         {
            var hourInt = (hour + 12) % 12
            hourInt = hourInt == 0 ? 12 : hourInt
            self.hourLabel.text = hourInt <= 9 ? "0\(hourInt)" : "\(hourInt)"
            self.hourScrollViewController?.scrollToNumber(hour, animated: false)
         }
         
         if let minute = self.alarm?.fireDate.minute where self.minuteLabel != nil
         {
            self.minuteLabel.text = minute <= 9 ? "0\(minute)" : "\(minute)"
            self.minuteScrollViewController?.scrollToNumber(minute, animated: false)
         }
      })
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle
   {
      return .LightContent
   }
   
   private func delay(delay: Double, closure: ()->()) {
      dispatch_after(
         dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
         ),
         dispatch_get_main_queue(), closure)
   }
   
   override func viewDidLayoutSubviews()
   {
      super.viewDidLayoutSubviews()
      
      let globalHourRect = self.view.convertRect(self.hourMarkerView.frame, toView: nil)
      let globalMinuteRect = self.view.convertRect(self.minuteMarkerView.frame, toView: nil)
      
      self.hourScrollViewController?.globalMarkerRect = globalHourRect
      self.minuteScrollViewController?.globalMarkerRect = globalMinuteRect
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if let identifier = segue.identifier
      {
         switch identifier
         {
         case "hourTimelineScrollViewController":
            self.setupHourScrollViewControllerWithSegue(segue)
            break
         case "minuteTimelineScrollViewController":
            self.setupMinuteScrollViewControllerWithSegue(segue)
            break
         default:
            break
         }
      }
   }
   
   private func setupHourScrollViewControllerWithSegue(segue: UIStoryboardSegue)
   {
      self.hourScrollViewController = segue.destinationViewController as? InfiniteTimelineScrollingViewController
      let attributes = TimelineViewAttributes(orientation: .Left, interval: .Hour, mode: self.timelineMode)
      self.hourScrollViewController?.timelineAttributes = attributes
      self.hourScrollViewController?.infiniteScrollViewDelegate = self
   }
   
   private func setupMinuteScrollViewControllerWithSegue(segue: UIStoryboardSegue)
   {
      self.minuteScrollViewController = segue.destinationViewController as? InfiniteTimelineScrollingViewController
      let attributes = TimelineViewAttributes(orientation: .Right, interval: .Minute, mode: self.timelineMode)
      self.minuteScrollViewController?.timelineAttributes = attributes
      self.minuteScrollViewController?.infiniteScrollViewDelegate = self
   }
   
   private func giveScrollViewFocus(scrollView: InfiniteTimelineScrollView)
   {
      var hourLabelAlpha: CGFloat = 1
      var minuteLabelAlpha: CGFloat = 1
      var leftScrollViewAlpha: CGFloat = 1
      var rightScrollViewAlpha: CGFloat = 1
      var leftBarViewAlpha: CGFloat = 1
      var rightBarViewAlpha: CGFloat = 1
      
      if self.hourScrollViewController!.infiniteScrollView.isEqual(scrollView)
      {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.minuteScrollViewController?.killScroll()
            self.minuteScrollViewController?.snapClosestTimeAniated(true)
         })
         rightScrollViewAlpha = kDisabledAlphaValue
         minuteLabelAlpha = kDisabledAlphaValue
         rightBarViewAlpha = kDisabledAlphaValue
      }
      else
      {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.hourScrollViewController?.killScroll()
            self.hourScrollViewController?.snapClosestTimeAniated(true)
         })
         
         leftScrollViewAlpha = kDisabledAlphaValue
         hourLabelAlpha = kDisabledAlphaValue
         leftBarViewAlpha = kDisabledAlphaValue
      }
      
      UIView.animateWithDuration(0.2, animations: { () -> Void in
         self.hourLabel.alpha = hourLabelAlpha
         self.minuteLabel.alpha = minuteLabelAlpha
         self.hourScrollViewController?.infiniteScrollView.alpha = leftScrollViewAlpha
         self.minuteScrollViewController?.infiniteScrollView.alpha = rightScrollViewAlpha
         self.hourMarkerView.alpha = leftBarViewAlpha
         self.minuteMarkerView.alpha = rightBarViewAlpha
      })
   }
}

extension TimeSetterViewController: InfiniteTimelineScrollingViewControllerDelegate
{
   func infiniteScrollViewWasTapped(scrollView: InfiniteTimelineScrollView, atGlobalLocation location: CGPoint)
   {
      if self.labelContainerView.frame.contains(location)
      {         
         self.delegate?.timeSetterViewControllerTimeWasTapped()
      }
      else
      {
         self.giveScrollViewFocus(scrollView)
      }
   }
   
   func infiniteScrollViewWillBeginDragging(scrollView: InfiniteTimelineScrollView)
   {
      self.giveScrollViewFocus(scrollView)
   }
   
   func infiniteScrollViewDidScroll(scrollView: InfiniteTimelineScrollView)
   {
      self.updateLabelsWithScrollView(scrollView)
   }
   
   private func updateLabelsWithScrollView(scrollView: InfiniteTimelineScrollView)
   {
      let scrollViewController: InfiniteTimelineScrollingViewController
      let label: UILabel
      switch scrollView.timelineAttributes.interval
      {
      case .Minute:
         scrollViewController = self.minuteScrollViewController!
         label = self.minuteLabel!
         break
      case .Hour:
         scrollViewController = self.hourScrollViewController!
         label = self.hourLabel!
         break
      }
      
      if let timeValue = scrollViewController.closestTimeValue
      {
         scrollViewController.updateAndHideCurrentTimeValue(timeValue)
         label.text = timeValue.associatedLabel.text?.substring(0, length: 2)
      }
      
      self.updateInformativeTimeLabel()
   }
   
   func updateInformativeTimeLabel()
   {
      if self.currentHourValue != nil && self.currentMinuteValue != nil
      {
         let currentDate = NSDate()
         
         let currentHourMinute = (currentDate.hour, currentDate.minute)
         let dateHourMinute = (self.currentHourValue!, self.currentMinuteValue!)
         
         var hour = dateHourMinute.0 - currentHourMinute.0
         if dateHourMinute.0 < currentHourMinute.0 {
            hour += 24
         }
         
         var minute = dateHourMinute.1 - currentHourMinute.1
         if dateHourMinute.1 < currentHourMinute.1 {
            minute += 60
            hour -= 1
         }
         
         if hour == 0 && minute == 0 {
            hour = 24
         }
         
         if hour < 0 {
            hour = 23
         }
         
         self.informativeLabel.text = "\(hour) hours and \(minute) minutes"
      }
   }
}

