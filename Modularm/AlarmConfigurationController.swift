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
   @IBOutlet weak var hourLabel: UILabel!
   @IBOutlet weak var minuteLabel: UILabel!
   @IBOutlet weak var labelContainerView: UIView!

   let transitionAnimator = TimeSetterTransitionAnimator()
   private let customBackButton = UIButton(frame: CGRectMake(0, 0, 50, 40))
   var alarmOptionsController: AlarmOptionsController?
   var timeSetterController: TimeSetterViewController
   var alarm: Alarm?
   
   private var isSettingTime = false
   
   required init(coder aDecoder: NSCoder)
   {
      self.timeSetterController = UIStoryboard.controllerWithIdentifier("TimeSetterViewController") as! TimeSetterViewController
      super.init(coder: aDecoder)
      
      self.timeSetterController.delegate = self
      self.timeSetterController.transitioningDelegate = self
      let view = self.timeSetterController.view
   }

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()

      self.customBackButton.backgroundColor = UIColor.clearColor()
      self.setupKeboardNotifications()
      self.setupLabelsWithAlarm(self.alarm)
      
      let hourTapRecognizer = UITapGestureRecognizer(target: self, action: "hourLabelTapped:")
      self.hourLabel.addGestureRecognizer(hourTapRecognizer)
      
      let minuteTapRecognizer = UITapGestureRecognizer(target: self, action: "minuteLabelTapped:")
      self.minuteLabel.addGestureRecognizer(minuteTapRecognizer)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated);
      self.setupSegmentedControl()
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if let identifier = segue.identifier
      {
         switch identifier
         {
         case "alarmOptionsControllerSegue":
            self.alarmOptionsController = segue.destinationViewController.childViewControllers![0] as? AlarmOptionsController
            self.alarmOptionsController?.optionsControllerDelegate = self
            self.alarmOptionsController?.configureWithAlarm(self.alarm)
            self.customBackButton.addTarget(self.alarmOptionsController, action: "returnToMainOptions", forControlEvents: .TouchUpInside)
         default:
            break
         }
      }
   }
   
   // MARK: - Setup
   private func setupKeboardNotifications()
   {
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveAlarmOptionsControllerUpForNotification:", name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveAlarmOptionsControllerDownForNotification:", name: UIKeyboardWillHideNotification, object: nil)
   }
   
   private func setupSegmentedControl()
   {
      self.segmentedControl.selectedSegmentIndex = 1
      self.segmentedControl.enabled = false
      self.segmentedControl.userInteractionEnabled = false
   }
   
   private func setupLabelsWithAlarm(alarm: Alarm?)
   {
      if let hour = self.alarm?.fireDate.hour
      {
         self.hourLabel.text = hour <= 9 ? "0\(hour)" : "\(hour)"
      }
      
      if let minute = self.alarm?.fireDate.minute
      {
         self.minuteLabel.text = minute <= 9 ? "0\(minute)" : "\(minute)"
      }
   }
   
   private func showTimeSetterController()
   {
      self.presentViewController(self.timeSetterController, animated: true, completion: nil)
   }

   // MARK: - Public
   func createNewAlarm()
   {
      self.alarm = CoreDataStack.newAlarmModel()
      self.timeSetterController.configureWithAlarm(self.alarm)
   }
   
   func configureWithAlarm(alarm: Alarm)
   {
      self.alarm = alarm
      self.timeSetterController.configureWithAlarm(self.alarm)
   }
   
   func hourLabelTapped(recognizer: UIGestureRecognizer)
   {
      self.showTimeSetterController()
   }
   
   func minuteLabelTapped(recognizer: UIGestureRecognizer)
   {
      self.showTimeSetterController()
   }
   
   // MARK: - IBActions
   @IBAction func setButtonPressed()
   {
      self.alarm?.completedSetup = true
      
      CoreDataStack.save()
      self.navigationController?.popViewControllerAnimated(true)
   }
}

extension AlarmConfigurationController: AlarmOptionsControllerDelegate
{
   func didShowSettingsForOption()
   {
      self.navigationController?.navigationBar.addSubview(self.customBackButton)
   }
   
   func didDismissSettingsForOption()
   {
      self.customBackButton.removeFromSuperview()
   }
}

extension AlarmConfigurationController: TimeSetterViewControllerDelegate
{
   func timeSetterViewControllerTimeWasTapped()
   {
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