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
   @IBOutlet var collectionView: UICollectionView!
   
   private var _settingsViewController: SettingsViewController?
   lazy private var _configurationController: AlarmConfigurationController = {
      return UIStoryboard.controllerWithIdentifier("AlarmConfigurationController") as! AlarmConfigurationController
   }()
   lazy private var _alarmDetailViewController: AlarmDetailViewController = {
      return UIStoryboard.controllerWithIdentifier("AlarmDetailViewController") as! AlarmDetailViewController
   }()
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationController?.navigationBar.makeTransparent()
      
      _settingsViewController = SettingsViewController(delegate: self)
      timelineDataSource.removeIncompleteAlarms()
      
      registerCollectionViewNibs()
      setupFlowLayoutItemSize()
   }

   override func viewWillAppear(animated: Bool)
   {
      navigationController?.setNavigationBarHidden(false, animated: true);
      timelineDataSource.removeIncompleteAlarms()
   }

   override func viewWillDisappear(animated: Bool)
   {
      updateBackBarButtonItemWithTitle("Back")
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if segue.identifier == "addAlarmButtonPressed"
      {
         if let alarm = AlarmManager.createNewAlarm()
         {
            let configurationController = segue.destinationViewController as! AlarmConfigurationController
            configurationController.configureWithAlarm(alarm)
         }
      }
   }

   // MARK: - IBActions
   @IBAction func addNewAlarmButtonPressed()
   {
      if let alarm = AlarmManager.createNewAlarm()
      {
         _configurationController.configureWithAlarm(alarm)
         navigationController?.pushViewController(_configurationController, animated: true)
      }
   }
   
   @IBAction func logCurrentScheduledNotifications()
   {
      AlarmScheduler.logCurrentScheduledNotifications()
   }
   
   @IBAction func settingsButtonPressed()
   {
      if let settingsViewController = _settingsViewController
      {
         navigationController?.presentViewController(settingsViewController, animated: true, completion: nil)
      }
   }
   
   // MARK: - Public
   func openSettingsForAlarm(alarm: Alarm)
   {
      _configurationController.configureWithAlarm(alarm)
      navigationController?.pushViewController(_configurationController, animated: true)
   }
   
   func showDetailsForAlarm(alarm: Alarm)
   {
      _alarmDetailViewController.configureWithAlarm(alarm, isFiring: false)
      navigationController?.pushViewController(_alarmDetailViewController, animated: true)
   }
   
   func reloadData()
   {
      collectionView.reloadData()
   }

   // MARK: - Private
   private func setupFlowLayoutItemSize()
   {
      let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      layout.itemSize = CGSizeMake(CGRectGetWidth(view.bounds), 50)
   }
   
   private func registerCollectionViewNibs()
   {
      collectionView.registerNib(UINib(nibName: "TimelineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "timelineCell")
      collectionView.registerNib(UINib(nibName: "TimelineHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
   }
   
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      navigationItem.backBarButtonItem = barButtonItem
   }
}

extension TimelineController: SettingsViewControllerDelegate
{
   func settingsWillClose()
   {
      reloadData()
   }
}
