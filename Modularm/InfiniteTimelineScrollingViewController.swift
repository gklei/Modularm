//
//  InfiniteTimelineScrollingViewController.swift
//  CustomTimeSetter
//
//  Created by Klein, Greg on 5/31/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

protocol InfiniteTimelineScrollingViewControllerDelegate
{
   func infiniteScrollViewWasTapped(scrollView: InfiniteTimelineScrollView, atGlobalLocation location: CGPoint)
   func infiniteScrollViewWillBeginDragging(scrollView: InfiniteTimelineScrollView)
   func infiniteScrollViewDidScroll(scrollView: InfiniteTimelineScrollView)
}

class InfiniteTimelineScrollingViewController: UIViewController
{
   @IBOutlet weak var infiniteScrollView: InfiniteTimelineScrollView!
   @IBOutlet weak var gradientContainerView: UIView!

   var globalMarkerRect = CGRectZero
   var timelineAttributes = TimelineViewAttributes()
   var infiniteScrollViewDelegate: InfiniteTimelineScrollingViewControllerDelegate? = nil
   var currentTimeValue: TimelineTimeValue?
   var gradientLayer = CAGradientLayer()
   var closestTimeValue: TimelineTimeValue? {
      get {
         return self.closestTimeValueUnderGlobalRect(self.globalMarkerRect)
      }
   }
   
   override func viewDidLoad()
   {
      super.viewDidLoad()

      self.setupInfiniteScrollView()
      self.setupGradientLayer()
      
      let tapRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
      self.view.addGestureRecognizer(tapRecognizer)
   }

   override func viewDidLayoutSubviews()
   {
      super.viewDidLayoutSubviews()
      self.gradientLayer.frame = self.gradientContainerView.bounds
   }

   private func setupInfiniteScrollView()
   {
      self.infiniteScrollView.timelineAttributes = self.timelineAttributes
      self.infiniteScrollView.delegate = self
   }

   private func setupGradientLayer()
   {
      let firstColor = UIColor.clearColor().CGColor
      let secondColor = UIColor(white: 0, alpha: 0.75).CGColor
      self.gradientLayer.colors = [firstColor, secondColor]
      self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
      self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

      self.gradientContainerView.layer.insertSublayer(self.gradientLayer, atIndex: 0)
   }
   
   func viewTapped(recognizer: UIGestureRecognizer)
   {
      let globalPoint = recognizer.locationInView(nil)
      if let timeValue = self.timeValueUnderGlobalPoint(globalPoint)
      {
         UIView.animateWithDuration(0.15, animations: { () -> Void in
            
            timeValue.associatedLabel.transform = CGAffineTransformMakeScale(1.7, 1.7);
            }, completion: { (finished: Bool) -> Void in
               
               UIView.animateWithDuration(0.15, animations: { () -> Void in
                  
                  timeValue.associatedLabel.transform = CGAffineTransformIdentity
                  }, completion: { (finished: Bool) -> Void in
                     
                     self.scrollNumber(timeValue.value, underGlobalMarkerRect: self.globalMarkerRect, animated: true)
               })
         })
      }
      self.infiniteScrollViewDelegate?.infiniteScrollViewWasTapped(self.infiniteScrollView, atGlobalLocation: globalPoint)
   }
   
   func killScroll()
   {
      let offset = self.infiniteScrollView.contentOffset;
      self.infiniteScrollView.setContentOffset(offset, animated: false)
   }
   
   func scrollToNumber(number: Int, animated: Bool)
   {
      self.scrollNumber(number, underGlobalMarkerRect: self.globalMarkerRect, animated: animated)
   }

   func scrollNumber(number: Int, underGlobalMarkerRect rect: CGRect, animated: Bool)
   {
      var possibleTimeValue: TimelineTimeValue?
      for timelineView in self.infiniteScrollView.visibleTimelineViews
      {
         for timeValue in timelineView.timeValues
         {
            let globalLabelFrame = timelineView.convertRect(timeValue.associatedLabel.frame, toView: self.infiniteScrollView)
            if timeValue.value == number
            {
               possibleTimeValue = timeValue
               possibleTimeValue?.associatedLabel = timeValue.associatedLabel
               
               if self.infiniteScrollView.bounds.contains(globalLabelFrame)
               {
                  self.currentTimeValue = timeValue
                  self.scrollLabel(timeValue.associatedLabel, underMarkerRect: rect, animated: animated)
                  possibleTimeValue = nil
                  break
               }
            }
         }
      }
      
      if possibleTimeValue != nil
      {
         self.scrollLabel(possibleTimeValue!.associatedLabel, underMarkerRect: rect, animated: animated)
      }
   }
   
   func closestTimeValueUnderGlobalRect(rect: CGRect) -> TimelineTimeValue?
   {
      var closestTimeValues = Array<TimelineTimeValue>()
      for timelineView in self.infiniteScrollView.visibleTimelineViews
      {
         let closestTimeValue = timelineView.timeValueClosestToGlobalMarkerRect(rect)
         closestTimeValues.append(closestTimeValue)
      }
      
      var returnTimeValue: TimelineTimeValue?
      if closestTimeValues.count > 0 && !self.infiniteScrollView.isResettingContentOffset
      {
         let globalYPosition = CGRectGetMidY(rect)
         var closestTimeValue = closestTimeValues[0]
         
         let label = closestTimeValue.associatedLabel
         let firstTimeLabelCenterY = label.superview!.convertPoint(label.center, toView: nil).y
         var currentDifference = abs(globalYPosition - firstTimeLabelCenterY)
         
         for timeValue in closestTimeValues
         {
            let label = timeValue.associatedLabel
            let timeLabelCenterY = label.superview!.convertPoint(label.center, toView: nil).y
            let timeLabelDifference = abs(timeLabelCenterY - globalYPosition)
            if timeLabelDifference < currentDifference
            {
               closestTimeValue = timeValue
               currentDifference = timeLabelDifference
            }
         }
         returnTimeValue = closestTimeValue
      }
      return returnTimeValue
   }
   
   func timeValueUnderGlobalPoint(point: CGPoint) ->TimelineTimeValue?
   {
      var timeValue: TimelineTimeValue?
      for timelineView in self.infiniteScrollView.visibleTimelineViews
      {
         if let value = timelineView.timeValueUnderGlobalPoint(point)
         {
            timeValue = value
            break
         }
      }
      return timeValue
   }
   
   func updateAndHideCurrentTimeValue(timeValue: TimelineTimeValue)
   {
      self.currentTimeValue = timeValue
      for timelineView in self.infiniteScrollView.visibleTimelineViews
      {
         timelineView.makeTimesVisible()
      }
      self.currentTimeValue?.associatedLabel.hidden = true
   }
   
   func snapClosestTimeAniated(animated: Bool)
   {
      self.snapClosestTimeToGlobalMarkerRect(self.globalMarkerRect, animated: animated)
   }
   
   private func snapClosestTimeToGlobalMarkerRect(rect: CGRect, animated: Bool)
   {
      if let closestTimeValue = self.currentTimeValue
      {
         self.scrollLabel(closestTimeValue.associatedLabel, underMarkerRect: rect, animated: animated)
      }
   }

   private func scrollLabel(label: UILabel, underMarkerRect rect: CGRect, animated: Bool)
   {
      let globalCenter = label.superview!.convertPoint(label.center, toView: nil)
      let offset = CGRectGetMidY(rect) - globalCenter.y

      let contentOffset = self.infiniteScrollView.contentOffset
      self.infiniteScrollView.setContentOffset(CGPointMake(contentOffset.x, contentOffset.y - offset), animated: animated)
      self.infiniteScrollView.updateVisibleTimelineViewsDisplay()
   }
}

extension InfiniteTimelineScrollingViewController: UIScrollViewDelegate
{
   func scrollViewWillBeginDragging(scrollView: UIScrollView)
   {
      self.infiniteScrollViewDelegate?.infiniteScrollViewWillBeginDragging(self.infiniteScrollView)
   }
   
   func scrollViewDidScroll(scrollView: UIScrollView)
   {
      self.infiniteScrollViewDelegate?.infiniteScrollViewDidScroll(self.infiniteScrollView)
   }
   
   func scrollViewDidEndDecelerating(scrollView: UIScrollView)
   {
      self.snapScrollViewToClosestTime(true)
   }
   
   func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
   {
      if !decelerate {
         self.snapScrollViewToClosestTime(true)
      }
   }
   
   private func snapScrollViewToClosestTime(animated: Bool)
   {
      self.snapClosestTimeToGlobalMarkerRect(self.globalMarkerRect, animated: animated)
   }
}
