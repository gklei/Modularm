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
   
   var alarmTimeController: AlarmTimeController?
   var alarmOptionsController: AlarmOptionsController?
   var timeController: TimeController?
   var alarm: Alarm?

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.setupKeboardNotifications()
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
         case "alarmTimeControllerSegue":
            self.alarmTimeController = segue.destinationViewController as? AlarmTimeController
            break
         case "alarmOptionsControllerSegue":
            self.alarmOptionsController = segue.destinationViewController.childViewControllers![0] as? AlarmOptionsController
            self.alarmOptionsController?.configureWithAlarm(self.alarm)
            break
         case "timeController":
            self.timeController = segue.destinationViewController as? TimeController
            self.timeController?.configureWithAlarm(self.alarm, delegate: self)
            break
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
   
   // MARK: - Public
   func createNewAlarm()
   {
      self.alarm = CoreDataStack.newAlarmModel()
   }
   
   func configureWithAlarm(alarm: Alarm)
   {
      self.alarm = alarm
   }
   
   // MARK: - IBActions
   @IBAction func setButtonPressed()
   {
      self.alarm?.completedSetup = true
      CoreDataStack.save()
      self.navigationController?.popViewControllerAnimated(true)
   }
}

// MARK: - TimeController Delegate
extension AlarmConfigurationController: TimeControllerDelegate
{
   func settingTimeBegan()
   {
      UIView.animateWithDuration(0.25, animations: { () -> Void in
         self.alarmOptionsController?.view.alpha = 0
      })
   }
   
   func settingTimeEnded()
   {
      UIView.animateWithDuration(0.25, animations: { () -> Void in
         self.alarmOptionsController?.view.alpha = 1
      })
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