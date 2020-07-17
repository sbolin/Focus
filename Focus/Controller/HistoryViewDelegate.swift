//
//  HistoryViewDelegate.swift
//  Focus
//
//  Created by Scott Bolin on 5/16/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol HistorySection0HeaderDelegate {
  func configureHistorySection0HeaderView(at section: Int, _ view: HistorySection0HeaderView, headerLabel: String?)
}

class HistoryViewDelegate: NSObject, UITableViewDelegate {
  
  var delegate: HistorySection0HeaderDelegate?
  
  //MARK: - UITableViewDelegate Methods
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let row = indexPath.row
    if row == 0 || (row - 1) % 4 == 0 {
      return 60
    } else {
      return 48
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistorySection0HeaderView.reuseIdentifier) as! HistorySection0HeaderView
    let headerLabel = CoreDataController.shared.fetchedToDoByMonthController.sections?[section].name
    delegate?.configureHistorySection0HeaderView(at: section, headerView, headerLabel: headerLabel)
    return headerView
    /*
    let view = UITableViewHeaderFooterView()
    view.textLabel?.textColor = UIColor.systemOrange
    view.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    view.textLabel?.frame = view.frame
    view.textLabel?.textAlignment = .center
    view.textLabel?.text = CoreDataController.shared.fetchedToDoByMonthController.sections?[section].name
    return view
    */
    
  }
}

