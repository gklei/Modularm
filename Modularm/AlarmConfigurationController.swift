//
//  AlarmConfigurationController.swift
//  Modularm
//
//  Created by Gregory Klein on 4/13/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class AlarmConfigurationController: UIViewController
{
   // MARK: - Instance Variables
   @IBOutlet weak var setBarButtonItem: UIBarButtonItem!
   @IBOutlet weak var alarmOptionsHeightConstraint: NSLayoutConstraint!
   @IBOutlet weak var alarmOptionsControllerBottomVerticalSpaceConstraint: NSLayoutConstraint!
   @IBOutlet weak var segmentedControl: UISegmentedControl!

   private let customBackButton = UIButton(frame: CGRectMake(0, 0, 70, 40))
   
   private var alarm: Alarm?
   private var originalAlarmFireDate: NSDate?
   
   private let transitionAnimator = TimeSetterTransitionAnimator()
   private var alarmOptionsController: AlarmOptionsViewController?
   private var timeSetterController: TimeSetterViewController
   private var alarmPreviewController: AlarmPreviewViewController?
   
   required init?(coder aDecoder: NSCoder)
   {
      self.timeSetterController = UIStoryboard.controllerWithIdentifier("TimeSetterViewController") as! TimeSetterViewController
      super.init(coder: aDecoder)
      
      self.timeSetterController.delegate = self
      self.timeSetterController.transitioningDelegate = self
      
      // load the view as soon as possible
      _ = self.timeSetterController.view
   }

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.setupKeboardNotifications()
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      self.setupCustomBackButton()
   }
   
   override func viewWillDisappear(animated: Bool)
   {
      super.viewWillDisappear(animated)
      self.customBackButton.removeFromSuperview()
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if let identifier = segue.identifier
      {
         switch identifier
         {
         case "alarmOptionsControllerSegue":
            self.setupAlarmOptionsControllerWithSegue(segue)
            
         case "alarmPreviewViewControllerSegue":
            self.setupAlarmPreviewControllerWithSegue(segue)
         default:
            break
         }
      }
   }
   
   // MARK: - Setup
   private func setupAlarmPreviewControllerWithSegue(segue: UIStoryboardSegue)
   {
      self.alarmPreviewController = segue.destinationViewController as? AlarmPreviewViewController
      self.alarmPreviewController?.configureWithAlarm(self.alarm)
      
      let tapRecognizer = UITapGestureRecognizer(target: self, action: "showTimeSetterController")
      tapRecognizer.cancelsTouchesInView = false
      self.alarmPreviewController?.view.addGestureRecognizer(tapRecognizer)
   }
   
   private func setupAlarmOptionsControllerWithSegue(segue: UIStoryboardSegue)
   {
      self.alarmOptionsController = segue.destinationViewController.childViewControllers[0] as? AlarmOptionsViewController
      self.alarmOptionsController?.optionsControllerDelegate = self
      self.alarmOptionsController?.configureWithAlarm(self.alarm)
   }
   
   private func setupCustomBackButton()
   {
      self.customBackButton.backgroundColor = UIColor.clearColor()
      
      if self.setBarButtonItem.enabled
      {
         self.customBackButton.removeTarget(self.alarmOptionsController, action: "dismissSelf", forControlEvents: .TouchUpInside)
         self.customBackButton.addTarget(self, action: "dismissSelf", forControlEvents: .TouchUpInside)
      }
      else
      {
         self.customBackButton.removeTarget(self, action: "dismissSelf", forControlEvents: .TouchUpInside)
         self.customBackButton.addTarget(self.alarmOptionsController, action: "returnToMainOptions", forControlEvents: .TouchUpInside)
      }
      
      self.navigationController?.navigationBar.addSubview(self.customBackButton)
   }
   
   private func setupKeboardNotifications()
   {
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveAlarmOptionsControllerUpForNotification:", name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveAlarmOptionsControllerDownForNotification:", name: UIKeyboardWillHideNotification, object: nil)
   }
   
   // MARK: - Private
   private func configureControllersWithAlarm(alarm: Alarm?)
   {
      self.timeSetterController.configureWithAlarm(alarm)
      self.alarmPreviewController?.configureWithAlarm(alarm)
      self.alarmOptionsController?.configureWithAlarm(alarm)
   }

   // MARK: - Public
   func createNewAlarm()
   {
      self.alarm = CoreDataStack.newAlarmModel()
      self.originalAlarmFireDate = self.alarm?.fireDate.copy() as? NSDate
      self.configureControllersWithAlarm(self.alarm)
   }
   
   func configureWithAlarm(alarm: Alarm)
   {
      self.alarm = alarm
      self.originalAlarmFireDate = self.alarm?.fireDate.copy() as? NSDate
      self.configureControllersWithAlarm(self.alarm)
   }
   
   func showTimeSetterController()
   {
      self.presentViewController(self.timeSetterController, animated: true, completion: nil)
   }
   
   // MARK: - IBActions
   @IBAction func setButtonPressed()
   {
      self.alarm?.completedSetup = true
      
      var alarmTime: (hour: Int, minute: Int) = (self.originalAlarmFireDate!.hour, self.originalAlarmFireDate!.minute)
      if let hour = self.timeSetterController.currentHourValue, minute = self.timeSetterController.currentMinuteValue
      {
         alarmTime.hour = hour
         alarmTime.minute = minute
      }
      
      AlarmManager.enableAlarm(self.alarm!, withHour: alarmTime.hour, minute: alarmTime.minute)
      self.navigationController?.popToRootViewControllerAnimated(true)
   }
   
   func dismissSelf()
   {
      self.alarm?.fireDate = self.originalAlarmFireDate!
      if self.alarm?.completedSetup == false
      {
         CoreDataStack.deleteObject(self.alarm)
      }
      self.navigationController?.popViewControllerAnimated(true)
   }
}

extension AlarmConfigurationController: AlarmOptionsControllerDelegate
{
   func didShowSettingsForOption()
   {
      self.customBackButton.removeTarget(self, action: "dismissSelf", forControlEvents: .TouchUpInside)
      self.customBackButton.addTarget(self.alarmOptionsController, action: "returnToMainOptions", forControlEvents: .TouchUpInside)
      
      self.setBarButtonItem.enabled = false
      
      UIView.animateWithDuration(0.2, animations: { () -> Void in
         self.segmentedControl.alpha = 0
         self.setBarButtonItem.setTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -50), forBarMetrics: .Default)
      })
   }
   
   func didDismissSettingsForOption()
   {
      self.customBackButton.removeTarget(self.alarmOptionsController, action: "dismissSelf", forControlEvents: .TouchUpInside)
      self.customBackButton.addTarget(self, action: "dismissSelf", forControlEvents: .TouchUpInside)
      
      self.setBarButtonItem.enabled = true
      
      UIView.animateWithDuration(0.2, animations: { () -> Void in
         self.segmentedControl.alpha = 1
         self.setBarButtonItem.setTitlePositionAdjustment(UIOffsetZero, forBarMetrics: .Default)
      })
   }
   
   func optionPreviewAuxiliaryView() -> UIView?
   {
      return self.alarmPreviewController?.previewAuxiliaryView
   }
}

extension AlarmConfigurationController: TimeSetterViewControllerDelegate
{
   func timeSetterViewControllerTimeWasTapped()
   {
      if let hour = self.timeSetterController.currentHourValue, minute = self.timeSetterController.currentMinuteValue
      {
         self.alarmPreviewController?.updateLabelsWithHour(hour, minute: minute)
         self.alarm?.fireDate = NSDate.alarmDateWithHour(hour, minute: minute)
      }
      self.timeSetterController.dismissViewControllerAnimated(true, completion: nil)
      self.alarmPreviewController?.updateInformativeTimeLabel()
   }
}

extension AlarmConfigurationController: UIViewControllerTransitioningDelegate
{
   func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
   {
      self.transitionAnimator.presenting = true
      return self.transitionAnimator
   }
   
   func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
   {
      self.transitionAnimator.presenting = false
      return self.transitionAnimator
   }
}

// MARK: - NSNotificationCenter Methods
extension AlarmConfigurationController
{
   func moveAlarmOptionsControllerUpForNotification(notification: NSNotification)
   {
      if let info = notification.userInfo
      {
         let keyboardBoundsValue = info[UIKeyboardFrameEndUserInfoKey] as! NSValue
         let keyboardBounds = keyboardBoundsValue.CGRectValue()
         let height = CGRectGetHeight(keyboardBounds)
         
         UIView.animateWithDuration(0.25, animations: {() -> Void in
            self.alarmOptionsControllerBottomVerticalSpaceConstraint.constant = height
            self.view.layoutIfNeeded()
         })
      }
   }
   
   func moveAlarmOptionsControllerDownForNotification(notification: NSNotification)
   {
      UIView.animateWithDuration(0.25, animations: {() -> Void in
         self.alarmOptionsControllerBottomVerticalSpaceConstraint.constant = 0
         self.view.layoutIfNeeded()
      })
   }
}