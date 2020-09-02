//
//  HistoryGoalCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class HistoryGoalCell: UITableViewCell {
  
  //MARK: - Properties
  public static let reuseIdentifier = "HistoryGoalCell"
  var dateText = DateFormatter()
  
  //MARK: - IBOutlets
  @IBOutlet weak var historyGoal: UITextField!
  @IBOutlet weak var historyGoalCompleted: UIButton!
  @IBOutlet weak var dateCreated: UILabel!
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    historyGoalCompleted.isEnabled = false
  }
  
  func configureHistoryGoalCell(at indexPath: IndexPath, for goal: Goal) {
    dateText.dateFormat = "dd MMM yy"
    historyGoal.text = goal.goal
    dateCreated.text = dateText.string(from: goal.goalDateCreated)
    historyGoalCompleted.isSelected = goal.goalCompleted
    toggleButtonColor()
  }
  
  func toggleButtonColor() {
    historyGoalCompleted.isSelected ? (historyGoalCompleted.tintColor = .systemRed) :
      (historyGoalCompleted.tintColor = .systemGray4)
  }
}
