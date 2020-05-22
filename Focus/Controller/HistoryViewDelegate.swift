//
//  HistoryViewDelegate.swift
//  Focus
//
//  Created by Scott Bolin on 5/16/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class HistoryViewDelegate: NSObject, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    if section == 0 {
      let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistorySection0HeaderCell.reuseIdentifier) as! HistorySection0HeaderCell
      view.historySection0Label.text = "Month"
      return view
    } else {
      let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistoryFinalHeaderCell.reuseIdentifier) as! HistoryFinalHeaderCell
      view.historyFinalHeaderCellLabel.text = "Today"
      return view
    }
  }
}

