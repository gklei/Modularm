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
   
   lazy private var configurationController: AlarmConfigurationController = {
      return UIStoryboard.controllerWithIdentifier("AlarmConfigurationController") as! AlarmConfigurationController
   }()
   lazy private var alarmDetailViewController: AlarmDetailViewController = {
      return UIStoryboard.controllerWithIdentifier("AlarmDetailViewController") as! AlarmDetailViewController
   }()

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      self.timelineDataSource.removeIncompleteAlarms()
      self.navigationController?.navigationBar.makeTransparent()
      
      self.registerCollectionViewNibs()
      self.setupFlowLayoutItemSize()
   }

   override func viewWillAppear(animated: Bool)
   {
      self.navigationController?.setNavigationBarHidden(false, animated: true);
      self.timelineDataSource.removeIncompleteAlarms()
      self.updateFlowLayoutHeaderSize()
   }

   override func viewWillDisappear(animated: Bool)
   {
      self.updateBackBarButtonItemWithTitle("Back")
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
         self.configurationController.configureWithAlarm(alarm)
         self.navigationController?.pushViewController(self.configurationController, animated: true)
      }
   }
   
   @IBAction func logCurrentScheduledNotifications()
   {
      AlarmScheduler.logCurrentScheduledNotifications()
   }
   
   @IBAction func settingsButtonPressed()
   {
      let settingsViewController = SettingsViewController()
      self.navigationController?.presentViewController(settingsViewController, animated: true, completion: nil)
   }
   
   // MARK: - Public
   func openSettingsForAlarm(alarm: Alarm)
   {
      self.configurationController.configureWithAlarm(alarm)
      self.navigationController?.pushViewController(self.configurationController, animated: true)
   }
   
   func showDetailsForAlarm(alarm: Alarm)
   {
      self.alarmDetailViewController.configureWithAlarm(alarm, isFiring: false)
      self.navigationController?.pushViewController(self.alarmDetailViewController, animated: true)
   }
   
   func reloadData()
   {
      self.collectionView.reloadData()
   }

   // MARK: - Private
   private func setupFlowLayoutItemSize()
   {
      let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 50)
   }
   
   private func registerCollectionViewNibs()
   {
      self.collectionView.registerNib(UINib(nibName: "TimelineHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
      
      self.collectionView.registerNib(UINib(nibName: "TimelineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "timelineCell")
   }
   
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      self.navigationItem.backBarButtonItem = barButtonItem
   }
   
   private func updateFlowLayoutHeaderSize()
   {
      let headerSize = AlarmManager.alarms?.count > 0 ? CGSizeMake(view.bounds.width, 150) : CGSizeZero
      let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      flowLayout.headerReferenceSize = headerSize
   }
}
