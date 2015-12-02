//
//  AlarmConfigurationController.swift
//  Modularm
//
//  Created by Gregory Klein on 4/13/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

let kAlarmSegmentedIndex = 0
let kTimerSegmentedIndex = 1

class AlarmConfigurationController: UIViewController
{
   // MARK: - Instance Variables
   @IBOutlet weak var setBarButtonItem: UIBarButtonItem!
   @IBOutlet weak var alarmOptionsControllerBottomVerticalSpaceConstraint: NSLayoutConstraint!
   @IBOutlet private weak var _backgroundImageView: UIImageView!
   @IBOutlet private weak var _alarmTypeSegmentedControl: UISegmentedControl!

   private let customBackButton = UIButton(frame: CGRectMake(0, 0, 70, 40))
   
   private var alarm: Alarm?
   private var originalAlarmFireDate: NSDate?
   
   private let transitionAnimator = TimeSetterTransitionAnimator()
   private var alarmOptionsController: AlarmOptionsViewController?
   private var timeSetterController: TimeSetterViewController
   private var alarmPreviewController: AlarmPreviewViewController?
   
   required init?(coder aDecoder: NSCoder)
   {
      timeSetterController = UIStoryboard.controllerWithIdentifier("TimeSetterViewController") as! TimeSetterViewController
      super.init(coder: aDecoder)
   }

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      // load the view as soon as possible
      _ = self.timeSetterController.view
      self.timeSetterController.delegate = self
      
      setupKeboardNotifications()
      setupParallaxEffect()
      
      navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
      title = "Configure"
   }
   
   func setupParallaxEffect()
   {
      let leftRightEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
      leftRightEffect.minimumRelativeValue = -15.0
      leftRightEffect.maximumRelativeValue = 15.0
      
      let upDownEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
      upDownEffect.minimumRelativeValue = -5.0
      upDownEffect.maximumRelativeValue = 5.0
      
      let effectGroup = UIMotionEffectGroup()
      effectGroup.motionEffects = [leftRightEffect, upDownEffect]
      
      _backgroundImageView.addMotionEffect(effectGroup)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      self.setupCustomBackButton()
      self.navigationController?.setNavigationBarHidden(false, animated: true);
      UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
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
      self.alarmOptionsController?.configureWithAlarm(self.alarm, vcForPresenting: self)
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
      self.alarmOptionsController?.configureWithAlarm(alarm, vcForPresenting: self)
   }

   // MARK: - Public
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
      
      self.alarm?.updateWeatherInfo()
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
      self._alarmTypeSegmentedControl.enabled = false
   }
   
   func didDismissSettingsForOption()
   {
      self.customBackButton.removeTarget(self.alarmOptionsController, action: "dismissSelf", forControlEvents: .TouchUpInside)
      self.customBackButton.addTarget(self, action: "dismissSelf", forControlEvents: .TouchUpInside)
      
      self.setBarButtonItem.enabled = true
      self._alarmTypeSegmentedControl.enabled = true
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
      updateAlarmPreviewAndDismissTimeSetter()
   }
   
   func doneButtonPressed()
   {
      updateAlarmPreviewAndDismissTimeSetter()
   }
   
   private func updateAlarmPreviewAndDismissTimeSetter()
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
         
         alarmPreviewController?.setInformativeTimeLabelsHidden(true, animated: true)
      }
   }
   
   func moveAlarmOptionsControllerDownForNotification(notification: NSNotification)
   {
      UIView.animateWithDuration(0.25, animations: {() -> Void in
         self.alarmOptionsControllerBottomVerticalSpaceConstraint.constant = 0
         self.view.layoutIfNeeded()
      })
      
      alarmPreviewController?.setInformativeTimeLabelsHidden(false, animated: true)
   }
}