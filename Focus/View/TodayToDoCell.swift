//
//  TodayToDoCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol TodayTaskCellDelegate {
  func todayTaskUpdated( _ cell: TodayToDoCell, updatedTask: String)
  func todayTaskNew( _ cell: TodayToDoCell, newTask: String)
  func todayTaskCompletion(cell: TodayToDoCell, completionStatus completion: Bool)
}

class TodayToDoCell: UITableViewCell, UITextFieldDelegate {
  
  //MARK: - Properties
  public static let reuseIdentifier = "TodayTaskCell"
  var delegate: TodayTaskCellDelegate?
  var oldText: String = ""
//  var newText: String = ""
  var validation = Validation()
  
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
    todayTaskCompleted.isSelected = todo.todoCompleted
    todayTaskNumber.image =  UIImage(systemName: "\(todoCount).circle.fill")
    todayTaskCompleted.isSelected ? (todayTaskCompleted.tintColor = .systemOrange) : (todayTaskCompleted.tintColor = .systemGray6)
  }
  
//  func toggleButtonColor() {
//   todayTaskCompleted.isSelected ? (todayTaskCompleted.tintColor = .systemOrange) : (todayTaskCompleted.tintColor = .systemGray6)
//  }
//
//  func toggleButtonWiggle() {
//    todayTaskCompleted.isSelected ? todayTaskCompleted.wiggle() : nil
//  }
  
  //MARK: - Helper Functions
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if let text = textField.text {
      oldText = text
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool { // return key tapped
    if textField.text?.count == 0 {
      return false
    }
    processInput()
    return true
  }
  
  /*
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    if let text = textField.text {
      newText = text
    }
  }
 */
  
  func processInput() {
    guard let taskText = todayTask.text else {
      print("todayTask.text error")
      return
    }
    print("in processInput\nTaskText: \(taskText)")
    print("oldText: \(oldText)")
    let isValidated = validation.validatedText(newText: taskText, oldText: oldText)
    print("isValidated: \(isValidated)")
    if isValidated {
      delegate?.todayTaskUpdated(self, updatedTask: taskText)
    } else {
      todayTask.text = oldText
    }
    
    // old method:
    /*
    if let todoText = fetchInput() {
      // call delegate method to update datamodel
      if newText != oldText {
        delegate?.todayToDoUpdated(self, updatedToDo: todoText)
      }
    }
 */
    todayTask.resignFirstResponder()
  }
  
  /*
  func fetchInput() -> String? {
    if let textCapture = todayTask.text?.trimmingCharacters(in: .whitespaces) {
      if textCapture.count > 0 {
        return textCapture
      }
      delegate?.todayTaskCompletion(cell: self, completionStatus: false)
    }
    return nil
  }
 */
  
  //MARK: - IBActions
  @IBAction func todayTaskEditingEnded(_ sender: UITextField) {
    processInput()
  }
  
  @IBAction func todayTaskTapped(_ sender: UIButton) {
    // check if task exists before proceeding
    if todayTask.text?.count != 0 {
      sender.isSelected.toggle()
      
      if sender.isSelected {
        sender.tintColor = .systemOrange
        sender.wiggle()
      } else {
        sender.tintColor = .systemGray6
      }
      // call delegate method to update datamodel
      delegate?.todayTaskCompletion(cell: self, completionStatus: sender.isSelected)
    }
  }
}
