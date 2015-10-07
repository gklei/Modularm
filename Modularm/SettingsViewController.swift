//
//  SettingsViewController.swift
//  Modularm
//
//  Created by Gregory Klein on 10/7/15.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{
   @IBOutlet weak var navigationBar: UINavigationBar!
   
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
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationBar.makeTransparent()
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle
   {
      return .LightContent
   }
   
   // MARK: - IBActions
   @IBAction func doneButtonPressed()
   {
      dismiss()
   }
   
   @IBAction func cancelButtonPressed()
   {
      dismiss()
   }
   
   // MARK: - Private
   private func dismiss()
   {
      dismissViewControllerAnimated(true, completion: nil)
   }
}
