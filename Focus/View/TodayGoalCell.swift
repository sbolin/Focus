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
  func todayGoal(_ cell: TodayGoalCell) -> Bool
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
  
  //Mark: Helper, call datamodel to check if all tasks are completed. If so, mark goal as completed and update UI
  func goalCompleted() {
    // call delegate method, returns Bool for goal completion status
    if let goalIsCompleted = delegate?.todayGoal(self) {
      if goalIsCompleted {
        todayGoalCompleted.isSelected.toggle()
        todayGoalCompleted.tintColor = .systemOrange
        todayGoalCompleted.whirl()
      }
    }
  }
  
  //MARK:- IBActions
  @IBAction func todayGoalEditingEnded(_ sender: UITextField) {
    processInput()
  }
  
}

