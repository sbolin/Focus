//
//  TodayGoalCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol TodayGoalCellDelegate {
  func modifyTodayGoal(_ cell: TodayGoalCell, modifyGoalText goalText: String)
    func newTodayGoal(_ cell: TodayGoalCell, newGoalText goalText: String)
    func deleteTodayGoal(_ cell: TodayGoalCell)
}

class TodayGoalCell: UITableViewCell, UITextFieldDelegate {
  
  //MARK: - Properties
  public static let reuseIdentifier = "TodayGoalCell"
  var delegate: TodayGoalCellDelegate?
  var oldText: String = ""
  var newText: String = ""
  var goalExisted: Bool = false
  
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
    if let goalText = fetchInput() {
      // call cell delegate method to update datamodel
      if newText != oldText {
        delegate?.modifyTodayGoal(self, modifyGoalText: goalText)
      }
    }
    todayGoal.resignFirstResponder()
  }
  
  func fetchInput() -> String? {
    if let textCapture = todayGoal.text?.trimmingCharacters(in: .whitespaces) {
      if textCapture.count > 0 {
        return textCapture
      } else if textCapture.count == 0 {
        print("handle case when all goal text is deleted")
        delegate?.deleteTodayGoal(self)
        // deleting goal -> delete all associated todos
        // create new blank goal/todo set
        delegate?.newTodayGoal(self, newGoalText: "New Goal")
      }
    }
    return nil
  }
  
  //MARK:- IBActions
  @IBAction func todayGoalEditingEnded(_ sender: UITextField) {
    processInput()
  }
  
}

