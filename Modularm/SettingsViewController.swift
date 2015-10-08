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
   private var tableViewDataSource: SettingsTableViewDataSource?
   @IBOutlet weak var navigationBar: UINavigationBar!
   @IBOutlet weak var tableView: UITableView! {
      didSet {
         tableViewDataSource = SettingsTableViewDataSource(tableView: tableView)
      }
   }
   
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
   
   override func viewWillDisappear(animated: Bool)
   {
      super.viewWillDisappear(animated)
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
   
   // MARK: - Private
   private func dismiss()
   {
      dismissViewControllerAnimated(true, completion: nil)
   }
}
