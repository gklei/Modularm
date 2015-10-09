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
   private var currentTimeView = TimeView()
   private var digitalTimeView = DigitalTimeView(frame: CGRect.zero)
   private var analogTimeView = AnalogTimeView(frame: CGRect.zero)
   
   // MARK: - Init
   required init?(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)
   }
   
   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
   {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   }
   
   convenience init()
   {
      self.init(nibName: nil, bundle: nil)
   }
   
   // MARK: - Overridden
   override func viewDidLoad()
   {
      super.viewDidLoad()
      updateDisplayMode(AppSettingsManager.displayMode)
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
   }
   
   // MARK: - Public
   func updateDisplayMode(mode: DisplayMode)
   {
      updateUIForMode(mode)
   }
   
   func updateTimeWithHour(hour: Int, minute: Int)
   {
      currentTimeView.updateTimeWithHour(hour, minute: minute)
   }
}
