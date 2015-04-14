//
//  AlarmOptionSettingsController.swift
//  Modularm
//
//  Created by Klein, Greg on 4/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmOptionSettingsController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

   @IBAction func dismissSelf()
   {
      self.navigationController?.popViewControllerAnimated(true)
   }
}
