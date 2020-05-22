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
  
  //MARK: - IBOutlets
  @IBOutlet weak var historyGoal: UITextField!
  @IBOutlet weak var historyGoalCompleted: UIButton!
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
}
