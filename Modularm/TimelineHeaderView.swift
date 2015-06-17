//
//  TimelineHeaderView.swift
//  Modularm
//
//  Created by Gregory Klein on 5/17/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class TimelineHeaderView: UICollectionReusableView
{
   @IBOutlet weak var hourLabel: UILabel!
   @IBOutlet weak var minuteLabel: UILabel!
   @IBOutlet weak var amOrPmLabel: UILabel!
   
   @IBOutlet weak var innerContentView: UIView!
   @IBOutlet weak var scrollView: TapScrollView!
   
   private var deleteButton: UIButton = UIButton.timelineCellDeleteButton()
   private var toggleButton: UIButton = UIButton.timelineCellToggleButton()
   private var buttonContainer = UIView()
   private var isOpen: Bool = false
   
   var alarm: Alarm?
   weak var timelineController: TimelineController?
   
   // MARK: - Lifecycle
   override func awakeFromNib()
   {
      self.deleteButton.frame = CGRectMake(0, 0, 60, CGRectGetHeight(self.bounds) * 0.5)
      self.deleteButton.addTarget(self, action: "deletePressed", forControlEvents: .TouchUpInside)
      
      self.toggleButton.frame = CGRectMake(0, CGRectGetHeight(self.deleteButton.frame), 60, CGRectGetHeight(self.deleteButton.frame))
      self.toggleButton.addTarget(self, action: "togglePressed", forControlEvents: .TouchUpInside)
      
      self.setupButtonContainer()
      self.setupScrollViewWithButtonContainer(self.buttonContainer)
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOpen:", name: RevealCellDidOpenNotification, object: nil)
   }
   
   override func layoutSubviews()
   {
      super.layoutSubviews()
      
      self.scrollView.contentSize = CGSizeMake(self.innerContentView.frame.size.width + CGRectGetWidth(self.buttonContainer.frame), self.scrollView.frame.size.height);
      
      self.setupButtonContainer()
      self.setupScrollViewWithButtonContainer(self.buttonContainer)
      self.repositionButtons()
   }
   
   // MARK: - Setup
   private func setupScrollViewWithButtonContainer(container: UIView)
   {
      self.scrollView.tapDelegate = self
      
      container.removeFromSuperview()
      self.scrollView.insertSubview(container, belowSubview: self.innerContentView)
   }
   
   private func setupButtonContainer()
   {
      self.buttonContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.deleteButton.frame), CGRectGetHeight(self.bounds))
      
      self.deleteButton.removeFromSuperview()
      self.buttonContainer.addSubview(self.deleteButton)
      
      self.toggleButton.removeFromSuperview()
      self.buttonContainer.addSubview(self.toggleButton)
   }
   
   // MARK: - Private
   private func repositionButtons()
   {
      var frame = self.buttonContainer.frame;
      frame.origin.x = self.innerContentView.frame.size.width - CGRectGetWidth(self.buttonContainer.frame) + self.scrollView.contentOffset.x;
      self.buttonContainer.frame = frame;
   }
   
   private func animateContenteOffset(position: CGPoint, withDuration duration: NSTimeInterval)
   {
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
         UIView.animateWithDuration(duration, animations: { () -> Void in
            self.scrollView.contentOffset = position
         })
      })
   }
   
   private func animateContenteOffset(position: CGPoint, withDuration duration: NSTimeInterval, completion: ((Bool) -> Void)?)
   {
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
         UIView.animateWithDuration(duration, animations: { () -> Void in
            self.scrollView.contentOffset = position
            }, completion: completion)
      })
   }
   
   private func setColorsWithViewModel(model: TimelineCellAlarmViewModel)
   {
      self.innerContentView.backgroundColor = model.innerContentViewBackgroundColor
      self.scrollView.backgroundColor = model.scrollViewBackgroundColor
   }
   
   private func delay(delay: Double, closure: ()->()) {
      dispatch_after(
         dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
         ),
         dispatch_get_main_queue(), closure)
   }
   
   // MARK: - Public
   func configureWithAlarm(alarm: Alarm)
   {
      self.alarm = alarm
      
      self.hourLabel.text = TimeDisplayProvider.textForHourValue(alarm.fireDate.hour)
      self.minuteLabel.text = TimeDisplayProvider.textForMinuteValue(alarm.fireDate.minute)
      self.amOrPmLabel.text = alarm.fireDate.hour < 12 ? "am" : "pm"
      
      var viewModel = TimelineCellAlarmViewModel(alarm: alarm)
      self.setColorsWithViewModel(viewModel)
      
      self.delay(0.1, closure: { () -> () in
         self.setNeedsLayout()
      })
   }
   
   // MARK: - Notification-based Methods
   func onOpen(notification: NSNotification)
   {
      if let object = notification.object as? TimelineCollectionViewCell where object != self && self.isOpen {
         self.animateContenteOffset(CGPointZero, withDuration: 0.1)
      }
   }
   
   // MARK: - Button Actions
   func togglePressed()
   {
      self.scrollView.contentOffset = CGPointZero
      self.alarm?.active = false
      CoreDataStack.save()
   }
   
   func deletePressed()
   {
      self.scrollView.contentOffset = CGPointZero
      CoreDataStack.deleteObject(self.alarm)
      CoreDataStack.save()
   }
   
   // MARK: IBActions
   @IBAction func editButtonPressed()
   {
      if let controller = self.timelineController, alarm = self.alarm
      {
         controller.openSettingsForAlarm(alarm)
      }
   }
}

extension TimelineHeaderView: UIScrollViewDelegate
{
   func scrollViewDidScroll(scrollView: UIScrollView)
   {
      self.repositionButtons()
      
      // Don't allow scrolling right
      if scrollView.contentOffset.x < 0 {
         scrollView.contentOffset = CGPointZero;
      }
      
      if scrollView.contentOffset.x >= CGRectGetWidth(self.buttonContainer.frame)
      {
         self.isOpen = true;
         NSNotificationCenter.defaultCenter().postNotificationName(RevealCellDidOpenNotification, object: self)
      }
      else
      {
         self.isOpen = false;
      }
   }
   
   func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
   {
      var contentOffset = CGPointZero
      if velocity.x > 0
      {
         targetContentOffset.memory.x = CGRectGetWidth(self.buttonContainer.frame)
         contentOffset.x = CGRectGetWidth(self.buttonContainer.frame)
      }
      else
      {
         targetContentOffset.memory.x = 0;
      }
      self.animateContenteOffset(contentOffset, withDuration: 0.1)
   }
}

extension TimelineHeaderView: TapScrollViewDelegate
{
   func tapScrollView(scrollView: UIScrollView, touchesEnded touches: NSSet, withEvent event: UIEvent)
   {
   }
   
   func tapScrollView(scrollView: UIScrollView, touchesBegan touches: NSSet, withEvent event: UIEvent)
   {
   }
   
   func tapScrollView(scrollView: UIScrollView, touchesCancelled touches: NSSet, withEvent event: UIEvent)
   {
   }
}
