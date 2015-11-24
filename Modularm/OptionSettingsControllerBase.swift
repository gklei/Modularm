//
//  OptionSettingsControllerBase.swift
//  Modularm
//
//  Created by Klein, Greg on 5/10/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class OptionSettingsControllerBase: UIViewController
{
   @IBOutlet weak var circleImageView: UIImageView!
   @IBOutlet weak var iconImageView: UIImageView!
   @IBOutlet weak var setOptionButton: UIButton!
   
   internal var alarm: Alarm?
   internal var auxiliaryView: UIView?
   internal var viewControllerForPresenting: UIViewController?
   
   private(set) var option: AlarmOption = .Unknown
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.iconImageView.tintColor = UIColor.lipstickRedColor()
      self.circleImageView.image = UIImage(named: "bg-icn-plus-circle")?.originalImage
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      
      let title = self.titleForOption(self.option)
      self.setOptionButton.setTitle(title, forState: .Normal)
      self.iconImageView.image = self.option.plusIcon
   }
   
   func configureWithAlarm(alarm: Alarm?, option: AlarmOption, auxiliaryView: UIView?)
   {
      self.alarm = alarm
      self.option = option
      self.auxiliaryView = auxiliaryView
   }
   
   func updateViewControllerForPresenting(vc: UIViewController?)
   {
      viewControllerForPresenting = vc
   }
   
   internal func dismissSelf()
   {
      // temporary
      self.navigationController?.popViewControllerAnimated(true)
   }
   
   internal func titleForOption(option: AlarmOption) -> String
   {
      var title = ""
      switch (option)
      {
      case .Message:
         title = "set message"
         break
      case .Music:
         title = "set music"
         break
      case .Repeat:
         title = "set repeat"
         break
      case .Snooze:
         title = "set snooze"
         break
      case .Sound:
         title = "set sound"
         break
         
      default:
         break
      }
      return title
   }
}
