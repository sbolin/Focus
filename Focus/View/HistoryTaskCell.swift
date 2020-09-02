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
  var dateText = DateFormatter()
  
  //MARK: - IBOutlets
  @IBOutlet weak var historyTask: UITextField!
  @IBOutlet weak var historyTaskCompleted: UIButton!
  @IBOutlet weak var dateCreated: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureHistoryTaskCell(at indexPath: IndexPath, for todo: ToDo) {
    dateText.dateFormat = "dd MMM yy"
    historyTask.text = todo.todo
    dateCreated.text = dateText.string(from: todo.todoDateCreated)  
    historyTaskCompleted.isSelected =  todo.todoCompleted
    toggleButtonColor()
  }
  
  func toggleButtonColor() {
    historyTaskCompleted.isSelected ? (historyTaskCompleted.tintColor = .systemOrange) :
      (historyTaskCompleted.tintColor = .systemGray6)
  }
}
