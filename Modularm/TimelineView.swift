//
//  TimelineView.swift
//  CustomTimeSetter
//
//  Created by Gregory Klein on 5/30/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

let kNumberOfHours = 24
let kNumberOfMinutes = 60
let kXPadding: CGFloat = 28
let kIntermediateTickCount: CGFloat = 5.0

enum TimelineOrientation
{
   case Left, Right
}

enum TimelineInterval
{
   case Minute, Hour
}

enum TimelineMode
{
   case Military, Standard
}

struct TimelineTimeValue
{
   var value: Int
   var mode: TimelineMode
   var associatedLabel: UILabel
}

struct TimelineViewAttributes
{
   var orientation: TimelineOrientation = .Left
   var interval: TimelineInterval = .Hour
   var mode: TimelineMode = .Military
}

class TimelineView: UIView
{
   var timeValues = Array<TimelineTimeValue>()
   
   var orientation: TimelineOrientation = .Left
   var interval: TimelineInterval = .Hour
   var mode: TimelineMode = .Military
   
   var circleSize: CGFloat {
      return self.interval == .Hour ? 6.0 : 4.0
   }
   
   // MARK: - Init
   required init(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)
      self.opaque = false
   }

   override init(frame: CGRect)
   {
      super.init(frame: frame)
      self.opaque = false
   }
   
   convenience init(frame: CGRect, attributes: TimelineViewAttributes)
   {
      self.init(frame: frame, orientation: attributes.orientation, interval: attributes.interval, mode: attributes.mode)
   }
   
   private convenience init(frame: CGRect, orientation: TimelineOrientation, interval: TimelineInterval, mode: TimelineMode)
   {
      self.init(frame: frame)
      self.orientation = orientation
      self.interval = interval
      self.mode = mode
      
      self.setupLabelsWithInterval(interval, mode: mode)
      self.updateLabelFrames()
   }

   // MARK: - Private
   private func setupLabelsWithInterval(interval: TimelineInterval, mode: TimelineMode)
   {
      switch interval
      {
      case .Hour:
         self.setupHourLabelsWithMode(mode)
      case .Minute:
         self.setupMinuteLabels()
      }
   }
   
   private func setupHourLabelsWithMode(mode: TimelineMode)
   {
      switch mode
      {
      case .Military:
         for hour in 0...(kNumberOfHours - 1)
         {
            var hourText = hour <= 9 ? "0\(hour):00" : "\(hour):00"
            let hourLabel = UILabel.timeIntervalLabelWithText(hourText)
            
            self.addSubview(hourLabel)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: "labelTapped:")
            hourLabel.addGestureRecognizer(tapRecognizer)
            
            let timeValue = TimelineTimeValue(value: hour, mode: self.mode, associatedLabel: hourLabel)
            self.timeValues.append(timeValue)
         }
         break
      case .Standard:
         for hour in 0...(kNumberOfHours - 1)
         {
            var hourInt = (hour + 12) % 12
            hourInt = hourInt == 0 ? 12 : hourInt
            
            var hourText = hourInt <= 9 ? "0\(hourInt):00" : "\(hourInt):00"
            let hourLabel = UILabel.timeIntervalLabelWithText(hourText)
            
            self.addSubview(hourLabel)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: "labelTapped:")
            hourLabel.addGestureRecognizer(tapRecognizer)
            
            let timeValue = TimelineTimeValue(value: hour, mode: self.mode, associatedLabel: hourLabel)
            self.timeValues.append(timeValue)
         }
         break
      }
   }
   
   func labelTapped(recognizer: UIGestureRecognizer)
   {
   }
   
   private func setupMinuteLabels()
   {
      for minute in 0...(kNumberOfMinutes - 1)
      {
         var minuteText = minute <= 9 ? "0\(minute)" : "\(minute)"
         let minuteLabel = UILabel.timeIntervalLabelWithText(minuteText)
         
         self.addSubview(minuteLabel)
         
         let timeValue = TimelineTimeValue(value: minute, mode: self.mode, associatedLabel: minuteLabel)
         self.timeValues.append(timeValue)
      }
   }

   private func updateLabelFrames()
   {
      let numberOfLabels = self.timeValues.count
      let labelHeight = CGRectGetHeight(self.timeValues[0].associatedLabel.frame)
      var xPosition = kXPadding
      if self.orientation == .Right
      {
         let labelWidth = CGRectGetWidth(self.timeValues[0].associatedLabel.frame)
         xPosition = CGRectGetWidth(self.bounds) - labelWidth - kXPadding
      }
      
      let padding = (CGRectGetHeight(self.bounds) - (labelHeight * CGFloat(numberOfLabels))) / (CGFloat(numberOfLabels)) + labelHeight

      var hourLabelPosition = CGPointMake(xPosition, padding * 0.5)
      for timeValue in self.timeValues
      {
         timeValue.associatedLabel.frame.origin = hourLabelPosition
         hourLabelPosition.y += padding
      }
   }
   
   // MARK: - Public
   func timeValueClosestToGlobalMarkerRect(rect: CGRect) -> TimelineTimeValue
   {
      let globalYPosition = CGRectGetMidY(rect)
      var closestValue = self.timeValues[0]
      let firstTimeLabelCenterY = self.convertPoint(closestValue.associatedLabel.center, toView: nil).y
      var currentDifference = abs(globalYPosition - firstTimeLabelCenterY)
      
      for timeValue in self.timeValues
      {
         let timeLabel = timeValue.associatedLabel
         let timeLabelCenterY = self.convertPoint(timeLabel.center, toView: nil).y
         let timeLabelDifference = abs(timeLabelCenterY - globalYPosition)
         if timeLabelDifference < currentDifference
         {
            closestValue = timeValue
            currentDifference = timeLabelDifference
         }
      }
      
      return closestValue
   }
   
   func timeValueUnderGlobalPoint(point: CGPoint) -> TimelineTimeValue?
   {
      var timeValueFound: TimelineTimeValue?
      for timeValue in self.timeValues
      {
         let timeLabel = timeValue.associatedLabel
         var timeLabelGlobalRect = self.convertRect(timeLabel.frame, toView: nil)
         
         var insetYAmount: CGFloat = self.interval == .Minute ? -5 : -15
         timeLabelGlobalRect.inset(dx: -10, dy: insetYAmount)
         if timeLabelGlobalRect.contains(point)
         {
            timeValueFound = timeValue
            break
         }
      }

      return timeValueFound
   }
   
   func makeTimesVisible()
   {
      for timeValue in self.timeValues
      {
         timeValue.associatedLabel.hidden = false
      }
   }
}

// MARK: - Drawing
extension TimelineView
{
   override func drawRect(rect: CGRect)
   {
      UIColor.darkGrayColor().set()
      
      for labelIndex in 0...(self.timeValues.count - 1)
      {
         let label = self.timeValues[labelIndex].associatedLabel
         
         var circleFrameX: CGFloat = CGRectGetMinX(label.frame) * 0.5 - (self.circleSize * 0.5)
         if self.orientation == .Right
         {
            circleFrameX = CGRectGetMaxX(label.frame) + ((CGRectGetWidth(self.bounds) - CGRectGetMaxX(label.frame)) * 0.5 - (self.circleSize * 0.5))
         }
         
         let circleFrame = CGRectMake(circleFrameX, label.center.y - self.circleSize * 0.5, self.circleSize, self.circleSize)
         
         let circlePath = UIBezierPath(roundedRect: circleFrame, cornerRadius: self.circleSize * 0.5)
         if !label.hidden {
            circlePath.fill()
         }
         
         let dashPath = UIBezierPath()
         if labelIndex != (self.timeValues.count - 1)
         {
            let verticalPadding: CGFloat = (self.timeValues[labelIndex + 1].associatedLabel.center.y - label.center.y) / (kIntermediateTickCount + 1)
            var dashPoint = CGPointMake(circleFrameX, label.center.y + verticalPadding)
            
            for _ in 0...5
            {
               dashPath.moveToPoint(dashPoint)
               dashPath.addLineToPoint(CGPointMake(circleFrameX + self.circleSize, dashPoint.y))
               dashPoint.y += verticalPadding
            }
            
            // account for first label
            if labelIndex == 0
            {
               dashPoint = CGPointMake(circleFrameX, label.center.y - verticalPadding)
               for _ in 0...3
               {
                  dashPath.moveToPoint(dashPoint)
                  dashPath.addLineToPoint(CGPointMake(circleFrameX + self.circleSize, dashPoint.y))
                  dashPoint.y -= verticalPadding
               }
            }
         }
         else // account for last label
         {
            let verticalPadding: CGFloat = (label.center.y - self.timeValues[labelIndex - 1].associatedLabel.center.y) / (kIntermediateTickCount + 1)
            var dashPoint = CGPointMake(circleFrameX, label.center.y + verticalPadding)
            
            for _ in 0...2
            {
               dashPath.moveToPoint(dashPoint)
               dashPath.addLineToPoint(CGPointMake(circleFrameX + self.circleSize, dashPoint.y))
               dashPoint.y += verticalPadding
            }
         }
         dashPath.stroke()
      }
      
      super.drawRect(rect)
   }
}
