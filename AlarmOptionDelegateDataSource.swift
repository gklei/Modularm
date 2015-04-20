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
      return 0
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      return 1
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      return self.cellWithIndexPath(indexPath, identifier: "cell")
   }
}

extension AlarmOptionDelegateDataSource: UITableViewDelegate
{
}
