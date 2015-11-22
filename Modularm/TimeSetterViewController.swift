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
   func doneButtonPressed()
}

class TimeSetterViewController: UIViewController
{
   @IBOutlet weak var hourLabel: UILabel!
   @IBOutlet weak var minuteLabel: UILabel!
   @IBOutlet weak var labelContainerView: UIView!
   @IBOutlet weak var informativeLabel: UILabel!
   
   @IBOutlet weak var amLabel: UILabel!
   @IBOutlet weak var pmLabel: UILabel!
   
   @IBOutlet weak var hourMarkerView: UIView!
   @IBOutlet weak var minuteMarkerView: UIView!
   
   @IBOutlet weak var doneButton: UIButton!
   
   // FIX THIS LATER
   private var temporaryHourValue: Int?
   private var temporaryMinuteValue: Int?
   
   var currentHourValue: Int? {
      if temporaryHourValue != nil {
         return temporaryHourValue
      } else {
         return hourScrollViewController?.currentTimeValue?.value
      }
   }
   
   var currentMinuteValue: Int? {
      if temporaryMinuteValue != nil {
         return temporaryMinuteValue
      } else {
         return minuteScrollViewController?.currentTimeValue?.value
      }
   }
   
   var timelineMode: TimelineMode = .Standard
   
   var hourScrollViewController: InfiniteTimelineScrollingViewController?
   var minuteScrollViewController: InfiniteTimelineScrollingViewController?
   
   private weak var alarm: Alarm?
   var delegate: TimeSetterViewControllerDelegate?
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      
      temporaryHourValue = nil
      temporaryMinuteValue = nil
      
      delay(0.01, closure: { () -> () in
         if let hour = self.alarm?.fireDate.hour where self.hourLabel != nil
         {
            self.hourScrollViewController?.scrollToNumber(hour, animated: false)
         }
         
         if let minute = self.alarm?.fireDate.minute where self.minuteLabel != nil
         {
            self.minuteScrollViewController?.scrollToNumber(minute, animated: false)
         }
      })
      
      updateInformativeTimeLabel()
   }
   
   override func viewDidLayoutSubviews()
   {
      super.viewDidLayoutSubviews()
      
      let globalHourRect = view.convertRect(hourMarkerView.frame, toView: nil)
      let globalMinuteRect = view.convertRect(minuteMarkerView.frame, toView: nil)
      
      hourScrollViewController?.globalMarkerRect = globalHourRect
      minuteScrollViewController?.globalMarkerRect = globalMinuteRect
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle
   {
      return .LightContent
   }
   
   @IBAction func doneButtonPressed()
   {
      delegate?.doneButtonPressed()
   }
   
   func configureWithAlarm(alarm: Alarm?)
   {
      self.alarm = alarm
      temporaryHourValue = alarm?.fireDate.hour
      temporaryMinuteValue = alarm?.fireDate.minute
   }
   
   func updateTimeLabels()
   {
      if let hour = alarm?.fireDate.hour where hourLabel != nil
      {
         hourLabel.text = TimeDisplayProvider.textForHourValue(hour)
         updateAmAndPmLabelAlphaWithHour(hour)
      }
      
      if let minute = alarm?.fireDate.minute where minuteLabel != nil
      {
         minuteLabel.text = TimeDisplayProvider.textForMinuteValue(minute)
      }
   }
   
   private func delay(delay: Double, closure: ()->()) {
      dispatch_after(
         dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
         ),
         dispatch_get_main_queue(), closure)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if let identifier = segue.identifier
      {
         switch identifier
         {
         case "hourTimelineScrollViewController":
            setupHourScrollViewControllerWithSegue(segue)
            break
         case "minuteTimelineScrollViewController":
            setupMinuteScrollViewControllerWithSegue(segue)
            break
         default:
            break
         }
      }
   }
   
   private func setupHourScrollViewControllerWithSegue(segue: UIStoryboardSegue)
   {
      hourScrollViewController = segue.destinationViewController as? InfiniteTimelineScrollingViewController
      let attributes = TimelineViewAttributes(orientation: .Left, interval: .Hour, mode: timelineMode)
      hourScrollViewController?.timelineAttributes = attributes
      hourScrollViewController?.infiniteScrollViewDelegate = self
   }
   
   private func setupMinuteScrollViewControllerWithSegue(segue: UIStoryboardSegue)
   {
      minuteScrollViewController = segue.destinationViewController as? InfiniteTimelineScrollingViewController
      let attributes = TimelineViewAttributes(orientation: .Right, interval: .Minute, mode: timelineMode)
      minuteScrollViewController?.timelineAttributes = attributes
      minuteScrollViewController?.infiniteScrollViewDelegate = self
   }
   
   private func giveScrollViewFocus(scrollView: InfiniteTimelineScrollView)
   {
      var hourLabelAlpha: CGFloat = 1
      var minuteLabelAlpha: CGFloat = 1
      var leftScrollViewAlpha: CGFloat = 1
      var rightScrollViewAlpha: CGFloat = 1
      var leftBarViewAlpha: CGFloat = 1
      var rightBarViewAlpha: CGFloat = 1
      
      if hourScrollViewController!.infiniteScrollView.isEqual(scrollView)
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
   
   private func amLabelTapped()
   {
      if let hour = self.currentHourValue where hour >= 12
      {
         self.hourScrollViewController?.scrollToNumber(hour - 12, animated: false)
         giveScrollViewFocus(hourScrollViewController!.infiniteScrollView!)
      }
   }
   
   private func pmLabelTapped()
   {
      if let hour = self.currentHourValue where hour < 12
      {
         self.hourScrollViewController?.scrollToNumber(hour + 12, animated: false)
         giveScrollViewFocus(hourScrollViewController!.infiniteScrollView!)
      }
   }
}

extension TimeSetterViewController: InfiniteTimelineScrollingViewControllerDelegate
{
   func infiniteScrollViewWasTapped(scrollView: InfiniteTimelineScrollView, atGlobalLocation location: CGPoint)
   {
      if labelContainerView.frame.contains(location)
      {         
         delegate?.timeSetterViewControllerTimeWasTapped()
      }
      else if amLabel.frame.contains(location)
      {
         amLabelTapped()
      }
      else if pmLabel.frame.contains(location)
      {
         pmLabelTapped()
      }
      else
      {
         giveScrollViewFocus(scrollView)
      }
   }
   
   func infiniteScrollViewWillBeginDragging(scrollView: InfiniteTimelineScrollView)
   {
      giveScrollViewFocus(scrollView)
   }
   
   func infiniteScrollViewDidScroll(scrollView: InfiniteTimelineScrollView)
   {
      updateLabelsWithScrollView(scrollView)
   }
   
   private func updateLabelsWithScrollView(scrollView: InfiniteTimelineScrollView)
   {
      let scrollViewController: InfiniteTimelineScrollingViewController
      let label: UILabel
      switch scrollView.timelineAttributes.interval
      {
      case .Minute:
         scrollViewController = minuteScrollViewController!
         label = minuteLabel!
         break
      case .Hour:
         scrollViewController = hourScrollViewController!
         label = hourLabel!
         break
      }
      
      if let timeValue = scrollViewController.closestTimeValue
      {
         scrollViewController.updateAndHideCurrentTimeValue(timeValue)
         label.text = timeValue.associatedLabel.text?.substring(0, length: 2)
      }
      
      updateInformativeTimeLabel()
   }
   
   private func updateAmAndPmLabelAlphaWithHour(hour: Int)
   {
      amLabel.alpha = hour < 12 ? 1 : kDisabledAlphaValue
      pmLabel.alpha = hour >= 12 ? 1 : kDisabledAlphaValue
   }
   
   func updateInformativeTimeLabel()
   {
      if let hour = currentHourValue, minute = currentMinuteValue
      {
         informativeLabel.text = AlarmCountdownUtility.informativeCountdownTextForHour(hour, minute: minute)
         updateAmAndPmLabelAlphaWithHour(hour)
      }
   }
}

