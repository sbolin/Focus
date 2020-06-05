//
//  TodayGoalCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol TodayGoalCellDelegate {
  func todayGoal(_ cell: TodayGoalCell, newGoalCreated newGoal: String)
}

class TodayGoalCell: UITableViewCell, UITextFieldDelegate {
  
  //MARK: - Properties
  var delegate: TodayGoalCellDelegate?
  public static let reuseIdentifier = "TodayGoalCell"
  
  //MARK: - IBOutlets
  @IBOutlet weak var todayGoal: UITextField!
  @IBOutlet weak var todayGoalCompleted: UIButton!
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  
  //MARK: - Configure
  func configure() {
    todayGoal.delegate = self
    
    todayGoalCompleted.setImage(UIImage(named: "fav_star"), for: .normal)
    todayGoalCompleted.tintColor = .systemGray6
    let backgroundView = UIView()
    backgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.85, blue: 0.7, alpha: 1)
    self.selectedBackgroundView = backgroundView
  }
  
  func configureTodayGoalCell(at indexPath: IndexPath, for goal: Goal) {
    todayGoal.text = goal.goal
    todayGoalCompleted.isSpringLoaded = goal.goalCompleted
    if goal.goalCompleted {
      todayGoalCompleted.whirl()
    }
    toggleButtonColor()
  }
  
  func toggleButtonColor() {
    todayGoalCompleted.isSelected ? (todayGoalCompleted.tintColor = .systemOrange) :
      (todayGoalCompleted.tintColor = .systemGray6)
  }
  
  //MARK: - Helper Functions
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    processInput()
    return true
  }
  
  func processInput() {
    if let todayGoal = fetchInput() {
      // call cell delegate method to update datamodel
      delegate?.todayGoal(self, newGoalCreated: todayGoal)
    }
    todayGoal.text = ""
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

