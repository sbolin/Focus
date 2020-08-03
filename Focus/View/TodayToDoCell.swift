//
//  TodayToDoCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol TodayTaskCellDelegate {
  func todayToDoUpdated( _ cell: TodayToDoCell, updatedToDo: String)
  func todayToDoNew( _ cell: TodayToDoCell, newToDo: String)
  func todayTaskCompletion(cell: TodayToDoCell, completionStatus completion: Bool)
}

class TodayToDoCell: UITableViewCell, UITextFieldDelegate {
  
  //MARK: - Properties
  public static let reuseIdentifier = "TodayTaskCell"
  var delegate: TodayTaskCellDelegate?
  var oldText: String = ""
  var newText: String = ""
  var todoExisted: Bool = false
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
    print("configureTodayTaskCell at s\(indexPath.section) r\(indexPath.row)")
    let todoCount = indexPath.row
    todayTask.text = todo.todo
    todayTaskCompleted.isSelected = todo.todoCompleted
    todayTaskNumber.image =  UIImage(systemName: "\(todoCount).circle.fill")
    todayTaskCompleted.isSelected ? (todayTaskCompleted.tintColor = .systemOrange) : (todayTaskCompleted.tintColor = .systemGray6)
  }
  
  func toggleButtonColor() {
    print("toggleButtonColor")
   todayTaskCompleted.isSelected ? (todayTaskCompleted.tintColor = .systemOrange) : (todayTaskCompleted.tintColor = .systemGray6)
  }
  
  func toggleButtonWiggle() {
    print("toggleButtonWiggle")
    todayTaskCompleted.showsTouchWhenHighlighted = true
    todayTaskCompleted.isSelected ? todayTaskCompleted.wiggle() : nil
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
        delegate?.todayToDoUpdated(self, updatedToDo: todoText)
      }
    }
    todayTask.resignFirstResponder()
  }
  
  func fetchInput() -> String? {
    if let textCapture = todayTask.text?.trimmingCharacters(in: .whitespaces) {
      if textCapture.count > 0 {
        return textCapture
      }
      delegate?.todayTaskCompletion(cell: self, completionStatus: false)
    }
    return nil
  }
  
  //MARK: - IBActions
  @IBAction func todayTaskEditingEnded(_ sender: UITextField) {
    processInput()
  }
  
  @IBAction func todayTaskTapped(_ sender: UIButton) {
    print("todayTaskTapped: \(sender)")
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
