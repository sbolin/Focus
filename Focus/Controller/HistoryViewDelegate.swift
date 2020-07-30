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
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let row = indexPath.row
    if row == 0 {
      return 45
    } else if (row - 1) % 4 == 0 {
      return 50
    } else {
      return 44
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    let view = UITableViewHeaderFooterView()
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.tintColor = .systemOrange
    button.tag = section
    button.addTarget(self, action: #selector(toggleSection), for: .touchUpInside)

    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor.systemOrange
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.textAlignment = .center
    label.text = CoreDataController.shared.fetchedToDoByMonthController.sections?[section].name
    
    
    view.addSubview(button)
    button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    view.addSubview(label)
    label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    return view
  }
  
  @objc func toggleSection(sender: UIButton) {
    let section = sender.tag
    let senderView = sender.superview!
    let tableView = senderView.superview as! UITableView
    
    for (index, _) in CoreDataController.shared.fetchedToDoByMonthController.sections!.enumerated() {
      if section == index {
        CoreDataController.shared.sectionExpanded[index] = !CoreDataController.shared.sectionExpanded[index]
        tableView.reloadSections(NSIndexSet(index: index) as IndexSet, with: .automatic)
      }
    }
  }
}

