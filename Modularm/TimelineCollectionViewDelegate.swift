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
         let alarm = alarms[indexPath.row]
         self.timelineController.openSettingsForAlarm(alarm)
      }
   }
   
   func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool
   {
      return true
   }
   
   func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath)
   {
      let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TimelineCollectionViewCell
      cell.backgroundColor = UIColor.lipstickRedColor()
   }
   
   func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath)
   {
      let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TimelineCollectionViewCell
      cell.backgroundColor = UIColor(white: 0.09, alpha: 1)
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
