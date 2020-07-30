//
//  TodayToDoCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol TodayTaskCellDelegate {
  func todayToDoUpdated( _ cell: TodayToDoCell, toDoUpdated newToDo: String)
  func todayTaskCompletion(_ cell: TodayToDoCell, completionChanged completion: Bool)
}

class TodayToDoCell: UITableViewCell, UITextFieldDelegate {
  
  //MARK: - Properties
  public static let reuseIdentifier = "TodayTaskCell"
  var delegate: TodayTaskCellDelegate?
  var oldText: String = ""
  var newText: String = ""
  var todoExisted: Bool = false
  
  //MARK: - IBOutlets
  @IBOutlet weak var todayTask: UITextField!
  @IBOutlet weak var todayTaskNumber: UIImageView!
  @IBOutlet weak var todayTaskCompleted: UIButton!
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    todayTask.delegate = self
  }
  
  //MARK: - Configuration
  func configureTodayTaskCell(at indexPath: IndexPath, for todo: ToDo) {
    let todoCount = indexPath.row
    todayTask.text = todo.todo
    todayTaskNumber.image =  UIImage(systemName: "\(todoCount).circle.fill")
    todayTaskCompleted.isSelected = todo.todoCompleted
    toggleButtonColor()
    if todo.todoCompleted {
      todayTaskCompleted.wiggle()
    }
  }
  
  func toggleButtonColor() {
    todayTaskCompleted.isSelected ? (todayTaskCompleted.tintColor = .systemOrange) :
      (todayTaskCompleted.tintColor = .systemGray6)
  }
  
  //MARK: - Helper Functions
  func textFieldDidBeginEditing(_ textField: UITextField) {
    print("textFieldDidBeginEditing")
    if let text = textField.text {
      if text.count > 0 {
        oldText = text
        print("oldText = \(oldText)")
      }
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    print("textFieldDidEndEditing")
    if let text = textField.text {
      newText = text
      print("newText = \(newText)")
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    processInput()
    return true
  }
  
  func processInput() {
    if let todoText = fetchInput() {
      // call delegate method to update datamodel
      if newText != oldText {
        delegate?.todayToDoUpdated(self, toDoUpdated: todoText)
      }
    }
    //    todayTask.text = ""
    todayTask.resignFirstResponder()
  }
  
  func fetchInput() -> String? {
    if let textCapture = todayTask.text?.trimmingCharacters(in: .whitespaces) {
      if textCapture.count >= 0 {
        return textCapture
      }
    }
    return nil
  }
  
  //MARK: - IBActions
  @IBAction func todayTaskEditingEnded(_ sender: UITextField) {
    processInput()
  }
  
  @IBAction func todayTaskTapped(_ sender: UIButton) {
    todayTaskCompleted.isSelected.toggle()
    // call delegate method to update datamodel
    delegate?.todayTaskCompletion(self, completionChanged: todayTaskCompleted.isSelected)
  }
}
