//
//  TodayGoalCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol NewTodayGoalCellDelegate {
  func newTodayGoal(_ cell: TodayGoalCell, newGoalCreated newGoal: String)
  func goalCompleted(_ cell: TodayGoalCell, completionChanged completion: Bool)
}

class TodayGoalCell: UITableViewCell, UITextFieldDelegate {
  
  //MARK: - Properties
  var delegate: NewTodayGoalCellDelegate?
  
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
//    todayGoalCompleted.setImage(UIImage(named: "fav_star"), for: .selected)
//    todayGoalCompleted.tintColor = .systemOrange
  }
  
  //MARK: - Helper Functions
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    processInput()
    return true
  }
  
  func processInput() {
    if let todayGoal = fetchInput() {
      delegate?.newTodayGoal(self, newGoalCreated: todayGoal)
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
  
  // goalComplete() is just a placeholder - this delegate method should be called in the ViewController when all the associated tasks are completed.
  
  func goalCompleted() {
    // Tint color, etc should be handled by delegate method in the ViewController
    todayGoalCompleted.isSelected.toggle()
    if todayGoalCompleted.isSelected {
      todayGoalCompleted.tintColor = .systemOrange
      todayGoalCompleted.whirl()
    }
    delegate?.goalCompleted(self, completionChanged: todayGoalCompleted.isSelected)
  }
  
  //MARK:- IBActions
  @IBAction func todayGoalEditingEnded(_ sender: UITextField) {
    processInput()
  }
  
}

