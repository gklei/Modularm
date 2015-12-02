//
//  SettingsViewController.swift
//  Modularm
//
//  Created by Gregory Klein on 10/7/15.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate
{
   func settingsWillClose()
}

class SettingsViewController: UIViewController
{
   private var _settingsDelegate: SettingsViewControllerDelegate?
   @IBOutlet weak var navigationBar: UINavigationBar!
   @IBOutlet weak private var _analogClockContainer: UIView!
   @IBOutlet weak private var _digitalClockContainer: UIView!
   
   @IBOutlet weak private var _analogRadialButton: UIButton!
   @IBOutlet weak private var _digitalRadialButton: UIButton!
   
   private var _analogClockDisplayController = TimeDisplayViewController()
   private var _digitalClockDisplayController = TimeDisplayViewController()
   
   // MARK: - Init
   convenience init(delegate: SettingsViewControllerDelegate)
   {
      self.init(nibName: nil, bundle: nil)
      _settingsDelegate = delegate
   }
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationBar.makeTransparent()
      
      _analogClockDisplayController.updateDisplayMode(.Analog)
      _digitalClockDisplayController.updateDisplayMode(.Digital)
      
      _analogClockContainer.addSubview(_analogClockDisplayController.view)
      _digitalClockContainer.addSubview(_digitalClockDisplayController.view)
      
      _analogClockContainer.backgroundColor = UIColor.clearColor()
      _digitalClockContainer.backgroundColor = UIColor.clearColor()
      
      let analogTapRecognizer = UITapGestureRecognizer(target: self, action: "analogRadialButtonPressed")
      _analogClockContainer.addGestureRecognizer(analogTapRecognizer)
      let digitalTapRecognizer = UITapGestureRecognizer(target: self, action: "digitalRadialButtonPressed")
      _digitalClockContainer.addGestureRecognizer(digitalTapRecognizer)
      
      updateRaidalButtons()
   }
   
   override func viewDidAppear(animated: Bool)
   {
      let date = NSDate()
      _analogClockDisplayController.updateTimeWithHour(date.hour, minute: date.minute)
      _digitalClockDisplayController.updateTimeWithHour(date.hour, minute: date.minute)
   }
   
   override func viewDidLayoutSubviews()
   {
      _analogClockDisplayController.view.frame = _analogClockContainer.bounds
      _digitalClockDisplayController.view.frame = _digitalClockContainer.bounds
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle
   {
      return .LightContent
   }
   
   private func updateRaidalButtons()
   {
      switch AppSettingsManager.displayMode
      {
      case .Analog:
         _analogRadialButton.setImage(UIImage(named: "ic_radial_checked"), forState: .Normal)
         _digitalRadialButton.setImage(UIImage(named: "ic_radial"), forState: .Normal)
         break
      case .Digital:
         _digitalRadialButton.setImage(UIImage(named: "ic_radial_checked"), forState: .Normal)
         _analogRadialButton.setImage(UIImage(named: "ic_radial"), forState: .Normal)
         break
      }
   }
   
   // MARK: - IBActions
   @IBAction func doneButtonPressed()
   {
      _settingsDelegate?.settingsWillClose()
      dismiss()
   }
   
   @IBAction func analogRadialButtonPressed()
   {
      AppSettingsManager.setDisplayMode(.Analog)
      updateRaidalButtons()
   }
   
   @IBAction func digitalRadialButtonPressed()
   {
      AppSettingsManager.setDisplayMode(.Digital)
      updateRaidalButtons()
   }
   
   // MARK: - Private
   private func dismiss()
   {
      dismissViewControllerAnimated(true, completion: nil)
   }
}
