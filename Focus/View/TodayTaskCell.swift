//
//  TodayTaskCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol NewTodayTaskCellDelegate {
  func newTodayTask(_ cell: TodayTaskCell, newTaskCreated newTask: String)
  func newBlankTodayTask(_ cell: TodayGoalCell)
  func newTodayTaskCompleted(_ cell: TodayTaskCell, completionChanged completion: Bool)
}

class TodayTaskCell: UITableViewCell, UITextFieldDelegate {
  
  //MARK: - Properties
  var delegate: NewTodayTaskCellDelegate?
  
  //MARK: - IBOutlets
  @IBOutlet weak var todayTask: UITextField!
  @IBOutlet weak var todayTaskNumber: UIImageView!
  @IBOutlet weak var todayTaskCompleted: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
    
    // Initialization code
  }
  //MARK: - Configuration
  func configure() {
    todayTask.delegate = self
    
    todayTaskCompleted.setImage(UIImage(named: "fav_star"), for: .normal)
    todayTaskCompleted.tintColor = .lightGray
//    todayTaskCompleted.setImage(UIImage(named: "fav_star"), for: .selected)
//    todayTaskCompleted.tintColor = .systemOrange
  }
  
  //MARK: - Helper Functions
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    processInput()
    return true
  }
  
  func processInput() {
    if let todayText = fetchInput() {
      delegate?.newTodayTask(self, newTaskCreated: todayText)
    }
    todayTask.text = ""
    todayTask.resignFirstResponder()
  }
  
  func fetchInput() -> String? {
    if let textCapture = todayTask.text?.trimmingCharacters(in: .whitespaces) {
      return textCapture.count > 0 ? textCapture : nil
    }
    return nil
  }
  
  //MARK: - IBActions
  @IBAction func todayTaskEditingEnded(_ sender: UITextField) {
    processInput()
  }
  
  @IBAction func todayTaskTapped(_ sender: UIButton) {
    // Tint color, etc should be handled by delegate method in the ViewController
    todayTaskCompleted.isSelected.toggle()
    if todayTaskCompleted.isSelected {
      todayTaskCompleted.tintColor = .systemOrange
      todayTaskCompleted.wiggle()
    } else {
      todayTaskCompleted.tintColor = .systemGray6
    }
    delegate?.newTodayTaskCompleted(self, completionChanged: todayTaskCompleted.isSelected)
  }
}
