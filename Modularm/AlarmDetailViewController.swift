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
   @IBOutlet weak var _snoozeButtonHeightConstraint: NSLayoutConstraint!
   @IBOutlet private weak var _backgroundImageView: UIImageView!
   @IBOutlet private weak var _weatherIconImageView: UIImageView!
   @IBOutlet private weak var _weatherTextLabel: UILabel!
   
   private var _alarmIsFiring = false
   private var _timeDisplayViewController = TimeDisplayViewController()
   private var _displayMode = AppSettingsManager.displayMode
   
   private let _alarmConfigurationController = UIStoryboard.alarmConfigurationController()
   
   // FOR TESTING
   private var _currentBackgroundImageIndex = 0
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      alarmTimeContainerView.addSubview(_timeDisplayViewController.view)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      
      var summaryType = WeatherSummaryType("clear-night")
      if let weather = self.alarm?.weather {
         summaryType = weather.weatherSummaryType
      }
      _updateUIWithWeatherSummaryType(summaryType)
      
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
      updateNavbarWithColor(color)
   }
   
   override func viewDidLayoutSubviews()
   {
      super.viewDidLayoutSubviews()
      _timeDisplayViewController.view.frame = alarmTimeContainerView.bounds
   }
   
   private func _updateUIWithWeatherSummaryType(summary: WeatherSummaryType)
   {
      _backgroundImageView.image = summary.images.first ?? UIImage(named: "clear-night")
      let imageName = summary.imageNames.first ?? "clear-night"
      
      let color = textColorForBackgroundImageName(imageName)
      _timeDisplayViewController.updateMainColor(color)
      alarmMessageLabel.textColor = color
      updateNavbarWithColor(color)
      
      let style = blurEffectStyleForBackgroundImageName(imageName)
      _timeDisplayViewController.updateBlurEffectStyle(style)
      
      let statusBarStyle = statusBarStyleForWeatherSummary(imageName)
      UIApplication.sharedApplication().setStatusBarStyle(statusBarStyle, animated: true)
      
      _weatherIconImageView.image = summary.icon
      _weatherIconImageView.tintColor = color
      _weatherTextLabel.textColor = color
      
      _updateWeatherIconAndLabel()
   }
   
   private func _updateWeatherIconAndLabel()
   {
      var description = "No weather description"
      if let weather = self.alarm?.weather {
         description = "\(weather.fahrenheitTemperature)º F – \(weather.weatherDescription)"
      }
      _weatherTextLabel.text = description
   }
   
   private func updateNavbarWithColor(color: UIColor)
   {
      navigationController?.navigationBar.tintColor = color
      navigationController?.navigationBar.barTintColor = color
      navigationItem.leftBarButtonItem?.tintColor = color
      navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : color]
   }
   
   private func updateUIForFiringState()
   {
      if self._alarmIsFiring {
         self.cancelButton.hidden = false
         self.navigationController?.navigationBarHidden = true
      }
      else {
         self.cancelButton.hidden = true
         self.navigationController?.navigationBarHidden = false
         self.setupEditButton()
      }
      
      var snoozeButtonHeightConstant: CGFloat = 0
      var snoozeHidden = true
      if let _ = self.alarm?.snooze {
         snoozeButtonHeightConstant = 80
         snoozeHidden = false
      }
      _snoozeButtonHeightConstraint.constant = snoozeButtonHeightConstant
      _snoozeButton.hidden = snoozeHidden
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
      if let alarm = self.alarm {
         let time = alarm.fireDate
         _timeDisplayViewController.updateDisplayMode(_displayMode)
         _timeDisplayViewController.updateTimeWithHour(time.hour, minute: time.minute)
      }
      if let message = self.alarm?.message?.text {
         self.alarmMessageLabel.text = message
      }
      else {
         if let soundName = self.alarm?.sound?.alarmSound?.name{
            self.alarmMessageLabel.text = "Alarm sound: \(soundName)"
         }
         else {
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
   
   private func blurEffectStyleForBackgroundImageName(name: String) -> UIBlurEffectStyle
   {
      var style = UIBlurEffectStyle.Light
      switch name
      {
      case "wind", "thunderstorm", "clear-night":
         style = UIBlurEffectStyle.Dark
         break
      default:
         break
      }
      return style
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
      _alarmIsFiring = isFiring
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
      if let alarm = self.alarm {
         alarm.active = false
         AlarmEngine.sharedInstance.cancelAlarm(alarm)
         alarm.updateAlarmDate()
      }
      self.navigationController?.popViewControllerAnimated(true)
   }
   
   @IBAction private func _snoozeButtonPressed()
   {
      if let alarm = self.alarm,
         let snooze = alarm.snooze where _alarmIsFiring {
            let duration = Int(snooze.duration.rawValue)
            AlarmEngine.sharedInstance.snoozeAlarm(alarm, afterMinutes: duration)
      }
      
      if _alarmIsFiring == true {
         self.navigationController?.popViewControllerAnimated(true)
      }
   }
   
   @IBAction func updateBackgroundImage()
   {
      let types = WeatherSummaryType.allValues
      _updateUIWithWeatherSummaryType(types[_currentBackgroundImageIndex++ % types.count])
   }
}
