//
//  HistoryFinalHeaderCell.swift
//  Focus
//
//  Created by Scott Bolin on 5/15/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class HistoryFinalHeaderCell: UITableViewHeaderFooterView {
  
  //MARK: - Properties
  public static let reuseIdentifier = "HistoryFinalHeaderCell"
  
  //MARK: - IBOutlets
  @IBOutlet weak var historyFinalHeaderCellLabel: UILabel!
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
}
