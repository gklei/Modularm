//
//  AlarmViewController.swift
//  Modularm
//
//  Created by Klein, Greg on 6/28/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmDetailViewController: UIViewController
{
   private var alarm: Alarm?
   
   @IBOutlet weak private var _alarmTimeContainerWidthConstraint: NSLayoutConstraint!
   @IBOutlet weak private var _alarmTimeContainerHeightConstraint: NSLayoutConstraint!
   @IBOutlet weak var alarmTimeContainerView: UIView!
   
   @IBOutlet weak var alarmMessageLabel: UILabel!
   @IBOutlet weak var cancelButton: UIButton!
   @IBOutlet weak var _snoozeButton: UIButton!
   @IBOutlet private weak var _backgroundImageView: UIImageView!
   @IBOutlet private weak var _visualEffectView: UIVisualEffectView!
   
   private var alarmIsFiring = false
   private var _timeDisplayViewController = TimeDisplayViewController()
   private var _displayMode = AppSettingsManager.displayMode
   
   private let _alarmConfigurationController = UIStoryboard.alarmConfigurationController()
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      alarmTimeContainerView.addSubview(_timeDisplayViewController.view)
      _snoozeButton.hidden = true
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      
      var summary = "clear-night"
      if let weather = self.alarm?.weather {
         summary = weather.readableTextSummary
      }
      updateUIWithWeatherSummary(summary)
      
      updateTitle()
      updateTimeLabels()
      updateUIForFiringState()
      
      updateTimeContainerConstraintsWithDisplayMode(_displayMode)
      let _ = _alarmConfigurationController.view
   }
   
   override func viewWillDisappear(animated: Bool)
   {
      super.viewWillDisappear(animated)
      
      let color = UIColor.whiteColor()
      navigationController?.navigationBar.tintColor = color
      navigationController?.navigationBar.barTintColor = color
      navigationItem.leftBarButtonItem?.tintColor = color
      
      navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : color]
   }
   
   override func viewDidLayoutSubviews()
   {
      super.viewDidLayoutSubviews()
      _timeDisplayViewController.view.frame = alarmTimeContainerView.bounds
   }
   
   // MARK: - Private
   private func updateUIWithWeatherSummary(summary: String)
   {
      var backgroundImageName = "clear-night"
      if let weather = self.alarm?.weather
      {
         backgroundImageName = weather.readableTextSummary
      }
      _backgroundImageView.image = UIImage(named: backgroundImageName)
      
      let color = textColorForBackgroundImageName(backgroundImageName)
      _timeDisplayViewController.updateMainColor(color)
      alarmMessageLabel.textColor = color
      
      let style = statusBarStyleForWeatherSummary(backgroundImageName)
      UIApplication.sharedApplication().setStatusBarStyle(style, animated: true)
      
      _visualEffectView.effect = blurEffectForWeatherSummary(backgroundImageName)
      
      navigationController?.navigationBar.tintColor = color
      navigationController?.navigationBar.barTintColor = color
      navigationItem.leftBarButtonItem?.tintColor = color
      
      navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : color]
   }
   
   private func updateUIForFiringState()
   {
      if self.alarmIsFiring
      {
         self.cancelButton.hidden = false
         self.navigationController?.navigationBarHidden = true
      }
      else
      {
         self.cancelButton.hidden = true
         self.navigationController?.navigationBarHidden = false
         self.setupEditButton()
      }
   }
   
   private func updateTitle()
   {
      if let alarmDate = self.alarm?.fireDate
      {
         let countdownTime = AlarmCountdownUtility.timeUntilAlarmHour(alarmDate.hour, minute: alarmDate.minute)
         self.title = "Alarm in \(countdownTime.hour)h \(countdownTime.minute)m"
      }
   }
   
   private func setupEditButton()
   {
      let color = UIColor.lipstickRedColor()
      let barButtonItem = UIBarButtonItem.rightBarButtonItemWithTitle("edit", color: color)
      barButtonItem.target = self
      barButtonItem.action = "editButtonPressed"
      
      self.navigationItem.rightBarButtonItem = barButtonItem
   }

   private func updateTimeLabels()
   {
      if let alarm = self.alarm
      {
         let time = alarm.fireDate
         _timeDisplayViewController.updateDisplayMode(AppSettingsManager.displayMode)
         _timeDisplayViewController.updateTimeWithHour(time.hour, minute: time.minute)
      }
      if let message = self.alarm?.message?.text
      {
         self.alarmMessageLabel.text = message
      }
      else
      {
         if let soundName = self.alarm?.sound?.alarmSound?.name
         {
            self.alarmMessageLabel.text = "Alarm sound: \(soundName)"
         }
         else
         {
            self.alarmMessageLabel.text = "No sound is set!"
         }
      }
   }
   
   
   private func updateTimeContainerConstraintsWithDisplayMode(mode: DisplayMode)
   {
      var height: CGFloat = 0.0
      switch mode {
      case .Analog:
         height = 230.0
         break
      case .Digital:
         height = 85.0
         break
      }
      _alarmTimeContainerHeightConstraint.constant = height
   }
   
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      self.navigationItem.backBarButtonItem = barButtonItem
   }
   
   private func textColorForBackgroundImageName(name: String) -> UIColor
   {
      var color = UIColor.blackColor()
      switch name
      {
      case "wind", "thunderstorm", "clear-night":
         color = UIColor.whiteColor()
         break
      default:
         break
      }
      return color
   }
   
   private func blurEffectForWeatherSummary(summary: String) -> UIBlurEffect
   {
      var style = UIBlurEffectStyle.ExtraLight
      switch summary
      {
      case "wind", "thunderstorm", "clear-night":
         style = .Dark
         break
      default:
         break
      }
      return UIBlurEffect(style: style)
   }
   
   private func statusBarStyleForWeatherSummary(summary: String) -> UIStatusBarStyle
   {
      var style = UIStatusBarStyle.Default
      switch summary
      {
      case "wind", "thunderstorm", "clear-night":
         style = .LightContent
         break
      default:
         break
      }
      return style
   }
   // MARK: - Public
   func configureWithAlarm(alarm: Alarm?, isFiring: Bool, displayMode: DisplayMode)
   {
      self.alarm = alarm
      alarmIsFiring = isFiring
      _displayMode = displayMode
      
      let time = alarm!.fireDate
      _timeDisplayViewController.updateDisplayMode(displayMode)
      _timeDisplayViewController.updateTimeWithHour(time.hour, minute: time.minute)
   }
   
   // MARK: - IBActions
   func editButtonPressed()
   {
      if let alarm = self.alarm
      {
         _alarmConfigurationController.configureWithAlarm(alarm)
         self.navigationController?.pushViewController(_alarmConfigurationController, animated: true)
         self.updateBackBarButtonItemWithTitle("Back")
      }
   }
   
   @IBAction func cancelButtonPressed()
   {
      self.alarm?.active = false
      self.alarm?.updateAlarmDate()
      self.navigationController?.popViewControllerAnimated(true)
   }
}
