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
  
  func configureHistorySummaryCell(at indexPath: IndexPath, undoneGoalCount: Int, doneGoalCount: Int, undoneToDoCount: Int, doneToDoCount: Int) {
    historySummaryCellLabel.text = "\(undoneGoalCount) out of \(doneGoalCount) goals completed"
    historySummaryCellToDoLabel.text = "\(undoneToDoCount) out of \(doneToDoCount) tasks completed"
  }
}
