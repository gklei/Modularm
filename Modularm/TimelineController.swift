//
//  AlarmHistoryController.swift
//  Modularm
//
//  Created by Gregory Klein on 4/10/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class TimelineController: UIViewController
{
   @IBOutlet weak var timelineDataSource: TimelineDataSource!

   override func viewDidLoad()
   {
      super.viewDidLoad()
      setupNavBar()
   }

   private func setupNavBar()
   {
      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
      self.navigationController?.navigationBar.shadowImage = UIImage()

      let rgbValue: CGFloat = 12/255.0
      self.navigationController?.navigationBar.backgroundColor = UIColor(red: rgbValue, green: rgbValue, blue: rgbValue, alpha: 1)
   }
}
