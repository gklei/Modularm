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
      if let alarms = self.timelineController.alarms
      {
         let alarm = alarms[indexPath.row + 1]
         self.timelineController.openSettingsForAlarm(alarm)
      }
   }
}

extension TimelineCollectionViewDelegate: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
      if self.timelineController.alarms?.count > 0
      {
         return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 150)
      }
      return CGSizeZero
   }
}
