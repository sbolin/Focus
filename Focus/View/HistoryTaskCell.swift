//
//  HistoryTaskCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class HistoryTaskCell: UITableViewCell {
  
  //MARK: - Properties
  public static let reuseIdentifier = "HistoryTaskCell"
  
  //MARK: - IBOutlets
  @IBOutlet weak var historyTask: UITextField!
  @IBOutlet weak var historyTaskCompleted: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()

  }
  
  func configureHistoryTaskCell(at indexPath: IndexPath, for todo: ToDo) {
    historyTask.text = "\(todo.todo) + \(indexPath.section) + \(indexPath.row)"
//    historyTask.text = todo.todo
    historyTaskCompleted.isSelected = todo.todoCompleted
    toggleButtonColor()
  }
  
  func toggleButtonColor() {
    historyTaskCompleted.isSelected ? (historyTaskCompleted.tintColor = .systemOrange) :
      (historyTaskCompleted.tintColor = .systemGray6)
  }
  
}
