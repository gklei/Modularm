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
   var settingsDelegate: SettingsViewControllerDelegate?
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
   
   convenience init(delegate: SettingsViewControllerDelegate)
   {
      self.init(nibName: nil, bundle: nil)
      settingsDelegate = delegate
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
      settingsDelegate?.settingsWillClose()
      dismiss()
   }
   
   // MARK: - Private
   private func dismiss()
   {
      dismissViewControllerAnimated(true, completion: nil)
   }
}
