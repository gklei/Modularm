//
//  TimelineCollectionViewDelegate.swift
//  Modularm
//
//  Created by Klein, Greg on 5/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

let kAnalogHeaderHeight: CGFloat = 362.0
let kDigitalHeaderHeight: CGFloat = 180.0

class TimelineCollectionViewDelegate: NSObject
{
   @IBOutlet weak var collectionView: UICollectionView!
   @IBOutlet weak var timelineController: TimelineController!
}

extension TimelineCollectionViewDelegate: UICollectionViewDelegate
{
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
   {
      if indexPath.section == 0 && AlarmManager.activeAlarms.count > 0
      {
         let alarm = AlarmManager.activeAlarms[indexPath.row + 1]
         self.timelineController.showDetailsForAlarm(alarm)
      }
      else
      {
         let alarm = AlarmManager.nonActiveAlarms[indexPath.row]
         self.timelineController.showDetailsForAlarm(alarm)
      }
   }
}

extension TimelineCollectionViewDelegate: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
      if AlarmManager.activeAlarms.count > 0 && section == 0
      {
         let height: CGFloat = AppSettingsManager.displayMode == .Analog ? kAnalogHeaderHeight : kDigitalHeaderHeight
         return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), height)
      }
      return CGSizeZero
   }
   
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
   {
      var size = CGSizeZero
      if section != 0 || AlarmManager.nonActiveAlarms.count == 0 || (section == 0 && AlarmManager.activeAlarms.count == 0)
      {
         var height: CGFloat = 70
         if let alarmCount = AlarmManager.alarms?.count, flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
         {
            let cellHeight = flowLayout.itemSize.height
            let headerHeight: CGFloat = AppSettingsManager.displayMode == .Analog ? kAnalogHeaderHeight : kDigitalHeaderHeight
            var contentHeight: CGFloat = (CGFloat(alarmCount) - 1.0) * cellHeight + headerHeight
            
            if AlarmManager.activeAlarms.count == 0 {
               contentHeight = CGFloat(alarmCount) * cellHeight
            }
            height = max(CGRectGetHeight(collectionView.bounds) - contentHeight + 1, height)
         }
         size = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), height)
      }
      if AlarmManager.alarms?.count == 0
      {
         size = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds))
      }
      return size
   }
}

extension TimelineCollectionViewDelegate: UIScrollViewDelegate
{
   func scrollViewDidScroll(scrollView: UIScrollView)
   {
      var backgroundColor = UIColor(white: 0.94, alpha: 1)
      if scrollView.contentOffset.y < 0 {
         backgroundColor = UIColor.clearColor()
      }
      collectionView.backgroundColor = backgroundColor
   }
}
