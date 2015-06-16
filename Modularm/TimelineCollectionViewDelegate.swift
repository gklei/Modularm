//
//  TimelineCollectionViewDelegate.swift
//  Modularm
//
//  Created by Klein, Greg on 5/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class TimelineCollectionViewDelegate: NSObject
{
   @IBOutlet weak var collectionView: UICollectionView!
   @IBOutlet weak var timelineController: TimelineController!
}

extension TimelineCollectionViewDelegate: UICollectionViewDelegate
{
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
   {
      if indexPath.section == 0
      {
         if let alarms = self.timelineController.activeAlarms
         {
            let alarm = alarms[indexPath.row + 1]
            self.timelineController.openSettingsForAlarm(alarm)
         }
      }
      else
      {
         if let alarms = self.timelineController.nonActiveAlarms
         {
            let alarm = alarms[indexPath.row]
            self.timelineController.openSettingsForAlarm(alarm)
         }
      }
   }
}

extension TimelineCollectionViewDelegate: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
      if self.timelineController.activeAlarms?.count > 0 && section == 0
      {
         return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 150)
      }
      return CGSizeZero
   }
   
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
   {
      var size = CGSizeZero
      if section != 0 || self.timelineController.nonActiveAlarms?.count == 0
      {
         var height: CGFloat = 70
         if let alarmCount = self.timelineController.alarms?.count
         {
            let contentHeight: CGFloat = (CGFloat(alarmCount) - 1.0) * 50.0 + 150.0
            height = max(CGRectGetHeight(collectionView.bounds) - contentHeight + 1, height)
         }
         size = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), height)
      }
      return size
   }
}
