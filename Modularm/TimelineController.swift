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
   @IBOutlet var collectionView: UICollectionView!
   
   lazy private var _settingsViewController: SettingsViewController = {
      return SettingsViewController(delegate: self)
   }()
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
      navigationController?.makeNavigationBarTransparent()
//      navigationController?.setNavigationBarHairlineHidden(true)
      
      registerCollectionViewNibs()
      setupFlowLayoutItemSize()
      
      NSNotificationCenter.defaultCenter().addObserverForName(kModularmWillEnterForegroundNotification, object: nil, queue: nil) { (notification) -> Void in
         AlarmManager.deactivateAlarmsThatAreInThePast()
         self.reloadData()
      }
   }

   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(false, animated: true);
      
      AlarmManager.removeIncompleteAlarms()
      AlarmManager.deactivateAlarmsThatAreInThePast()
      reloadData()
   }

   override func viewWillDisappear(animated: Bool)
   {
      updateBackBarButtonItemWithTitle("Back")
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
   
   @IBAction func settingsButtonPressed()
   {
      navigationController?.presentViewController(_settingsViewController, animated: true, completion: nil)
      
      // For debugging
      UIApplication.printAllAlarmsToConsole()
   }
   
   @IBAction func clearAllAlarms()
   {
      UIApplication.sharedApplication().cancelAllLocalNotifications()
   }
   
   // MARK: - Public
   func openSettingsForAlarm(alarm: Alarm)
   {
      _configurationController.configureWithAlarm(alarm)
      navigationController?.pushViewController(_configurationController, animated: true)
   }
   
   func showDetailsForAlarm(alarm: Alarm)
   {
      _alarmDetailViewController.configureWithAlarm(alarm, isFiring: false, displayMode: AppSettingsManager.displayMode)
      navigationController?.pushViewController(_alarmDetailViewController, animated: true)
   }
   
   func reloadData()
   {
      collectionView.reloadData()
   }

   // MARK: - Private
   private func setupFlowLayoutItemSize()
   {
      let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      collectionViewLayout.itemSize = CGSizeMake(CGRectGetWidth(view.bounds), 50)
   }
   
   private func registerCollectionViewNibs()
   {
      collectionView.registerNib(UINib(nibName: "TimelineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "timelineCell")
      collectionView.registerNib(UINib(nibName: "TimelineHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
   }
   
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let updatedButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      navigationItem.backBarButtonItem = updatedButtonItem
   }
}

extension TimelineController: SettingsViewControllerDelegate
{
   func settingsWillClose()
   {
      reloadData()
   }
}
