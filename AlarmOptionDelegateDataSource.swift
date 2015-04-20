//
//  AlarmOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmOptionDelegateDataSource: NSObject
{
   internal var cellLabelDictionary: [Int : Array<String>]? = nil
   internal var tableView: UITableView
   
   init(tableView: UITableView)
   {
      self.tableView = tableView
      super.init()
      
      tableView.dataSource = self
      tableView.delegate = self
   }
   
   func cellWithIndexPath(indexPath: NSIndexPath, identifier: String) -> UITableViewCell
   {
      let cell = self.tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
      var titleAttrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 19)!]
      let cellLabel = self.cellLabelDictionary?[indexPath.section]![indexPath.row]
      
      cell.selectionStyle = .None
      if let label = cellLabel
      {
         cell.textLabel?.attributedText = NSAttributedString(string: label, attributes: titleAttrs);
      }
      
      return cell
   }
}

extension AlarmOptionDelegateDataSource: UITableViewDataSource
{
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      var numberOfRows = 0
      if let dictionary = self.cellLabelDictionary
      {
         let labelArray = dictionary[section] as Array<String>?
         numberOfRows = labelArray!.count
      }
      return numberOfRows
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      var numberOfSections = 0
      if let dictionary = self.cellLabelDictionary
      {
         numberOfSections = dictionary.count
      }
      return numberOfSections
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      return self.cellWithIndexPath(indexPath, identifier: "cell")
   }
}

extension AlarmOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
   {
      return 50.0
   }
   
   func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
   {
      let view = UIView()
      view.backgroundColor = UIColor.normalOptionButtonColor()
      
      if section == self.numberOfSectionsInTableView(tableView) - 1
      {
         let cancelButton = UIButton.cancelButtonWithTitle("cancel")
         cancelButton.center = CGPointMake(CGRectGetWidth(cancelButton.frame)*0.5 + 16, 25)
         view.addSubview(cancelButton)
      }
      return view
   }
}
