//
//  TodayToDoCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

protocol TodayTaskCellDelegate {
  func todayToDo( _ cell: TodayToDoCell, newToDoCreated newToDo: String)
  func todayTask(_ cell: TodayToDoCell, completionChanged completion: Bool)
}

class TodayToDoCell: UITableViewCell, UITextFieldDelegate {
  
  //MARK: - Properties
  public static let reuseIdentifier = "TodayTaskCell"
  var delegate: TodayTaskCellDelegate?

  
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
//    todayTaskCompleted.setImage(UIImage(named: "fav_star"), for: .normal)
//    todayTaskCompleted.tintColor = .systemGray6
    let backgroundView = UIView()
    backgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.85, blue: 0.7, alpha: 1)
    self.selectedBackgroundView = backgroundView
  }
  
  func configureTodayTaskCell(at indexPath: IndexPath, for todo: ToDo) {
    let todoCount = indexPath.row
    todayTask.text = todo.todo
    todayTaskNumber.image =  UIImage(systemName: "\(todoCount).circle.fill")
    todayTaskCompleted.isSelected = todo.todoCompleted
    toggleButtonColor()
  }
  
  func toggleButtonColor() {
    todayTaskCompleted.isSelected ? (todayTaskCompleted.tintColor = .systemOrange) :
      (todayTaskCompleted.tintColor = .systemGray6)
  }
  
  //MARK: - Helper Functions
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    processInput()
    return true
  }
  
  func processInput() {
    if let todayText = fetchInput() {
      // call delegate method to update datamodel
      delegate?.todayToDo(self, newToDoCreated: todayText)
    }
//    todayTask.text = ""
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
    todayTaskCompleted.isSelected.toggle()
    toggleButtonColor()
    if todayTaskCompleted.isSelected {
      todayTaskCompleted.wiggle()
    }
    // call delegate method to update datamodel
    delegate?.todayTask(self, completionChanged: todayTaskCompleted.isSelected)
  }
}
