//
//  TimeDisplayViewController.swift
//  Modularm
//
//  Created by Gregory Klein on 10/9/15.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class TimeDisplayViewController: UIViewController
{
   private var mode: DisplayMode?
   private var currentTimeView = TimeView()
   private var digitalTimeView = DigitalTimeView(frame: CGRect.zero)
   private var analogTimeView = AnalogTimeView(frame: CGRect.zero)
   
   // MARK: - Init
   convenience init()
   {
      self.init(nibName: nil, bundle: nil)
   }
   
   // MARK: - Overridden
   override func viewDidLoad()
   {
      super.viewDidLoad()
      updateUIForMode(AppSettingsManager.displayMode)
   }
   
   // MARK: - Overridden
   override func viewDidLayoutSubviews()
   {
      super.viewDidLayoutSubviews()
      currentTimeView.frame = view.bounds
   }
   
   // MARK: - Private
   private func updateUIForMode(mode: DisplayMode)
   {
      self.mode = mode
      currentTimeView.removeFromSuperview()
      switch mode {
      case .Analog:
         currentTimeView = analogTimeView
         break
      case .Digital:
         currentTimeView = digitalTimeView
         break
      }
      view.addSubview(currentTimeView)
      currentTimeView.setNeedsDisplay()
   }
   
   // MARK: - Public
   func updateDisplayMode(mode: DisplayMode)
   {
      if let displayMode = self.mode where displayMode != mode {
         updateUIForMode(mode)
      }
   }
   
   func updateTimeWithHour(hour: Int, minute: Int)
   {
      currentTimeView.updateTimeWithHour(hour, minute: minute)
   }
}
