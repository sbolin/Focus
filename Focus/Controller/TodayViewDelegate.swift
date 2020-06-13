//
//  TodayViewDelegate.swift
//  Focus
//
//  Created by Scott Bolin on 5/16/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class TodayViewDelegate: NSObject, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 90
    } else {
      return 48
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
//    if section == 0 {
//    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TodaySection0HeaderCell.reuseIdentifier) as! TodaySection0HeaderCell
//      view.todaySection0Label.text = "Goal for the day to focus on:"
//      return view
//    } else {
//      let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TodaySection1HeaderCell.reuseIdentifier) as! TodaySection1HeaderCell
//      view.todaySection1Label.text = "3 tasks to achieve your goal:"
//         return view
//    }
//  }
}
