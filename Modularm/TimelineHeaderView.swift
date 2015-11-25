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
   @IBOutlet weak var timeContainerHeightConstraint: NSLayoutConstraint!
   @IBOutlet weak var timeContainerWidthConstraint: NSLayoutConstraint!
   @IBOutlet weak var smallTimeLabelHeightConstraint: NSLayoutConstraint!
   @IBOutlet weak var timeLabelLeadingSpaceConstraint: NSLayoutConstraint!
   
   @IBOutlet weak var alarmTimeContainerView: UIView!
   @IBOutlet weak var innerContentView: UIView!
   @IBOutlet weak var scrollView: TapScrollView!
   @IBOutlet weak var smallTimeLabel: UILabel!
   @IBOutlet weak var messageLabel: UILabel!
   
   @IBOutlet private weak var circleImageView1: UIImageView!
   @IBOutlet private weak var circleImageView2: UIImageView!
   @IBOutlet private weak var circleImageView3: UIImageView!
   @IBOutlet private weak var circleImageView4: UIImageView!
   
   @IBOutlet private weak var iconImageView1: UIImageView!
   @IBOutlet private weak var iconImageView2: UIImageView!
   @IBOutlet private weak var iconImageView3: UIImageView!
   @IBOutlet private weak var iconImageView4: UIImageView!
   
   private var orderedImageViews: ([(iconImageView: UIImageView, circleImageView: UIImageView)]) {
      get {
         return [
            (iconImageView1, circleImageView1),
            (iconImageView2, circleImageView2),
            (iconImageView3, circleImageView3),
            (iconImageView4, circleImageView4)
         ]
      }
   }
   
   private var orderedOptions: [AlarmOption] {
      get {
         return [.Snooze, .Music, .Weather, .Repeat]
      }
   }
   
   private var deleteButton: UIButton = UIButton.timelineCellDeleteButton()
   private var toggleButton: UIButton = UIButton.timelineCellToggleButton()
   private var buttonContainer = UIView()
   private var isOpen: Bool = false
   
   private var timeDisplayViewController = TimeDisplayViewController()
   private var originalTimeLabelHeight: CGFloat = 0
   
   var alarm: Alarm?
   weak var timelineController: TimelineController?
   
   // MARK: - Lifecycle
   override func awakeFromNib()
   {
      setupToggleAndDeleteButtons()
      setupButtonContainer()
      setupScrollViewWithButtonContainer(self.buttonContainer)
      
      originalTimeLabelHeight = smallTimeLabelHeightConstraint.constant
      
      alarmTimeContainerView.addSubview(timeDisplayViewController.view)
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOpen:", name: RevealCellDidOpenNotification, object: nil)
      
      for imageViews in orderedImageViews {
         imageViews.circleImageView.tintColor = UIColor.blackColor()
         imageViews.circleImageView.image = UIImage(named: "bg-icn-plus-circle")?.templateImage
      }
   }
   
   override func layoutSubviews()
   {
      super.layoutSubviews()
      
      self.scrollView.contentSize = CGSizeMake(self.innerContentView.frame.size.width + CGRectGetWidth(self.buttonContainer.frame), self.scrollView.frame.size.height);
      
      self.setupButtonContainer()
      self.setupScrollViewWithButtonContainer(self.buttonContainer)
      self.repositionButtons()
      
      smallTimeLabelHeightConstraint.constant = AppSettingsManager.displayMode == .Analog ? originalTimeLabelHeight : 0
      timeDisplayViewController.view.frame = alarmTimeContainerView.bounds
      
      
      var leadingSpaceConstant: CGFloat = 4.0
      var openSpaceAvailable = false // check to see if at least one icon image view is hidden
      for imageViews in orderedImageViews {
         if imageViews.iconImageView.hidden {
            openSpaceAvailable = true
         }
      }
      
      if AppSettingsManager.displayMode == .Analog || openSpaceAvailable {
         leadingSpaceConstant = -self.alarmTimeContainerView.frame.minX + 40.0
      }
      self.timeLabelLeadingSpaceConstraint.constant = leadingSpaceConstant
   }
   
   // MARK: - Setup
   private func setupToggleAndDeleteButtons()
   {
      self.toggleButton.frame = CGRectMake(0, 0, 60, CGRectGetHeight(self.bounds) * 0.6)
      self.toggleButton.addTarget(self, action: "togglePressed", forControlEvents: .TouchDown)
      
      self.deleteButton.frame = CGRectMake(0, CGRectGetHeight(self.toggleButton.frame), 60, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.toggleButton.frame))
      self.deleteButton.addTarget(self, action: "deletePressed", forControlEvents: .TouchDown)
   }
   
   private func updateDeleteAndToggleButtonFrames()
   {
      self.toggleButton.frame = CGRectMake(0, 0, 60, CGRectGetHeight(self.bounds) * 0.6)
      self.deleteButton.frame = CGRectMake(0, CGRectGetHeight(self.toggleButton.frame), 60, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.toggleButton.frame))
   }
   
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
      
      updateDeleteAndToggleButtonFrames()
   }
   
   private func animateContentOffset(position: CGPoint, withDuration duration: NSTimeInterval)
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
   
   private func setBackgroundColorsWithViewModel(model: TimelineCellAlarmViewModel)
   {
      self.innerContentView.backgroundColor = model.innerContentViewBackgroundColor
      self.scrollView.backgroundColor = model.scrollViewBackgroundColor
   }
   
   private func setLabelTextWithViewModel(model: TimelineCellAlarmViewModel)
   {
      var viewModel = model
      smallTimeLabel.text = viewModel.smallTimeLabelText
      messageLabel.text = viewModel.messageLabelText
   }
   
   private func delay(delay: Double, closure: ()->()) {
      dispatch_after(
         dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
         ),
         dispatch_get_main_queue(), closure)
   }
   
   private func updateTimeContainerConstraintsWithDisplayMode(mode: DisplayMode)
   {
      var height: CGFloat = 0.0
      switch mode {
      case .Analog:
         height = 230.0
         break
      case .Digital:
         height = 70.0
         break
      }
      timeContainerHeightConstraint.constant = height
   }
   
   private func updateCirlceImageViewsWithAlarm(alarm: Alarm)
   {
      resetImageViewsVisibility()
      
      var imageViewsIndex = 0
      for option in orderedOptions
      {
         if alarm.optionIsEnabled(option)
         {
            let imageViews = orderedImageViews[imageViewsIndex]
            imageViews.circleImageView.hidden = false
            imageViews.iconImageView.hidden = false
            imageViews.iconImageView.image = UIImage(option: option)
            
            ++imageViewsIndex
         }
      }
   }
   
   private func resetImageViewsVisibility()
   {
      for imageViews in orderedImageViews
      {
         imageViews.circleImageView.hidden = true
         imageViews.iconImageView.hidden = true
      }
   }
   
   // MARK: - Public
   func configureWithAlarm(alarm: Alarm, displayMode: DisplayMode)
   {
      self.alarm = alarm

      updateTimeContainerConstraintsWithDisplayMode(displayMode)
      
      let time = alarm.fireDate
      timeDisplayViewController.updateDisplayMode(displayMode)
      timeDisplayViewController.updateTimeWithHour(time.hour, minute: time.minute)
      
      let viewModel = TimelineCellAlarmViewModel(alarm: alarm)
      setBackgroundColorsWithViewModel(viewModel)
      setLabelTextWithViewModel(viewModel)
      
      updateCirlceImageViewsWithAlarm(alarm)
      
      self.delay(0.1, closure: { () -> () in
         self.setNeedsLayout()
      })
   }
   
   // MARK: - Notification-based Methods
   func onOpen(notification: NSNotification)
   {
      if let object = notification.object as? TimelineCollectionViewCell where object != self && self.isOpen {
         self.animateContentOffset(CGPointZero, withDuration: 0.1)
      }
   }
   
   // MARK: - Button Actions
   func togglePressed()
   {
      self.scrollView.contentOffset = CGPointZero
      AlarmManager.disableAlarm(self.alarm!)
   }
   
   func deletePressed()
   {
      self.scrollView.contentOffset = CGPointZero
      AlarmManager.deleteAlarm(self.alarm!)
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
      self.animateContentOffset(contentOffset, withDuration: 0.1)
   }
}

extension TimelineHeaderView: TapScrollViewDelegate
{
   func tapScrollView(scrollView: UIScrollView, touchesEnded touches: NSSet, withEvent event: UIEvent)
   {
      if self.isOpen
      {
         self.animateContenteOffset(CGPointZero, withDuration: 0.1, completion: { (finished: Bool) -> Void in
            self.isOpen = false
         })
      }
      else
      {
         if let controller = self.timelineController, alarm = self.alarm
         {
            controller.showDetailsForAlarm(alarm)
         }
      }
   }
   
   func tapScrollView(scrollView: UIScrollView, touchesBegan touches: NSSet, withEvent event: UIEvent)
   {
   }
   
   func tapScrollView(scrollView: UIScrollView, touchesCancelled touches: NSSet, withEvent event: UIEvent)
   {
   }
}
