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
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
}
