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
      cell.label.textColor = UIColor.whiteColor()
   }
   
   func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath)
   {
      let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TimelineCollectionViewCell
      cell.backgroundColor = UIColor.whiteColor()
      cell.label.textColor = UIColor.blackColor()
   }
}
