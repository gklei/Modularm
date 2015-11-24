//
//  DigitalTimeView.swift
//  Modularm
//
//  Created by Klein, Greg on 6/30/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class DigitalTimeView: TimeView
{
   private let _hourLabel = UILabel.largeTimeDisplayLabelWithAlignment(.Left)
   private let _colonLabel = UILabel.largeTimeDisplayLabelWithAlignment(.Center)
   private let _minuteLabel = UILabel.largeTimeDisplayLabelWithAlignment(.Right)
   private let _amOrPmLabel = UILabel.amOrPmLabel()
   
   private var _labels: [UILabel] {
      return [_hourLabel, _colonLabel, _minuteLabel, _amOrPmLabel]
   }
   
   // MARK: - Init
   required init?(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)
      setupLabels()
   }
   
   override init(frame: CGRect)
   {
      super.init(frame: frame)
      setupLabels()
   }
   
   // MARK: - Setup
   private func setupLabels()
   {
      _hourLabel.text = "12"
      _hourLabel.sizeToFit()
      addSubview(_hourLabel)
      
      _colonLabel.text = ":"
      _colonLabel.sizeToFit()
      addSubview(_colonLabel)
      
      _minuteLabel.text = "12"
      _minuteLabel.sizeToFit()
      addSubview(_minuteLabel)
      
      _amOrPmLabel.text = "am"
      _amOrPmLabel.sizeToFit()
      addSubview(_amOrPmLabel)

      // For Debugging:
//      for label in _labels {
//         label.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.6)
//      }
   }
   
   // MARK: - Lifecycle
   override func layoutSubviews()
   {
      super.layoutSubviews()
      
      _colonLabel.center = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
      
      let hourLabelWidth = _hourLabel.bounds.width
      let hourLabelX: CGFloat = CGRectGetMinX(_colonLabel.frame) - hourLabelWidth - 8.0
      let hourLabelY: CGFloat = _colonLabel.center.y - _hourLabel.bounds.height * 0.5
      
      _hourLabel.frame.origin = CGPoint(x: hourLabelX, y: hourLabelY)
      
      let minuteLabelX = CGRectGetMaxX(_colonLabel.frame)
      let minuteLabelY = _colonLabel.center.y - _minuteLabel.bounds.height * 0.5
      
      _minuteLabel.frame.origin = CGPoint(x: minuteLabelX, y: minuteLabelY)
      
      let amPmLabelX = _minuteLabel.frame.maxX + 6
      let amPmLabelY = _minuteLabel.frame.minY + 14
      
      _amOrPmLabel.frame.origin = CGPoint(x: amPmLabelX, y: amPmLabelY)
      
      let leftSpacing = _hourLabel.frame.minX
      if leftSpacing > 0 {
         for label in _labels {
            label.frame.origin = CGPoint(x: label.frame.minX - leftSpacing, y: label.frame.minY)
         }
      }
   }
   
   // MARK: - Public
   override func updateTimeWithAlarm(alarm: Alarm)
   {
      super.updateTimeWithAlarm(alarm)
      
      let date = alarm.fireDate
      _hourLabel.text = TimeDisplayProvider.textForHourValue(date.hour)
      _minuteLabel.text = TimeDisplayProvider.textForMinuteValue(date.minute)
      _amOrPmLabel.text = date.hour < 12 ? "am" : "pm"
      _amOrPmLabel.sizeToFit()
   }
   
   override func updateTimeWithHour(hour: Int, minute: Int)
   {
      super.updateTimeWithHour(hour, minute: minute)
      
      _hourLabel.text = TimeDisplayProvider.textForHourValue(hour)
      _minuteLabel.text = TimeDisplayProvider.textForMinuteValue(minute)
      _amOrPmLabel.text = hour < 12 ? "am" : "pm"
      _amOrPmLabel.sizeToFit()
   }
   
   override func updateColor(color: UIColor)
   {
      for label in _labels {
         label.textColor = color
      }
   }
}
