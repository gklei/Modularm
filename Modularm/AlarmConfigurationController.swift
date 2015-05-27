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
   var alarmOptionsController: AlarmOptionsController?
   var timeController: TimeController?
   var alarm: Alarm?

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()

      self.customBackButton.backgroundColor = UIColor.clearColor()
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
         case "alarmOptionsControllerSegue":
            self.alarmOptionsController = segue.destinationViewController.childViewControllers![0] as? AlarmOptionsController
            self.alarmOptionsController?.optionsControllerDelegate = self
            self.alarmOptionsController?.configureWithAlarm(self.alarm)
            self.customBackButton.addTarget(self.alarmOptionsController, action: "returnToMainOptions", forControlEvents: .TouchUpInside)
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
      if let controller = self.timeController
      {
         self.alarm?.fireDate = controller.timePicker.alarmDate
      }
      
      CoreDataStack.save()
      self.navigationController?.popViewControllerAnimated(true)
   }
}

// MARK: - TimeController Delegate
extension AlarmConfigurationController: TimeControllerDelegate
{
   func settingTimeBegan()
   {
      self.setBarButtonItem.enabled = false
      UIView.animateWithDuration(0.25, animations: { () -> Void in
         self.alarmOptionsController?.view.alpha = 0
      })
   }
   
   func settingTimeEnded()
   {
      self.setBarButtonItem.enabled = true
      UIView.animateWithDuration(0.25, animations: { () -> Void in
         self.alarmOptionsController?.view.alpha = 1
      })
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