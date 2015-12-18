//
//  AlarmHistoryController.swift
//  Modularm
//
//  Created by Gregory Klein on 4/10/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

extension Array {
   var randomItem: Element {
      let index = Int(arc4random_uniform(UInt32(self.count)))
      return self[index]
   }
   
   var randomIndex: Int {
      return Int(arc4random_uniform(UInt32(self.count)))
   }
}

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
   
   private let _randomTitleList = [
      "🤘","🤔","😶","🙃","😮","😐","😛","😑","👌",
      "🤕","🤑","🐱","🐶","🐯","🐼","🐤", "🌝", "🌞",
      "🌛","🌜","⛄️","☃️","🎃","🔥","👾","🔔"
   ]
   
   private var _previousTitleIndex = 0
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationController?.makeNavigationBarTransparent()
      
      registerCollectionViewNibs()
      setupFlowLayoutItemSize()
      
      NSNotificationCenter.defaultCenter().addObserverForName(kModularmWillEnterForegroundNotification, object: nil, queue: nil) { (notification) -> Void in
         
         AlarmManager.deactivateAlarmsThatAreInThePast()
         self.reloadData()
      }
      
      collectionView.emptyDataSetSource = self
      collectionView.emptyDataSetDelegate = self
   }

   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(false, animated: true);
      
      AlarmManager.removeIncompleteAlarms()
      AlarmManager.deactivateAlarmsThatAreInThePast()
      reloadData()
      
      UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
      
      var newIndex = _randomTitleList.randomIndex
      while (newIndex == _previousTitleIndex) {
         newIndex = _randomTitleList.randomIndex
      }
      _previousTitleIndex = newIndex
      navigationItem.title = _randomTitleList[newIndex]
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
         _configurationController.configureWithNewAlarm(alarm)
         navigationController?.pushViewController(_configurationController, animated: true)
      }
   }
   
   @IBAction func settingsButtonPressed()
   {
      navigationController?.presentViewController(_settingsViewController, animated: true, completion: nil)
      
      // For debugging
//      clearAllAlarms()
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

extension TimelineController: DZNEmptyDataSetSource
{
   func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
   {
      let text = "You have no reminders."
      let attribs = [
         NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 22)!,
         NSForegroundColorAttributeName: UIColor.darkGrayColor()
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
   
   func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
   {
      let text = "Schedule reminders to keep track of your day. Add a reminder by tapping the + button."
      
      let para = NSMutableParagraphStyle()
      para.lineBreakMode = NSLineBreakMode.ByWordWrapping
      para.alignment = NSTextAlignment.Center
      
      let attribs = [
         NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 16)!,
         NSForegroundColorAttributeName: UIColor.lightGrayColor(),
         NSParagraphStyleAttributeName: para
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
   
   func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString!
   {
      let text = "Create a reminder"
      let attribs = [
         NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!,
         NSForegroundColorAttributeName: state == .Normal ? UIColor.lipstickRedColor() : UIColor.lipstickRedColor().colorWithAlphaComponent(0.6)
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
}

extension TimelineController: DZNEmptyDataSetDelegate
{
   func emptyDataSetDidTapButton(scrollView: UIScrollView!)
   {
      addNewAlarmButtonPressed()
   }
}
