//
//  HistorySummaryCell.swift
//  Focus
//
//  Created by Scott Bolin on 5/15/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class HistorySummaryCell: UITableViewCell {
  
  //MARK: - Properties
  public static let reuseIdentifier = "HistorySummaryCell"
  
  //MARK: - IBOutlets
  @IBOutlet weak var historySummaryCellLabel: UILabel!
  @IBOutlet weak var historySummaryCellToDoLabel: UILabel!
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
    
  }
  func configure() {
    historySummaryCellLabel.text = "Goal Count per Month"
    historySummaryCellToDoLabel.text = "Todo Count per Month"
  }
  
  func configureHistorySummaryCell(at indexPath: IndexPath, statistics: Statistics) {
    
    let section = indexPath.section
    let goalCount = statistics.goalCount[section]
    let goalCompleted = statistics.goalComplete[section]
    let goalDuration = statistics.goalDuration[section]
    
    let todoCount = statistics.todoCount[section]
    let todoCompleted = statistics.todoComplete[section]
    let todoDuration = statistics.todoDuration[section]
    
    historySummaryCellLabel.text = "\(goalCompleted) out of \(goalCount) goals completed in \(goalDuration) days"
    historySummaryCellToDoLabel.text = "\(todoCompleted) out of \(todoCount) tasks completed in \(todoDuration) days"
  }
}
