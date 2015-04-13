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
   // MARK: - Instance Variables
   @IBOutlet weak var centerNavigationItem: UINavigationItem!
   @IBOutlet weak var timelineDataSource: TimelineDataSource!

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.navigationController?.navigationBar.hideBottomHairline()
   }

   override func viewWillAppear(animated: Bool)
   {
      self.updateBackBarButtonItemWithTitle("Modularm")
   }

   override func viewWillDisappear(animated: Bool)
   {
      self.updateBackBarButtonItemWithTitle("Back")
   }

   // MARK: - Private
   private func setupNavigationBar()
   {
      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
      self.navigationController?.navigationBar.shadowImage = UIImage()

      let rgbValue: CGFloat = 12/255.0
      self.navigationController?.navigationBar.backgroundColor = UIColor(red: rgbValue, green: rgbValue, blue: rgbValue, alpha: 1)
   }

   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      self.navigationItem.backBarButtonItem = barButtonItem
   }
}
