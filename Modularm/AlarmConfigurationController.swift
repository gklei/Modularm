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

   private let customBackButton = UIButton(frame: CGRectMake(0, 0, 50, 40))
   
   private var alarm: Alarm?
   private var originalAlarmFireDate: NSDate?
   
   private let transitionAnimator = TimeSetterTransitionAnimator()
   private var alarmOptionsController: AlarmOptionsController?
   private var timeSetterController: TimeSetterViewController
   private var alarmPreviewController: AlarmPreviewViewController?
   
   private var isSettingTime = false
   
   required init(coder aDecoder: NSCoder)
   {
      self.timeSetterController = UIStoryboard.controllerWithIdentifier("TimeSetterViewController") as! TimeSetterViewController
      super.init(coder: aDecoder)
      
      self.timeSetterController.delegate = self
      self.timeSetterController.transitioningDelegate = self
   }

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      self.setupCustomBackButton()
      self.setupKeboardNotifications()
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
      self.alarmPreviewController?.delegate = self
      self.alarmPreviewController?.configureWithAlarm(self.alarm)
   }
   
   private func setupAlarmOptionsControllerWithSegue(segue: UIStoryboardSegue)
   {
      self.alarmOptionsController = segue.destinationViewController.childViewControllers![0] as? AlarmOptionsController
      self.alarmOptionsController?.optionsControllerDelegate = self
      self.alarmOptionsController?.configureWithAlarm(self.alarm)
   }
   
   private func setupCustomBackButton()
   {
      self.customBackButton.backgroundColor = UIColor.clearColor()
      self.customBackButton.addTarget(self.alarmOptionsController, action: "dismissSelf", forControlEvents: .TouchUpInside)
      self.navigationController?.navigationBar.addSubview(self.customBackButton)
   }
   
   private func setupKeboardNotifications()
   {
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveAlarmOptionsControllerUpForNotification:", name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveAlarmOptionsControllerDownForNotification:", name: UIKeyboardWillHideNotification, object: nil)
   }
   
   // MARK: - Private
   private func showTimeSetterController()
   {
      self.presentViewController(self.timeSetterController, animated: true, completion: nil)
   }

   // MARK: - Public
   func createNewAlarm()
   {
      self.alarm = CoreDataStack.newAlarmModel()
      self.originalAlarmFireDate = self.alarm?.fireDate.copy() as? NSDate
      self.timeSetterController.configureWithAlarm(self.alarm)
      self.alarmPreviewController?.configureWithAlarm(self.alarm)
   }
   
   func configureWithAlarm(alarm: Alarm)
   {
      self.alarm = alarm
      self.originalAlarmFireDate = self.alarm?.fireDate.copy() as? NSDate
      self.timeSetterController.configureWithAlarm(self.alarm)
   }
   
   // MARK: - IBActions
   @IBAction func setButtonPressed()
   {
      self.alarm?.completedSetup = true
      
      if let hour = self.timeSetterController.currentHourValue, minute = self.timeSetterController.currentMinuteValue
      {
         self.alarm?.fireDate = NSDate.alarmDateWithHour(hour, minute: minute)
      }
      else if let originalDate = self.originalAlarmFireDate
      {
         self.alarm?.fireDate = NSDate.alarmDateWithHour(originalDate.hour, minute: originalDate.minute)
      }
      
      CoreDataStack.save()
      self.navigationController?.popViewControllerAnimated(true)
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

extension AlarmConfigurationController: AlarmPreviewViewControllerDelegate
{
   func alarmPreviewHourLabelTapped()
   {
      self.showTimeSetterController()
   }
   
   func alarmPreviewMinuteLabelTapped()
   {
      self.showTimeSetterController()
   }
}

extension AlarmConfigurationController: AlarmOptionsControllerDelegate
{
   func didShowSettingsForOption()
   {
      self.customBackButton.removeTarget(self, action: "dismissSelf", forControlEvents: .TouchUpInside)
      self.customBackButton.addTarget(self.alarmOptionsController, action: "returnToMainOptions", forControlEvents: .TouchUpInside)
   }
   
   func didDismissSettingsForOption()
   {
      self.customBackButton.removeTarget(self.alarmOptionsController, action: "dismissSelf", forControlEvents: .TouchUpInside)
      self.customBackButton.addTarget(self, action: "dismissSelf", forControlEvents: .TouchUpInside)
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
      if let info = notification.userInfo
      {
         UIView.animateWithDuration(0.25, animations: {() -> Void in
            self.alarmOptionsControllerBottomVerticalSpaceConstraint.constant = 0
            self.view.layoutIfNeeded()
         })
      }
   }
}