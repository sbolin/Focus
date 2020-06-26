//
//  TodayGoalCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol TodayGoalCellDelegate {
  func todayGoal(_ cell: TodayGoalCell, todayGoalText goalText: String)
}

class TodayGoalCell: UITableViewCell, UITextFieldDelegate {
  
  //MARK: - Properties
  public static let reuseIdentifier = "TodayGoalCell"
  var delegate: TodayGoalCellDelegate?
  
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
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    processInput()
    return true
  }
  
  func processInput() {
    if let goalText = fetchInput() {
      // call cell delegate method to update datamodel
      delegate?.todayGoal(self, todayGoalText: goalText)
    }
    //    todayGoal.text = ""
    todayGoal.resignFirstResponder()
  }
  
  func fetchInput() -> String? {
    if let textCapture = todayGoal.text?.trimmingCharacters(in: .whitespaces) {
      return textCapture.count > 0 ? textCapture : nil
    }
    return nil
  }
  
  //MARK:- IBActions
  @IBAction func todayGoalEditingEnded(_ sender: UITextField) {
    processInput()
  }
  
}

