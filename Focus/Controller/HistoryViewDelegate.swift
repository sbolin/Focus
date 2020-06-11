//
//  HistoryViewDelegate.swift
//  Focus
//
//  Created by Scott Bolin on 5/16/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class HistoryViewDelegate: NSObject, UITableViewDelegate {
  
  //MARK: - UITableViewDelegate Methods
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 36
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    if section == 0 {
//      let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistorySection0HeaderCell.reuseIdentifier) as! HistorySection0HeaderCell  //
//      view.historySection0Label.text = "Month"
//      return view
//    } else {
//      let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistoryFinalHeaderCell.reuseIdentifier) as! HistoryFinalHeaderCell //
//      view.historyFinalHeaderCellLabel.text = "Today"
//      return view
//    }
//  }
}

