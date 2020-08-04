//
//  TodayGoalCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol TodayGoalCellDelegate {
  func todayGoalUpdated(_ cell: TodayGoalCell, updatedGoal: String)
  func todayGoalNew(_ cell: TodayGoalCell, newGoal goalText: String)
  
}

class TodayGoalCell: UITableViewCell, UITextFieldDelegate {
  
  //MARK: - Properties
  public static let reuseIdentifier = "TodayGoalCell"
  var delegate: TodayGoalCellDelegate?
  var oldText: String = ""
//  var newText: String = ""
  var validation = Validation()

  //MARK: - IBOutlets
  @IBOutlet weak var todayGoal: UITextField!
  @IBOutlet weak var todayGoalCompleted: UIButton!
  
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    todayGoal.delegate = self
  }
  
  //MARK: - Configuration
  func configureTodayGoalCell(at indexPath: IndexPath, for goal: Goal) {
    todayGoal.text = goal.goal
    todayGoalCompleted.isSelected = goal.goalCompleted
    toggleButton()
  }

  func toggleButton() {
    todayGoalCompleted.isSelected ? (todayGoalCompleted.tintColor = .systemRed) :
      (todayGoalCompleted.tintColor = .systemGray6)
    todayGoalCompleted.isSelected ? todayGoalCompleted.whirl() : nil
  }

  //MARK: - Helper Functions
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if let text = textField.text {
      oldText = text
      print("oldText: \(oldText)")
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
      print("newText: \(newText)")
    }
  }
 */
  
  func processInput() {
    guard let goalText = todayGoal.text else {
      print("todayGoal.text error")
      return
    }
    print("in processInput\ngoalText: \(goalText)")
    print("oldText: \(oldText)")
    let isValidated = validation.validatedText(newText: goalText, oldText: oldText)
    print("isValidated: \(isValidated)")
    if isValidated {
      delegate?.todayGoalUpdated(self, updatedGoal: goalText)
    } else {
      todayGoal.text = oldText
    }
    
    // old method:
    /*
    if let goalText = fetchInput() {
      // call cell delegate method to update datamodel
      if newText != oldText {
        delegate?.todayGoalUpdated(self, updatedGoal: goalText)
      }
    }
    */
    todayGoal.resignFirstResponder()
  }
  
  /*
  func fetchInput() -> String? {
    if let textCapture = todayGoal.text?.trimmingCharacters(in: .whitespaces) {
      if textCapture.count > 0 {
        return textCapture
      } else if textCapture.count == 0 {
        print("handle case when all goal text is deleted")
        delegate?.deleteTodayGoal(self)
        // deleting goal -> delete all associated todos
        // create new blank goal/todo set
        delegate?.todayGoalNew(self, newGoal: "New Goal")
      }
    }
    return nil
  }
 */
  
  //MARK:- IBActions
  @IBAction func todayGoalEditingEnded(_ sender: UITextField) {
    processInput()
  }
  
}

