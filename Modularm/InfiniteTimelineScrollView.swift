//
//  InfiniteScrollView.swift
//  CustomTimeSetter
//
//  Created by Gregory Klein on 5/27/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class InfiniteTimelineScrollView: UIScrollView
{
   private var timelineContainerView = UIView()
   private(set) var visibleTimelineViews = Array<TimelineView>()
   
   var timelineAttributes: TimelineViewAttributes = TimelineViewAttributes()
   private(set) var isResettingContentOffset = false
   
   // MARK: - Init
   required init(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)
      
      self.showsVerticalScrollIndicator = false
      self.showsHorizontalScrollIndicator = false
      self.bounces = false
      
      self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) * 4)
      self.timelineContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)
      self.timelineContainerView.userInteractionEnabled = false
      self.addSubview(self.timelineContainerView)
   }

   // MARK: - Layout
   override func layoutSubviews()
   {
      super.layoutSubviews()
      recenterIfNecessary()
      
      let minimumVisibleY = CGRectGetMinY(self.bounds)
      let maximumVisibleY = CGRectGetMaxY(self.bounds)
      self.tileTimelineViewsFromMinY(minimumVisibleY, toMaxY: maximumVisibleY)
   }
   
   private func recenterIfNecessary()
   {
      let contentHeight = self.contentSize.height
      let currentOffset = self.contentOffset
      
      let centerOffsetY: CGFloat = (contentHeight - CGRectGetHeight(self.bounds)) * 0.5
      let distanceFromCenter = abs(currentOffset.y - centerOffsetY)
      
      if distanceFromCenter >= contentHeight * 0.25
      {
         self.isResettingContentOffset = true
         self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY)
         
         for timelineView in self.visibleTimelineViews
         {
            var center = self.timelineContainerView.convertPoint(timelineView.center, toView: self)
            center.y += centerOffsetY - currentOffset.y
            timelineView.center = self.convertPoint(center, toView: self.timelineContainerView)
         }
         self.isResettingContentOffset = false
      }
   }
   
   // MARK: - Public
   func updateVisibleTimelineViewsDisplay()
   {
      for timelineView in self.visibleTimelineViews
      {
         timelineView.setNeedsDisplay()
      }
   }
}

// MARK: - Private Tiling Functions
extension InfiniteTimelineScrollView
{
   private func insertTimelineView() -> TimelineView
   {
      let heightMultiplier: CGFloat = self.timelineAttributes.interval == .Hour ? 2 : 3
      let timelineViewFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) * heightMultiplier)
      let timelineView = TimelineView(frame: timelineViewFrame, attributes: self.timelineAttributes)
      
      self.timelineContainerView.addSubview(timelineView)
      return timelineView
   }
   
   private func placeNewTimelineViewOnTop(topEdge: CGFloat) -> CGFloat
   {
      let timelineView = self.insertTimelineView()
      self.visibleTimelineViews.append(timelineView)
      
      var frame = timelineView.frame
      frame.origin.x = 0
      frame.origin.y = topEdge
      
      timelineView.frame = frame
      return CGRectGetMaxY(frame)
   }
   
   private func placeNewTimelineViewOnBottom(bottomEdge: CGFloat) -> CGFloat
   {
      let timelineView = self.insertTimelineView()
      self.visibleTimelineViews.insert(timelineView, atIndex: 0)
      
      var frame = timelineView.frame
      frame.origin.x = 0
      frame.origin.y = bottomEdge - CGRectGetHeight(frame)
      
      timelineView.frame = frame
      return CGRectGetMinY(frame)
   }
   
   private func tileTimelineViewsFromMinY(minY: CGFloat, toMaxY maxY: CGFloat)
   {
      // the upcoming tiling logic depends on there already being at least one timeline view in the visibleTimelineViews array, so
      // to kick off the tiling we need to make sure there's at least one timeline view
      if self.visibleTimelineViews.count == 0
      {
         self.placeNewTimelineViewOnTop(minY)
      }
      
      var lastTimelineView = self.visibleTimelineViews.last!
      var topEdge = CGRectGetMaxY(lastTimelineView.frame)
      while topEdge < maxY
      {
         topEdge = self.placeNewTimelineViewOnTop(topEdge)
      }
      
      var firstTimelineView = self.visibleTimelineViews[0]
      var bottomEdge = CGRectGetMinY(firstTimelineView.frame)
      while bottomEdge > minY
      {
         bottomEdge = self.placeNewTimelineViewOnBottom(bottomEdge)
      }
      
      lastTimelineView = self.visibleTimelineViews.last!
      while lastTimelineView.frame.origin.y > maxY
      {
         lastTimelineView.removeFromSuperview()
         self.visibleTimelineViews.removeLast()
         lastTimelineView = self.visibleTimelineViews.last!
      }
      
      firstTimelineView = self.visibleTimelineViews[0]
      while CGRectGetMaxY(firstTimelineView.frame) < minY
      {
         firstTimelineView.removeFromSuperview()
         self.visibleTimelineViews.removeAtIndex(0)
         firstTimelineView = self.visibleTimelineViews[0]
      }
   }
}
